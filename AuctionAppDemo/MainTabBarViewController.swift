//
//  ViewController.swift
//  AuctionAppDemo
//
//  Created by student on 5/21/25.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: SettingsViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "gear")
        
        vc1.tabBarItem.title = "Home"
        vc2.tabBarItem.title = "Settings"
        
        tabBar.tintColor = .label
        
        setViewControllers([vc1, vc2], animated: true)
    }


}

