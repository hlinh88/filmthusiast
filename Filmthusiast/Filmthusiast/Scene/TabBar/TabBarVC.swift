//
//  TabBarVC.swift
//  Filmthusiast
//
//  Created by Hoang Linh Nguyen on 31/3/2024.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow

        let vc1 = UINavigationController(rootViewController: HomeVC())
        let vc2 = UINavigationController(rootViewController: SearchVC())
        let vc3 = UINavigationController(rootViewController: WatchListVC())
        let vc4 = UINavigationController(rootViewController: CheckInVC())


        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc3.tabBarItem.image = UIImage(systemName: "play.circle")
        vc4.tabBarItem.image = UIImage(systemName: "folder")

        vc1.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        vc2.tabBarItem.selectedImage = UIImage(systemName: "magnifyingglass.fill")
        vc3.tabBarItem.selectedImage = UIImage(systemName: "play.circle.fill")
        vc4.tabBarItem.selectedImage = UIImage(systemName: "folder.fill")

        
        vc1.title = "Home"
        vc2.title = "Search"
        vc3.title = "Watch List"
        vc4.title = "Check in"


        tabBar.tintColor = .white
        tabBar.backgroundColor = .darkGray

        setViewControllers([vc1, vc2, vc3, vc4], animated: true)

    }


}
