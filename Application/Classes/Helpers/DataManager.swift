//
//  DataManager.swift
//  TriMeter
//
//  Created by Bram Nouwen on 30/11/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//
/* Referenced
 - https://stackoverflow.com/questions/29986957/save-custom-objects-into-nsuserdefaults
 
 */

import UIKit
import CoreData
import SugarRecord

class DataManager: NSObject {
    
    static let shared = DataManager()
    let defaults = UserDefaults.standard
    var db: CoreDataDefaultStorage?
    
    // Core data
    var TMActivities: [TMActivity] = [] {
        didSet {
            TMActivities = TMActivities.sorted(by: { $0.tableViewId < $1.tableViewId })
            TMCreateActivities = TMActivities.filter { $0.isPreset == false }
        }
    }
    var TMCreateActivities: [TMActivity] = [] {
        didSet {
            TMCreateActivities = TMCreateActivities.sorted(by: { $0.tableViewId < $1.tableViewId })
            guard let transition = try! db?.fetch(FetchRequest<TMActivity>().filtered(with: "title", equalTo: L10n.Activity.Triathlon.transition)).first else { return }
            TMCreateActivities.append(transition)
        }
    }
    
    var TMGoals: [TMGoal] = [] {
        didSet {
            TMGoals = TMGoals.sorted(by: { $0.id < $1.id })
        }
    }
    var TMDataList: [TMData] = [] {
        didSet {
            TMDataList = TMDataList.sorted(by: { $0.id < $1.id })
        }
    }
    
    var convertedDataList: [DataField] = []
    var dataListSections: [String: [DataField]] = [:]
    
    var TMDefaultData: TMDataLayout?
    var TMDefaultSettings: TMSettingsLayout?

    // Creating activity
    var createdActivity: Activity = Activity()
    var newPart: Activity = Activity(isPartOfWorkout: true)
    
    override init() {
        super.init()
        print("init datamanager")
        
        //Defaults at first launch when user has not changed them
        defaults.register(defaults: ["isCoreDataSetup": false])
        
        // Core data
        db = coreDataStorage()
        
        // Setup or fetch
        if defaults.bool(forKey: "isCoreDataSetup") {
            fetchCoreData()
        } else {
            setupCoreData()
            defaults.setValue(true, forKey: "isCoreDataSetup")
        }
        
        // Convert data list
        for TMData in TMDataList {
            convertedDataList.append(TMData.convert())
        }
        setDataInSections()
        
    }
    
    // Initializing CoreDataDefaultStorage
    func coreDataStorage() -> CoreDataDefaultStorage {
        let store = CoreDataStore.named("db")
        let bundle = Bundle(for: self.classForCoder)
        let model = CoreDataObjectModel.merged([bundle])
        let defaultStorage = try! CoreDataDefaultStorage(store: store, model: model)
        return defaultStorage
    }
    
    // Functions
    
    func getGoalById(_ id: Int) -> Goal {
        let goal = try! db?.fetch(FetchRequest<TMGoal>().filtered(with: "id", equalTo: "\(id)")).first
        return goal!.convert()
    }
    
    // MARK: - (Un)archiving defaults
    
    func archive(activity: Activity, key: String) {
        let activityData = NSKeyedArchiver.archivedData(withRootObject: activity)
        defaults.set(activityData, forKey: key)
        defaults.synchronize()
    }
    
    func unarchive(key: String) -> Activity {
        if let object = defaults.object(forKey: key) {
            let data = object as! Data
            let activity = NSKeyedUnarchiver.unarchiveObject(with: data) as! Activity
            return activity
        }
        print("Activity for key doesn't exist")
        return Activity()
    }
    
    // Create/update/delete activity
    
    func activityExists(_ activity: Activity) -> Bool {
        guard let id = activity.tableViewId else {
            return false
        }
        guard (try! db?.fetch(FetchRequest<TMActivity>().filtered(with: "tableViewId", equalTo: "\(id)")).first) != nil else {
            return false
        }
        return true
    }
    
    func save(_ activity: Activity) {
        guard let db = db else { return }
        
        do {
            try db.operation { (context, save) throws -> Void in
                
                let new: TMActivity = try! context.create()
                new.tableViewId = Int32(activity.tableViewId!)
                new.title = activity.title
                new.iconName = "saved"
                new.isPartOfWorkout = false
                new.isPreset = true
                
                let newActivity = new.convert()
                newActivity.parts = activity.parts
                self.archive(activity: newActivity, key: "\(newActivity.tableViewId!)")
                
                // Reset created activity
                self.createdActivity = Activity()
                
                save()
            }
        } catch {
            print("Something went wrong setting up core data (dataManager)")
        }
    }
    
    func update(_ activity: Activity) {
        guard let db = db else { return }
        
        do {
            try db.operation { (context, save) throws -> Void in
                
                guard let old = try! context.fetch(FetchRequest<TMActivity>().filtered(with: "tableViewId", equalTo: "\(activity.tableViewId!)")).first else { return }
                old.title = activity.title
                
                let oldActivity = old.convert()
                oldActivity.parts = activity.parts
                self.archive(activity: oldActivity, key: "\(oldActivity.tableViewId!)")
                
                // Reset created activity
                self.createdActivity = Activity()
                
                save()
            }
        } catch {
            print("Something went wrong setting up core data (dataManager)")
        }
    }
    
    func delete(_ activity: Activity) {
        guard let db = db else { return }
        
        do {
            try db.operation { (context, save) throws -> Void in
                
                guard let old = try! context.fetch(FetchRequest<TMActivity>().filtered(with: "tableViewId", equalTo: "\(activity.tableViewId!)")).first else { return }
                
                self.defaults.removeObject(forKey: "\(old.tableViewId)")
                
                // Reset created activity
                self.createdActivity = Activity()
                try context.remove(old)
                save()
            }
        } catch {
            print("Something went wrong setting up core data (dataManager)")
        }
    }

    /*
     Duration: 0 1 2 3
     Pace: 4 5 6
     Distance: 7 8 9 10
     Speed: 11 12 13
     Calories: 14 15 16 17
     Heart rate: 18 19 20
     Steps: 21 22
     Elevation: 23 24
     Descent: 25 26
     Clock: 27
     */
    func setDataInSections() {
        
        dataListSections["Duration"] = [convertedDataList[0],
                                        convertedDataList[1],
                                        convertedDataList[2],
                                        convertedDataList[3]]
        
        dataListSections["Pace"] = [convertedDataList[4],
                                        convertedDataList[5],
                                        convertedDataList[6]]
        
        dataListSections["Distance"] = [convertedDataList[7],
                                        convertedDataList[8],
                                        convertedDataList[9],
                                        convertedDataList[10]]
        
        dataListSections["Speed"] = [convertedDataList[11],
                                        convertedDataList[12],
                                        convertedDataList[13]]
        
        dataListSections["Calories"] = [convertedDataList[14],
                                        convertedDataList[15],
                                        convertedDataList[16],
                                        convertedDataList[17]]
        
        dataListSections["Heart rate"] = [convertedDataList[18],
                                        convertedDataList[19],
                                        convertedDataList[20]]
        
        dataListSections["Steps"] = [convertedDataList[21],
                                        convertedDataList[22]]
        
        dataListSections["Elevation"] = [convertedDataList[23],
                                        convertedDataList[24]]
        
        dataListSections["Descent"] = [convertedDataList[25],
                                         convertedDataList[26]]
        
        dataListSections["Clock"] = [convertedDataList[27]]
        
    }
    
    // MARK: - Core data setup + fetching
    
    func setupCoreData() {
        guard let db = db else { return }
        let defaultPredicate: NSPredicate = NSPredicate(format: "id == %@", "999")
        
        //first create all data options
        TMDataList = try! db.fetch(FetchRequest<TMData>())
        if TMDataList.count == 0 {
            createDataObjects()
            TMDataList = try! db.fetch(FetchRequest<TMData>())
        }
        
        //then create the default data layout (duration, avg pace, distance and current heartrate)
        TMDefaultData = try! db.fetch(FetchRequest<TMDataLayout>().filtered(with: defaultPredicate)).first
        if TMDefaultData == nil {
            createDefaultDataLayout()
            TMDefaultData = try! db.fetch(FetchRequest<TMDataLayout>().filtered(with: defaultPredicate)).first
        }

        //then the default settings (everything off except countdown for 3 seconds)
        TMDefaultSettings = try! db.fetch(FetchRequest<TMSettingsLayout>().filtered(with: defaultPredicate)).first
        if TMDefaultSettings == nil {
            createDefaultSettingsLayout()
            TMDefaultSettings = try! db.fetch(FetchRequest<TMSettingsLayout>().filtered(with: defaultPredicate)).first
        }

        //then the goals that can be set
        TMGoals = try! db.fetch(FetchRequest<TMGoal>())
        if TMGoals.count == 0 {
            createGoalObjects()
            TMGoals = try! db.fetch(FetchRequest<TMGoal>())
        }
        
        //finally all the preset activities with the default data and settings
        TMActivities = try! db.fetch(FetchRequest<TMActivity>().filtered(with: "isPartOfWorkout", equalTo: "false"))
        if TMActivities.count == 0 {
            createDefaultActivities()
            TMActivities = try! db.fetch(FetchRequest<TMActivity>().filtered(with: "isPartOfWorkout", equalTo: "false"))
        }
        print("Setting up coredata completed")
    }
    
    func fetchCoreData() {
        guard let db = db else { return }
        let defaultPredicate: NSPredicate = NSPredicate(format: "id == %@", "999")
        
        TMDataList = try! db.fetch(FetchRequest<TMData>())
        TMDefaultData = try! db.fetch(FetchRequest<TMDataLayout>().filtered(with: defaultPredicate)).first
        TMDefaultSettings = try! db.fetch(FetchRequest<TMSettingsLayout>().filtered(with: defaultPredicate)).first
        TMGoals = try! db.fetch(FetchRequest<TMGoal>())
        TMActivities = try! db.fetch(FetchRequest<TMActivity>().filtered(with: "isPartOfWorkout", equalTo: "false"))
        
        print("Fetching coredata completed")
    }
    
    // Creates the high-level ones in coredata, inserts them into defaults
    func createDefaultActivities() {
        guard let db = db else { return }
        let defaultPredicate: NSPredicate = NSPredicate(format: "id == %@", "999")
        
        do {
            try db.operation { (context, save) throws -> Void in
                
                let defaultDataLayout = try! context.fetch(FetchRequest<TMDataLayout>().filtered(with: defaultPredicate)).first
                let defaultSettings = try! context.fetch(FetchRequest<TMSettingsLayout>().filtered(with: defaultPredicate)).first
                let noGoal = try! context.fetch(FetchRequest<TMGoal>().filtered(with: "title", equalTo: L10n.Goal.Nothing.title)).first
                
                let walking: TMActivity = try! context.new()
                walking.tableViewId = 0
                walking.title = L10n.Activity.walking
                walking.iconName = "walking"
                walking.dataLayout = defaultDataLayout
                walking.settingsLayout = defaultSettings
                walking.isPartOfWorkout = false
                walking.isPreset = false
                
                let walkingActivity = walking.convert()
                walkingActivity.goal = noGoal?.convert()
                let walkingData = NSKeyedArchiver.archivedData(withRootObject: walkingActivity)
                self.defaults.set(walkingData, forKey: "0")

                let running: TMActivity = try! context.create()
                running.tableViewId = 1
                running.title = L10n.Activity.running
                running.iconName = "running"
                running.dataLayout = defaultDataLayout
                running.settingsLayout = defaultSettings
                running.isPartOfWorkout = false
                running.isPreset = false
                
                let runningActivity = running.convert()
                runningActivity.goal = noGoal?.convert()
                let runningData = NSKeyedArchiver.archivedData(withRootObject: runningActivity)
                self.defaults.set(runningData, forKey: "1")
                self.defaults.set(runningData, forKey: "currentActivity") // This will be the default activity on first launch
                
                let cycling: TMActivity = try! context.create()
                cycling.tableViewId = 2
                cycling.title = L10n.Activity.cycling
                cycling.iconName = "cycling"
                cycling.dataLayout = defaultDataLayout
                cycling.settingsLayout = defaultSettings
                cycling.isPartOfWorkout = false
                cycling.isPreset = false
                
                let cyclingActivity = cycling.convert()
                cyclingActivity.goal = noGoal?.convert()
                let cyclingData = NSKeyedArchiver.archivedData(withRootObject: cyclingActivity)
                self.defaults.set(cyclingData, forKey: "2")

                let swimming: TMActivity = try! context.create()
                swimming.tableViewId = 3
                swimming.title = L10n.Activity.swimming
                swimming.iconName = "swimming"
                swimming.dataLayout = defaultDataLayout
                swimming.settingsLayout = defaultSettings
                swimming.isPartOfWorkout = false
                swimming.isPreset = false
                
                let swimmingActivity = swimming.convert()
                swimmingActivity.goal = noGoal?.convert()
                let swimmingData = NSKeyedArchiver.archivedData(withRootObject: swimmingActivity)
                self.defaults.set(swimmingData, forKey: "3")
                
                let superSprint: TMActivity = try! context.create()
                superSprint.tableViewId = 4
                superSprint.title = L10n.Activity.Triathlon.superSprint
                superSprint.iconName = "saved"
                superSprint.isPartOfWorkout = false
                superSprint.isPreset = true
                
                let superSprintActivity = superSprint.convert()
                self.setTriValues(for: superSprintActivity, in: context, swim: 400, cycle: 10000, run: 2500)
                let superSprintData = NSKeyedArchiver.archivedData(withRootObject: superSprintActivity)
                self.defaults.set(superSprintData, forKey: "4")

                let sprint: TMActivity = try! context.create()
                sprint.tableViewId = 5
                sprint.title = L10n.Activity.Triathlon.sprint
                sprint.iconName = "saved"
                sprint.isPartOfWorkout = false
                sprint.isPreset = true
                
                let sprintActivity = sprint.convert()
                self.setTriValues(for: sprintActivity, in: context, swim: 750, cycle: 20000, run: 5000)
                let sprintData = NSKeyedArchiver.archivedData(withRootObject: sprintActivity)
                self.defaults.set(sprintData, forKey: "5")
                
                let olympic: TMActivity = try! context.create()
                olympic.tableViewId = 6
                olympic.title = L10n.Activity.Triathlon.olympic
                olympic.iconName = "saved"
                olympic.isPartOfWorkout = false
                olympic.isPreset = true
                
                let olympicActivity = olympic.convert()
                self.setTriValues(for: olympicActivity, in: context, swim: 1500, cycle: 40000, run: 10000)
                let olympicData = NSKeyedArchiver.archivedData(withRootObject: olympicActivity)
                self.defaults.set(olympicData, forKey: "6")
                
                let transition: TMActivity = try! context.create()
                transition.title = L10n.Activity.Triathlon.transition
                transition.iconName = "transition"
                transition.isPartOfWorkout = true
                transition.isPreset = false
                transition.dataLayout = defaultDataLayout
                transition.settingsLayout = defaultSettings
                
                save()
            }
        } catch {
            print("Something went wrong setting up core data (dataManager)")
        }
    }
    
    func setTriValues(for triathlon: Activity, in context: Context, swim: Int, cycle: Int, run: Int) {
        let distanceGoal = try! context.fetch(FetchRequest<TMGoal>().filtered(with: "title", equalTo: L10n.Goal.Distance.title)).first
        
        let triSwim = Activity(tableViewId: nil,
                               title: L10n.Activity.swimming,
                               iconName: "swimming",
                               goal: distanceGoal?.convert(),
                               dataLayout: TMDefaultData?.convert(),
                               settingsLayout: TMDefaultSettings?.convert(),
                               isPartOfWorkout: true,
                               partId: 1,
                               parts: nil)
        triSwim.goal?.amount = swim
        
        let T1 = Activity(tableViewId: nil,
                          title: L10n.Activity.Triathlon.transition,
                          iconName: nil,
                          goal: nil,
                          dataLayout: TMDefaultData?.convert(),
                          settingsLayout: TMDefaultSettings?.convert(),
                          isPartOfWorkout: true,
                          partId: 2,
                          parts: nil)
        
        let triCycle = Activity(tableViewId: nil,
                               title: L10n.Activity.cycling,
                               iconName: "cycling",
                               goal: distanceGoal?.convert(),
                               dataLayout: TMDefaultData?.convert(),
                               settingsLayout: TMDefaultSettings?.convert(),
                               isPartOfWorkout: true,
                               partId: 3,
                               parts: nil)
        triCycle.goal?.amount = cycle

        let T2 = Activity(tableViewId: nil,
                          title: L10n.Activity.Triathlon.transition,
                          iconName: nil,
                          goal: nil,
                          dataLayout: TMDefaultData?.convert(),
                          settingsLayout: TMDefaultSettings?.convert(),
                          isPartOfWorkout: true,
                          partId: 4,
                          parts: nil)
        
        let triRun = Activity(tableViewId: nil,
                              title: L10n.Activity.running,
                              iconName: "running",
                              goal: distanceGoal?.convert(),
                              dataLayout: TMDefaultData?.convert(),
                              settingsLayout: TMDefaultSettings?.convert(),
                              isPartOfWorkout: true,
                              partId: 5,
                              parts: nil)
        triRun.goal?.amount = run
        
        triathlon.parts = [triSwim, T1, triCycle, T2, triRun]
    }
    
    func createDefaultDataLayout() {
        guard let db = db else { return }
        do {
            try db.operation { (context, save) throws -> Void in
                let defaultData: TMDataLayout = try! context.create()
                defaultData.id = 999

                let spot1: TMData = (try! context.fetch(FetchRequest<TMData>().filtered(with: "id", equalTo: "0")).first)!
                spot1.spot = 0
                let spot2: TMData = (try! context.fetch(FetchRequest<TMData>().filtered(with: "id", equalTo: "5")).first)!
                spot2.spot = 1
                let spot3: TMData = (try! context.fetch(FetchRequest<TMData>().filtered(with: "id", equalTo: "7")).first)!
                spot3.spot = 2
                let spot4: TMData = (try! context.fetch(FetchRequest<TMData>().filtered(with: "id", equalTo: "18")).first)!
                spot4.spot = 3
                
                defaultData.data = [spot1, spot2, spot3, spot4]
                save()
            }
        } catch {
            print("Error creating default data layout")
        }
    }
    
    func createDefaultSettingsLayout() {
        guard let db = db else { return }
        do {
            try db.operation { (context, save) throws -> Void in
                let defaultSettings: TMSettingsLayout = try! context.create()
                defaultSettings.id = 999
                
                defaultSettings.liveLocation = false
                defaultSettings.countdown = false
                defaultSettings.countdownAmount = 3
                defaultSettings.autopause = false
                defaultSettings.audio = false
                defaultSettings.haptic = false
                
                save()
            }
        } catch {
            print("Error creating default data layout")
        }
    }
    
    func createGoalObjects() {
        guard let db = db else { return }
        do {
            try db.operation { (context, save) throws -> Void in
                let duration: TMGoal = try! context.create()
                duration.id = 0
                duration.title = L10n.Goal.Duration.title
                duration.iconName = "duration"
                duration.amount = 0
                duration.descriptionString = L10n.Goal.Duration.amount(Int(duration.amount))
                self.defaults.set(0, forKey: "previousDuration")
                
                let pace: TMGoal = try! context.create()
                pace.id = 1
                pace.title = L10n.Goal.Pace.title
                pace.iconName = "pace"
                pace.amount = 0
                pace.descriptionString = L10n.Goal.Pace.amount(Int(duration.amount))
                self.defaults.set(0, forKey: "previousPace")
                
                let distance: TMGoal = try! context.create()
                distance.id = 2
                distance.title = L10n.Goal.Distance.title
                distance.iconName = "distance"
                distance.amount = 0
                distance.descriptionString = L10n.Goal.Distance.amount(Int(duration.amount))
                self.defaults.set(0, forKey: "previousDistance")
                
                let calories: TMGoal = try! context.create()
                calories.id = 3
                calories.title = L10n.Goal.Calories.title
                calories.iconName = "calories"
                calories.amount = 0
                calories.descriptionString = L10n.Goal.Calories.amount(Int(duration.amount))
                self.defaults.set(0, forKey: "previousCalories")
                
                let nothing: TMGoal = try! context.create()
                nothing.id = 4
                nothing.title = L10n.Goal.Nothing.title
                nothing.iconName = "nothing"
                nothing.amount = 0
                nothing.descriptionString = L10n.Goal.Nothing.amount
                
                save()
            }
        } catch {
            print("Error creating default data layout")
        }
    }
    
    func createDataObjects() {
        do {
            try db?.operation { (context, save) throws -> Void in
                
                // Duration
                let duration: TMData = try! context.create()
                duration.title = L10n.Data.Duration.total
                duration.descriptionString = L10n.Data.Duration.Total.description
                duration.iconString = "duration"
                duration.id = 0
                duration.amountString = L10n.Data.Duration.amount(0)
                
                let durationCurrent: TMData = try! context.create()
                durationCurrent.title = L10n.Data.Duration.part
                durationCurrent.descriptionString = L10n.Data.Duration.Part.description
                durationCurrent.iconString = "duration"
                durationCurrent.id = 1
                durationCurrent.amountString = L10n.Data.Duration.amount(0)
                
                let durationRemaining: TMData = try! context.create()
                durationRemaining.title = L10n.Data.Duration.Remaining.total
                durationRemaining.descriptionString = L10n.Data.Duration.Remaining.Total.description
                durationRemaining.iconString = "duration"
                durationRemaining.id = 2
                durationRemaining.amountString = L10n.Data.Duration.amount(0)
                
                let durationRemainingCurrent: TMData = try! context.create()
                durationRemainingCurrent.title = L10n.Data.Duration.Remaining.part
                durationRemainingCurrent.descriptionString = L10n.Data.Duration.Remaining.Part.description
                durationRemainingCurrent.iconString = "duration"
                durationRemainingCurrent.id = 3
                durationRemainingCurrent.amountString = L10n.Data.Duration.amount(0)
                
                // Pace
                let pace: TMData = try! context.create()
                pace.title = L10n.Data.Pace.current
                pace.descriptionString = L10n.Data.Pace.Current.description
                pace.iconString = "pace"
                pace.id = 4
                pace.amountString = L10n.Data.Pace.amount(0)
                
                let paceAvgTotal: TMData = try! context.create()
                paceAvgTotal.title = L10n.Data.Pace.Average.total
                paceAvgTotal.descriptionString = L10n.Data.Pace.Average.Total.description
                paceAvgTotal.iconString = "pace"
                paceAvgTotal.id = 5
                paceAvgTotal.amountString = L10n.Data.Pace.amount(0)
                
                let paceAvgPart: TMData = try! context.create()
                paceAvgPart.title = L10n.Data.Pace.Average.part
                paceAvgPart.descriptionString = L10n.Data.Pace.Average.Part.description
                paceAvgPart.iconString = "pace"
                paceAvgPart.id = 6
                paceAvgPart.amountString = L10n.Data.Pace.amount(0)
                
                // Distance
                let distance: TMData = try! context.create()
                distance.title = L10n.Data.Distance.total
                distance.descriptionString = L10n.Data.Distance.Total.description
                distance.iconString = "distance"
                distance.id = 7
                distance.amountString = L10n.Data.Distance.amount(0)
                
                let distanceCurrent: TMData = try! context.create()
                distanceCurrent.title = L10n.Data.Distance.part
                distanceCurrent.descriptionString = L10n.Data.Distance.Part.description
                distanceCurrent.iconString = "distance"
                distanceCurrent.id = 8
                distanceCurrent.amountString = L10n.Data.Distance.amount(0)
                
                let distanceRemaining: TMData = try! context.create()
                distanceRemaining.title = L10n.Data.Distance.Remaining.total
                distanceRemaining.descriptionString = L10n.Data.Distance.Remaining.Total.description
                distanceRemaining.iconString = "distance"
                distanceRemaining.id = 9
                distanceRemaining.amountString = L10n.Data.Distance.amount(0)
                
                let distanceRemainingCurrent: TMData = try! context.create()
                distanceRemainingCurrent.title = L10n.Data.Distance.Remaining.part
                distanceRemainingCurrent.descriptionString = L10n.Data.Distance.Remaining.Part.description
                distanceRemainingCurrent.iconString = "distance"
                distanceRemainingCurrent.id = 10
                distanceRemainingCurrent.amountString = L10n.Data.Distance.amount(0)
                
                // Speed
                let speed: TMData = try! context.create()
                speed.title = L10n.Data.Speed.current
                speed.descriptionString = L10n.Data.Speed.Current.description
                speed.iconString = "speed"
                speed.id = 11
                speed.amountString = L10n.Data.Speed.amount(0)
                
                let speedAvgTotal: TMData = try! context.create()
                speedAvgTotal.title = L10n.Data.Speed.Average.total
                speedAvgTotal.descriptionString = L10n.Data.Speed.Average.Total.description
                speedAvgTotal.iconString = "speed"
                speedAvgTotal.id = 12
                speedAvgTotal.amountString = L10n.Data.Speed.amount(0)
                
                let speedAvgPart: TMData = try! context.create()
                speedAvgPart.title = L10n.Data.Speed.Average.part
                speedAvgPart.descriptionString = L10n.Data.Speed.Average.Part.description
                speedAvgPart.iconString = "speed"
                speedAvgPart.id = 13
                speedAvgPart.amountString = L10n.Data.Speed.amount(0)
                
                // Calories
                let calories: TMData = try! context.create()
                calories.title = L10n.Data.Calories.total
                calories.descriptionString = L10n.Data.Calories.Total.description
                calories.iconString = "calories"
                calories.id = 14
                calories.amountString = L10n.Data.Calories.amount(0)
                
                let caloriesCurrent: TMData = try! context.create()
                caloriesCurrent.title = L10n.Data.Calories.part
                caloriesCurrent.descriptionString = L10n.Data.Calories.Part.description
                caloriesCurrent.iconString = "calories"
                caloriesCurrent.id = 15
                caloriesCurrent.amountString = L10n.Data.Calories.amount(0)
                
                let caloriesRemaining: TMData = try! context.create()
                caloriesRemaining.title = L10n.Data.Calories.Remaining.total
                caloriesRemaining.descriptionString = L10n.Data.Calories.Remaining.Total.description
                caloriesRemaining.iconString = "calories"
                caloriesRemaining.id = 16
                caloriesRemaining.amountString = L10n.Data.Calories.amount(0)
                
                let caloriesRemainingCurrent: TMData = try! context.create()
                caloriesRemainingCurrent.title = L10n.Data.Calories.Remaining.part
                caloriesRemainingCurrent.descriptionString = L10n.Data.Calories.Remaining.Part.description
                caloriesRemainingCurrent.iconString = "calories"
                caloriesRemainingCurrent.id = 17
                caloriesRemainingCurrent.amountString = L10n.Data.Calories.amount(0)
                
                // Heart rate
                let heartRate: TMData = try! context.create()
                heartRate.title = L10n.Data.Heartrate.current
                heartRate.descriptionString = L10n.Data.Heartrate.Current.description
                heartRate.iconString = "heart"
                heartRate.id = 18
                heartRate.amountString = L10n.Data.Heartrate.amount(0)
                
                let heartRateAvgTotal: TMData = try! context.create()
                heartRateAvgTotal.title = L10n.Data.Heartrate.Average.total
                heartRateAvgTotal.descriptionString = L10n.Data.Heartrate.Average.Total.description
                heartRateAvgTotal.iconString = "heart"
                heartRateAvgTotal.id = 19
                heartRateAvgTotal.amountString = L10n.Data.Heartrate.amount(0)
                
                let heartRateAvgPart: TMData = try! context.create()
                heartRateAvgPart.title = L10n.Data.Heartrate.Average.part
                heartRateAvgPart.descriptionString = L10n.Data.Heartrate.Average.Part.description
                heartRateAvgPart.iconString = "heart"
                heartRateAvgPart.id = 20
                heartRateAvgPart.amountString = L10n.Data.Heartrate.amount(0)
                
                // Steps
                let steps: TMData = try! context.create()
                steps.title = L10n.Data.Steps.total
                steps.descriptionString = L10n.Data.Steps.Total.description
                steps.iconString = "steps"
                steps.id = 21
                steps.amountString = L10n.Data.Steps.amount(0)
                
                let stepsCurrent: TMData = try! context.create()
                stepsCurrent.title = L10n.Data.Steps.part
                stepsCurrent.descriptionString = L10n.Data.Steps.Part.description
                stepsCurrent.iconString = "steps"
                stepsCurrent.id = 22
                stepsCurrent.amountString = L10n.Data.Steps.amount(0)
                
                // Elevation
                let elevation: TMData = try! context.create()
                elevation.title = L10n.Data.Elevation.total
                elevation.descriptionString = L10n.Data.Elevation.Total.description
                elevation.iconString = "elevation"
                elevation.id = 23
                elevation.amountString = L10n.Data.Elevation.amount(0)
                
                let elevationCurrent: TMData = try! context.create()
                elevationCurrent.title = L10n.Data.Elevation.part
                elevationCurrent.descriptionString = L10n.Data.Elevation.Part.description
                elevationCurrent.iconString = "elevation"
                elevationCurrent.id = 24
                elevationCurrent.amountString = L10n.Data.Elevation.amount(0)
                
                // Descent
                let descent: TMData = try! context.create()
                descent.title = L10n.Data.Descent.total
                descent.descriptionString = L10n.Data.Descent.Total.description
                descent.iconString = "descent"
                descent.id = 25
                descent.amountString = L10n.Data.Descent.amount(0)
                
                let descentCurrent: TMData = try! context.create()
                descentCurrent.title = L10n.Data.Descent.part
                descentCurrent.descriptionString = L10n.Data.Descent.Part.description
                descentCurrent.iconString = "descent"
                descentCurrent.id = 26
                descentCurrent.amountString = L10n.Data.Descent.amount(0)
                
                // Clock
                let clock: TMData = try! context.create()
                clock.title = L10n.Data.clock
                clock.descriptionString = L10n.Data.Clock.description
                clock.iconString = "duration"
                clock.id = 27
                clock.amountString = L10n.Data.Clock.amount

                save()
            }
        }
        catch {
            print("Something went wrong setting up core data (dataManager)")
        }
    }
    
}
