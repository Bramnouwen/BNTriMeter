//
//  TabBarController.swift
//  TriMeter
//
//  Created by Bram Nouwen on 27/11/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedIndex = 2
        
        tabBar.items![0].title = L10n.Tabs.feed
        tabBar.items![1].title = L10n.Tabs.profile
        tabBar.items![2].title = L10n.Tabs.start
        tabBar.items![3].title = L10n.Tabs.leaderboard
        tabBar.items![4].title = L10n.Tabs.settings
        
    }

}
