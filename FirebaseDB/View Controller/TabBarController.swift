//
//  TabBarController.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 24.11.2020.
//

import UIKit
import SparkUI
import FirebaseAuth

class TabBarController: UITabBarController {
    
    let authViewController = AuthViewController()
    
    let controller0 = HomeViewController()
    let controller1 = CategoriesViewController()
    let controller2 = LikesViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRoot()
        observeAuthState()
    }
    
    fileprivate func setupRoot() {
        SparkAuth.configureFirebaseStateDidChange()
        showMain()
    }
    
    fileprivate func observeAuthState() {
        SparkBuckets.currentUserAuthState.subscribe(with: self) { (authState) in
            Console.info("Auth State: \(authState)")
            switch authState {
            case .undefined, .signedOut:
                let controller = AuthViewController()
                controller.isModalInPresentation = true
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            case .signedIn:
                Console.info("Do dismiss the AuthViewController")
            }
        }
        
    }
    
    fileprivate func showMain() {
        
        UITabBar.appearance().tintColor = .systemRed
        
        let item0 = UITabBarItem()
        item0.image = UIImage(systemName: "house.fill")
        controller0.tabBarItem = item0
        
        let item1 = UITabBarItem()
        item1.image = UIImage(systemName: "square.grid.2x2.fill")
        controller1.tabBarItem = item1
        
        let item2 = UITabBarItem()
        item2.image = UIImage(systemName: "heart.fill")
        controller2.tabBarItem = item2
        
        viewControllers = [
            UINavigationController(rootViewController: controller0),
            UINavigationController(rootViewController: controller1),
            UINavigationController(rootViewController: controller2)
        ]
        
        selectedIndex = 0

    }
    
}


