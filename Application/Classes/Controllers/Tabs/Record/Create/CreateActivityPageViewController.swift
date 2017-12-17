//
//  CreateActivityPageViewController.swift
//  TriMeter
//
//  Created by Bram Nouwen on 28/11/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//
/* Referenced
 - https://spin.atomicobject.com/2015/12/23/swift-uipageviewcontroller-tutorial/
 - https://spin.atomicobject.com/2016/02/11/move-uipageviewcontroller-dots/
 
 */

import UIKit

class CreateActivityPageViewController: UIPageViewController {
    
    var createActivityDelegate: CreateActivityPageViewControllerDelegate?

    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newCreateViewController("CreateActivity"),
                self.newCreateViewController("CreateGoal"),
                self.newCreateViewController("CreateData"),
                self.newCreateViewController("CreateSettings")]
    }()
    
    var controllerToLoad = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self
        
        //Checks if controllers are set
        if orderedViewControllers.first != nil {
            setViewControllers([orderedViewControllers[controllerToLoad]],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        createActivityDelegate?.createActivityPageViewController(self, didUpdatePageCount: orderedViewControllers.count)
        createActivityDelegate?.createActivityPageViewController(self, didUpdatePageIndex: controllerToLoad)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CreateActivityPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return orderedViewControllers.last
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            return orderedViewControllers.first
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    private func newCreateViewController(_ color: String) -> UIViewController {
        return UIStoryboard(name: "Create", bundle: nil).instantiateViewController(withIdentifier: "\(color)ViewController")
    }
    
}

extension CreateActivityPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if let firstViewController = viewControllers?.first,
            let index = orderedViewControllers.index(of: firstViewController) {
            createActivityDelegate?.createActivityPageViewController(self, didUpdatePageIndex: index)
        }
    }
    
}

protocol CreateActivityPageViewControllerDelegate: class {
    
    /**
     Called when the number of pages is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter count: the total number of pages.
     */
    func createActivityPageViewController(_ createActivityPageViewController: CreateActivityPageViewController,
                                    didUpdatePageCount count: Int)
    
    /**
     Called when the current index is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter index: the index of the currently visible page.
     */
    func createActivityPageViewController(_ createActivityPageViewController: CreateActivityPageViewController,
                                    didUpdatePageIndex index: Int)
    
}
