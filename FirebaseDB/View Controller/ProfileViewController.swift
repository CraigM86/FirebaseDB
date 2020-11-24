//
//  ProfileViewController.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 24.11.2020.
//

import UIKit
import SparkUI
import Layoutless

// MARK: - Protocols

class ProfileViewController: SViewController {
    
    // MARK: - Dependencies
    
    // MARK: - Delegates
    
    // MARK: - Properties
    
    // MARK: - Buckets
    
    // MARK: - Navigation items
    
    lazy var logoutBarButtonItem = UIBarButtonItem(title: "Logout") {
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .destructive) { (action) in
            SparkAuth.signOut { (result) in
                switch result {
                case .success(let finished):
                    print("Logged out with success: \(finished)")
                case .failure(let err):
                    Alert.showError(message: err.localizedDescription)
                }
            }
        }
        
        Alert.show(.alert, title: "Logout", message: "Are you sure you want to log out?", actions: [confirmAction, Alert.cancelAction()], completion: nil)
    }
    
    // MARK: - Views
    
    // MARK: - init - deinit
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
    }
    
    override func preLoad() {
        super.preLoad()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        self.navigationItem.setRightBarButton(logoutBarButtonItem, animated: false)
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        title = "\(SparkBuckets.currentUserProfile.value.name)"
    }
    
    override func setupViews() {
        super.setupViews()
    }
    
    override func layoutViews() {
        super.layoutViews()
        
        stack(.vertical)(
            Spacer()
        ).insetting(by: 12).fillingParent().layout(in: container)
        
    }
    
    override func configureViews() {
        super.configureViews()
    }
    
    override func addActions() {
        super.addActions()
    }
    
    override func subscribe() {
        super.subscribe()
    }
    
    override func onLoad() {
        super.onLoad()
    }
    
    override func onDisappear() {
        super.onDisappear()
    }
    
    // MARK: - internal
    
    // MARK: - private
    
    // MARK: - fileprivate
    
    // MARK: - public
    
    // MARK: - open
    
    // MARK: - @objc Selectors
    
}

// MARK: - Delegates

// MARK: - Datasources

// MARK: - Extensions

