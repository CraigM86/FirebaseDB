//
//  AuthViewController.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 24.11.2020.
//

import UIKit
import SparkUI
import Layoutless

// MARK: - Protocols

class AuthViewController: SSignInWithAppleViewController {
    
    // MARK: - Dependencies
    
    // MARK: - Delegates
    
    // MARK: - Properties
    
    // MARK: - Buckets
    
    // MARK: - Navigation items
    
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
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
    }
    
    override func setupViews() {
        super.setupViews()
    }
    
    override func layoutViews() {
        super.layoutViews()
        
        stack(.vertical)(
            Spacer(),
            signInWithAppleButton.setHeight(50),
            Spacer().setHeight(24)
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
        
        signInWithAppleObserver.subscribe(with: self) { (observer) in
            let newProfile = Profile(uid: "", name: observer.name)
            SparkBuckets.currentUserProfile.value = newProfile
            print("Signed in with Apple only")
            self.dismiss(animated: true, completion: nil)
        }
        
        signInWithAppleErrorObserver.subscribe(with: self) { (observer) in
//            Alert.showError(message: "\(observer.error.localizedDescription)")
        }
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

