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
    
    let homeController = UINavigationController(rootViewController: ViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SparkAuth.configureFirebaseStateDidChange()
        //        SparkAuth.logout()
        
        setupTabBar()
        subscribe()
    }
    
    fileprivate func setupTabBar() {
        viewControllers = [
            homeController
        ]
    }
    
    fileprivate func subscribe() {
        
        SparkBuckets.currentUserAuthState.subscribe(with: self) { (authState) in
            switch authState {
            case .undefined:
                print("currentUserAuthState: \(authState)")
            case .signedOut:
                print("currentUserAuthState: \(authState)")
                print("Do show the AuthViewController")
            case .signedIn:
                print("currentUserAuthState: \(authState)")
                print("Do dismiss the AuthViewController")
            }
        }
    }
}

