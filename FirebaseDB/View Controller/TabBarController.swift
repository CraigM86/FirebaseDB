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
    let profileController = UINavigationController(rootViewController: ProfileViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SparkAuth.configureFirebaseStateDidChange()
        //        SparkAuth.logout()
        
        setupTabBar()
        subscribe()
    }
    
    fileprivate func setupTabBar() {
        viewControllers = [
            homeController,
            profileController
        ]
    }
    
    fileprivate func subscribe() {
        
        SparkBuckets.currentUserAuthState.subscribe(with: self) { (authState) in
            switch authState {
            case .undefined:
                print("currentUserAuthState: \(authState)")
                let controller = AuthViewController()
                controller.isModalInPresentation = true
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            case .signedOut:
                print("currentUserAuthState: \(authState)")
                print("Do show the AuthViewController")
                let controller = AuthViewController()
                controller.isModalInPresentation = true
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            case .signedIn:
                print("currentUserAuthState: \(authState)")
                print("Do dismiss the AuthViewController")
            }
        }
    }
}

