// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
enum L10n {

  enum Activity {
    /// Cycling
    static let cycling = L10n.tr("Localizable", "Activity.cycling")
    /// Running
    static let running = L10n.tr("Localizable", "Activity.running")
    /// Swimming
    static let swimming = L10n.tr("Localizable", "Activity.swimming")
    /// Triathlon
    static let triathlon = L10n.tr("Localizable", "Activity.triathlon")
    /// Walking
    static let walking = L10n.tr("Localizable", "Activity.walking")

    enum Triathlon {
      /// Olympic triathlon
      static let olympic = L10n.tr("Localizable", "Activity.triathlon.olympic")
      /// Sprint triathlon
      static let sprint = L10n.tr("Localizable", "Activity.triathlon.sprint")
      /// Super sprint triathlon
      static let superSprint = L10n.tr("Localizable", "Activity.triathlon.superSprint")
      /// Transition
      static let transition = L10n.tr("Localizable", "Activity.triathlon.transition")
    }
  }

  enum Adjust {
    /// calories
    static let calories = L10n.tr("Localizable", "Adjust.calories")
    /// kilometers
    static let distance = L10n.tr("Localizable", "Adjust.distance")
    /// minutes
    static let duration = L10n.tr("Localizable", "Adjust.duration")
    /// min/km
    static let pace = L10n.tr("Localizable", "Adjust.pace")

    enum Goal {
      /// Tap the buttons to add or subtract by %@
      static func description(_ p1: String) -> String {
        return L10n.tr("Localizable", "Adjust.goal.description", p1)
      }

      enum Title {
        /// Choose your 
        static let one = L10n.tr("Localizable", "Adjust.goal.title.one")
        /// .
        static let three = L10n.tr("Localizable", "Adjust.goal.title.three")
        ///  for 
        static let two = L10n.tr("Localizable", "Adjust.goal.title.two")
      }
    }
  }

  enum Choose {

    enum Data {

      enum Description {
        /// Tap to change, hold to rearrange.
        static let data = L10n.tr("Localizable", "Choose.data.description.data")
        ///  for 
        static let one = L10n.tr("Localizable", "Choose.data.description.one")
        /// And what data would you like to see?
        static let three = L10n.tr("Localizable", "Choose.data.description.three")
        /// .\n
        static let two = L10n.tr("Localizable", "Choose.data.description.two")
      }
    }

    enum Default {
      /// Load default for
      static let load = L10n.tr("Localizable", "Choose.default.load")
      /// Make default for
      static let make = L10n.tr("Localizable", "Choose.default.make")
    }

    enum Goal {

      enum Description {
        /// What do you want to achieve for \n
        static let one = L10n.tr("Localizable", "Choose.goal.description.one")
        /// ?
        static let two = L10n.tr("Localizable", "Choose.goal.description.two")
      }
    }

    enum Settings {

      enum Description {
        ///  for 
        static let one = L10n.tr("Localizable", "Choose.settings.description.one")
        /// Choose your settings for this activity.
        static let three = L10n.tr("Localizable", "Choose.settings.description.three")
        /// .\n
        static let two = L10n.tr("Localizable", "Choose.settings.description.two")
      }
    }

    enum Sport {

      enum Description {
        /// !
        static let five = L10n.tr("Localizable", "Choose.sport.description.five")
        /// preset
        static let four = L10n.tr("Localizable", "Choose.sport.description.four")
        /// What do you want to do? Choose a \n
        static let one = L10n.tr("Localizable", "Choose.sport.description.one")
        /// or pick a 
        static let three = L10n.tr("Localizable", "Choose.sport.description.three")
        /// sport 
        static let two = L10n.tr("Localizable", "Choose.sport.description.two")
      }
    }
  }

  enum Common {
    /// Continue
    static let continueText = L10n.tr("Localizable", "Common.continueText")
    /// Done
    static let done = L10n.tr("Localizable", "Common.done")
    /// Email
    static let email = L10n.tr("Localizable", "Common.email")
    /// Load
    static let load = L10n.tr("Localizable", "Common.load")
    /// Log in
    static let login = L10n.tr("Localizable", "Common.login")
    /// Password
    static let password = L10n.tr("Localizable", "Common.password")
    /// Already have an account? Log in here!
    static let toLogin = L10n.tr("Localizable", "Common.toLogin")
    /// No account yet? Register here!
    static let toRegister = L10n.tr("Localizable", "Common.toRegister")

    enum Createworkout {
      /// Create workout
      static let button = L10n.tr("Localizable", "Common.createWorkout.button")
      /// Create a structured workout by combining different sports and goals!
      static let description = L10n.tr("Localizable", "Common.createWorkout.description")
    }
  }

  enum Connect {
    /// Create an account or connect with Facebook or Strava, it's up to you!
    static let description = L10n.tr("Localizable", "Connect.description")
    /// or
    static let or = L10n.tr("Localizable", "Connect.or")
  }

  enum Data {
    /// Add...
    static let add = L10n.tr("Localizable", "Data.add")
    /// Clock
    static let clock = L10n.tr("Localizable", "Data.clock")
    /// current
    static let current = L10n.tr("Localizable", "Data.current")

    enum Calories {
      /// %d kcal
      static func amount(_ p1: Int) -> String {
        return L10n.tr("Localizable", "Data.calories.amount", p1)
      }
      /// Current calories
      static let part = L10n.tr("Localizable", "Data.calories.part")
      /// Calories
      static let total = L10n.tr("Localizable", "Data.calories.total")

      enum Part {
        /// Calories of the current part
        static let description = L10n.tr("Localizable", "Data.calories.part.description")
      }

      enum Remaining {
        /// Remaining current calories
        static let part = L10n.tr("Localizable", "Data.calories.remaining.part")
        /// Remaining calories
        static let total = L10n.tr("Localizable", "Data.calories.remaining.total")

        enum Part {
          /// Remaining calories of the current part
          static let description = L10n.tr("Localizable", "Data.calories.remaining.part.description")
        }

        enum Total {
          /// Remaining calories of the whole activity
          static let description = L10n.tr("Localizable", "Data.calories.remaining.total.description")
        }
      }

      enum Total {
        /// Calories of the whole activity
        static let description = L10n.tr("Localizable", "Data.calories.total.description")
      }
    }

    enum Caloriesactive {
      /// Current active calories
      static let part = L10n.tr("Localizable", "Data.caloriesActive.part")
      /// Active calories
      static let total = L10n.tr("Localizable", "Data.caloriesActive.total")

      enum Part {
        /// Active calories of the current part
        static let description = L10n.tr("Localizable", "Data.caloriesActive.part.description")
      }

      enum Remaining {
        /// Remaining current active calories
        static let part = L10n.tr("Localizable", "Data.caloriesActive.remaining.part")
        /// Remaining active calories
        static let total = L10n.tr("Localizable", "Data.caloriesActive.remaining.total")

        enum Part {
          /// Remaining active calories of the whole activity
          static let description = L10n.tr("Localizable", "Data.caloriesActive.remaining.part.description")
        }

        enum Total {
          /// Remaining active calories of the whole activity
          static let description = L10n.tr("Localizable", "Data.caloriesActive.remaining.total.description")
        }
      }

      enum Total {
        /// Active calories of the whole activity
        static let description = L10n.tr("Localizable", "Data.caloriesActive.total.description")
      }
    }

    enum Caloriestotal {
      /// Current total calories
      static let part = L10n.tr("Localizable", "Data.caloriesTotal.part")
      /// Total calories
      static let total = L10n.tr("Localizable", "Data.caloriesTotal.total")

      enum Part {
        /// Total calories of the current part
        static let description = L10n.tr("Localizable", "Data.caloriesTotal.part.description")
      }

      enum Remaining {
        /// Remaining current total calories
        static let part = L10n.tr("Localizable", "Data.caloriesTotal.remaining.part")
        /// Remaining total calories
        static let total = L10n.tr("Localizable", "Data.caloriesTotal.remaining.total")

        enum Part {
          /// Remaining total calories of the whole activity
          static let description = L10n.tr("Localizable", "Data.caloriesTotal.remaining.part.description")
        }

        enum Total {
          /// Remaining total calories of the whole activity
          static let description = L10n.tr("Localizable", "Data.caloriesTotal.remaining.total.description")
        }
      }

      enum Total {
        /// Total calories of the whole activity
        static let description = L10n.tr("Localizable", "Data.caloriesTotal.total.description")
      }
    }

    enum Clock {
      /// 00:00:00
      static let amount = L10n.tr("Localizable", "Data.clock.amount")
      /// The time
      static let description = L10n.tr("Localizable", "Data.clock.description")
    }

    enum Descent {
      /// %d m
      static func amount(_ p1: Int) -> String {
        return L10n.tr("Localizable", "Data.descent.amount", p1)
      }
      /// Current descent
      static let part = L10n.tr("Localizable", "Data.descent.part")
      /// Descent
      static let total = L10n.tr("Localizable", "Data.descent.total")

      enum Part {
        /// Descent during the current part
        static let description = L10n.tr("Localizable", "Data.descent.part.description")
      }

      enum Total {
        /// Descent during the whole activity
        static let description = L10n.tr("Localizable", "Data.descent.total.description")
      }
    }

    enum Distance {
      /// %.2f km
      static func amount(_ p1: Float) -> String {
        return L10n.tr("Localizable", "Data.distance.amount", p1)
      }
      /// Current distance
      static let part = L10n.tr("Localizable", "Data.distance.part")
      /// Distance
      static let total = L10n.tr("Localizable", "Data.distance.total")

      enum Part {
        /// Total distance of the current part
        static let description = L10n.tr("Localizable", "Data.distance.part.description")
      }

      enum Remaining {
        /// Current remaining distance
        static let part = L10n.tr("Localizable", "Data.distance.remaining.part")
        /// Remaining distance
        static let total = L10n.tr("Localizable", "Data.distance.remaining.total")

        enum Part {
          /// Remaining distance of the current part
          static let description = L10n.tr("Localizable", "Data.distance.remaining.part.description")
        }

        enum Total {
          /// Remaining distance of the whole activity
          static let description = L10n.tr("Localizable", "Data.distance.remaining.total.description")
        }
      }

      enum Total {
        /// Total distance of the whole activity
        static let description = L10n.tr("Localizable", "Data.distance.total.description")
      }
    }

    enum Duration {
      /// %d min
      static func amount(_ p1: Int) -> String {
        return L10n.tr("Localizable", "Data.duration.amount", p1)
      }
      /// Current duration
      static let part = L10n.tr("Localizable", "Data.duration.part")
      /// Duration
      static let total = L10n.tr("Localizable", "Data.duration.total")

      enum Part {
        /// Total duration of the current part
        static let description = L10n.tr("Localizable", "Data.duration.part.description")
      }

      enum Remaining {
        /// Current remaining duration
        static let part = L10n.tr("Localizable", "Data.duration.remaining.part")
        /// Remaining duration
        static let total = L10n.tr("Localizable", "Data.duration.remaining.total")

        enum Part {
          /// Remaining duration of the current part
          static let description = L10n.tr("Localizable", "Data.duration.remaining.part.description")
        }

        enum Total {
          /// Remaining duration of the whole activity
          static let description = L10n.tr("Localizable", "Data.duration.remaining.total.description")
        }
      }

      enum Total {
        /// Total duration of the whole activity
        static let description = L10n.tr("Localizable", "Data.duration.total.description")
      }
    }

    enum Elevation {
      /// %d m
      static func amount(_ p1: Int) -> String {
        return L10n.tr("Localizable", "Data.elevation.amount", p1)
      }
      /// Current elevation
      static let part = L10n.tr("Localizable", "Data.elevation.part")
      /// Elevation
      static let total = L10n.tr("Localizable", "Data.elevation.total")

      enum Part {
        /// Elevation during the current part
        static let description = L10n.tr("Localizable", "Data.elevation.part.description")
      }

      enum Total {
        /// Elevation during the whole activity
        static let description = L10n.tr("Localizable", "Data.elevation.total.description")
      }
    }

    enum Heartrate {
      /// %d bpm
      static func amount(_ p1: Int) -> String {
        return L10n.tr("Localizable", "Data.heartRate.amount", p1)
      }
      /// Heart rate
      static let current = L10n.tr("Localizable", "Data.heartRate.current")

      enum Average {
        /// Current average heart rate
        static let part = L10n.tr("Localizable", "Data.heartRate.average.part")
        /// Average heart rate
        static let total = L10n.tr("Localizable", "Data.heartRate.average.total")

        enum Part {
          /// Average heart rate during the current part
          static let description = L10n.tr("Localizable", "Data.heartRate.average.part.description")
        }

        enum Total {
          /// Average heart rate during the whole activity
          static let description = L10n.tr("Localizable", "Data.heartRate.average.total.description")
        }
      }

      enum Current {
        /// Heart rate at this moment
        static let description = L10n.tr("Localizable", "Data.heartRate.current.description")
      }
    }

    enum Pace {
      /// %d min/km
      static func amount(_ p1: Int) -> String {
        return L10n.tr("Localizable", "Data.pace.amount", p1)
      }
      /// Pace
      static let current = L10n.tr("Localizable", "Data.pace.current")

      enum Average {
        /// Current average pace
        static let part = L10n.tr("Localizable", "Data.pace.average.part")
        /// Average pace
        static let total = L10n.tr("Localizable", "Data.pace.average.total")

        enum Part {
          /// Average pace of the current part
          static let description = L10n.tr("Localizable", "Data.pace.average.part.description")
        }

        enum Total {
          /// Average pace of the whole activity
          static let description = L10n.tr("Localizable", "Data.pace.average.total.description")
        }
      }

      enum Current {
        /// Pace at this moment
        static let description = L10n.tr("Localizable", "Data.pace.current.description")
      }
    }

    enum Speed {
      /// %.2f km/h
      static func amount(_ p1: Float) -> String {
        return L10n.tr("Localizable", "Data.speed.amount", p1)
      }
      /// Speed
      static let current = L10n.tr("Localizable", "Data.speed.current")

      enum Average {
        /// Current average speed
        static let part = L10n.tr("Localizable", "Data.speed.average.part")
        /// Average speed
        static let total = L10n.tr("Localizable", "Data.speed.average.total")

        enum Part {
          /// Average speed of the current part
          static let description = L10n.tr("Localizable", "Data.speed.average.part.description")
        }

        enum Total {
          /// Average speed of the whole activity
          static let description = L10n.tr("Localizable", "Data.speed.average.total.description")
        }
      }

      enum Current {
        /// Speed at this moment
        static let description = L10n.tr("Localizable", "Data.speed.current.description")
      }
    }

    enum Steps {
      /// %d steps
      static func amount(_ p1: Int) -> String {
        return L10n.tr("Localizable", "Data.steps.amount", p1)
      }
      /// Current steps
      static let part = L10n.tr("Localizable", "Data.steps.part")
      /// Steps
      static let total = L10n.tr("Localizable", "Data.steps.total")

      enum Part {
        /// Steps during the current part
        static let description = L10n.tr("Localizable", "Data.steps.part.description")
      }

      enum Total {
        /// Steps during the whole activity
        static let description = L10n.tr("Localizable", "Data.steps.total.description")
      }
    }
  }

  enum Goal {
    /// Multiple
    static let multiple = L10n.tr("Localizable", "Goal.multiple")
    /// Finish!
    static let triathlon = L10n.tr("Localizable", "Goal.triathlon")

    enum Calories {
      /// %d kcal
      static func amount(_ p1: Int) -> String {
        return L10n.tr("Localizable", "Goal.calories.amount", p1)
      }
      /// Calories
      static let title = L10n.tr("Localizable", "Goal.calories.title")
    }

    enum Distance {
      /// %d km
      static func amount(_ p1: Int) -> String {
        return L10n.tr("Localizable", "Goal.distance.amount", p1)
      }
      /// Distance
      static let title = L10n.tr("Localizable", "Goal.distance.title")
    }

    enum Duration {
      /// %d min
      static func amount(_ p1: Int) -> String {
        return L10n.tr("Localizable", "Goal.duration.amount", p1)
      }
      /// Duration
      static let title = L10n.tr("Localizable", "Goal.duration.title")
    }

    enum Nothing {
      /// No goal
      static let amount = L10n.tr("Localizable", "Goal.nothing.amount")
      /// Nothing
      static let title = L10n.tr("Localizable", "Goal.nothing.title")
    }

    enum Pace {
      /// %d min/km
      static func amount(_ p1: Int) -> String {
        return L10n.tr("Localizable", "Goal.pace.amount", p1)
      }
      /// Pace
      static let title = L10n.tr("Localizable", "Goal.pace.title")
    }
  }

  enum Login {
    /// Log in with your TriMeter credentials.
    static let description = L10n.tr("Localizable", "Login.description")
    /// Something's wrong, try again.
    static let errorOne = L10n.tr("Localizable", "Login.errorOne")
    /// Nope, try clicking on "Forgot?".
    static let errorThree = L10n.tr("Localizable", "Login.errorThree")
    /// Still wrong, try a third time?
    static let errorTwo = L10n.tr("Localizable", "Login.errorTwo")
    /// Forgot?
    static let forgot = L10n.tr("Localizable", "Login.forgot")
    /// Atleast try to log in one time...
    static let forgotError = L10n.tr("Localizable", "Login.forgotError")
  }

  enum Record {
    /// Activity
    static let activity = L10n.tr("Localizable", "Record.activity")
    /// All good? Let's go!
    static let button = L10n.tr("Localizable", "Record.button")
    /// Data
    static let data = L10n.tr("Localizable", "Record.data")
    /// Goal
    static let goal = L10n.tr("Localizable", "Record.goal")
  }

  enum Register {
    /// Date of birth
    static let dateOfBirth = L10n.tr("Localizable", "Register.dateOfBirth")
    /// We're going to need some information, let's start with an email address and password.
    static let descriptionOne = L10n.tr("Localizable", "Register.descriptionOne")
    /// This is optional, however it is necessary for some features like advanced filtering and for the leaderboard and activity feed.
    static let descriptionTwo = L10n.tr("Localizable", "Register.descriptionTwo")
    /// Female
    static let female = L10n.tr("Localizable", "Register.female")
    /// First name
    static let firstName = L10n.tr("Localizable", "Register.firstName")
    /// Last name
    static let lastName = L10n.tr("Localizable", "Register.lastName")
    /// Male
    static let male = L10n.tr("Localizable", "Register.male")
    /// Password
    static let password = L10n.tr("Localizable", "Register.password")
    /// Register
    static let register = L10n.tr("Localizable", "Register.register")
    /// Weight
    static let weight = L10n.tr("Localizable", "Register.weight")
  }

  enum Settings {
    /// Off
    static let off = L10n.tr("Localizable", "Settings.off")
    /// On
    static let on = L10n.tr("Localizable", "Settings.on")

    enum Audio {
      /// Get motivational messages and summaries
      static let description = L10n.tr("Localizable", "Settings.audio.description")
      /// Audio feedback
      static let title = L10n.tr("Localizable", "Settings.audio.title")
    }

    enum Autopause {
      /// Pause the workout when you stop moving
      static let description = L10n.tr("Localizable", "Settings.autopause.description")
      /// Auto pause
      static let title = L10n.tr("Localizable", "Settings.autopause.title")
    }

    enum Countdown {
      /// Add a countdown to the start of the activity
      static let description = L10n.tr("Localizable", "Settings.countdown.description")
      /// Countdown
      static let title = L10n.tr("Localizable", "Settings.countdown.title")
    }

    enum Haptic {
      /// Get feedback in the form of vibrations
      static let description = L10n.tr("Localizable", "Settings.haptic.description")
      /// Haptic feedback
      static let title = L10n.tr("Localizable", "Settings.haptic.title")
    }

    enum Livelocation {
      /// Share your location with others
      static let description = L10n.tr("Localizable", "Settings.liveLocation.description")
      /// Live location
      static let title = L10n.tr("Localizable", "Settings.liveLocation.title")
    }
  }

  enum Welcome {
    /// The first app that lets you create workouts existing of multiple sports and goals, especially handy for triathletes but made for everyone!
    static let description = L10n.tr("Localizable", "Welcome.description")
    /// Welcome to
    static let welcome = L10n.tr("Localizable", "Welcome.welcome")
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length nesting type_body_length type_name

extension L10n {
  fileprivate static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
