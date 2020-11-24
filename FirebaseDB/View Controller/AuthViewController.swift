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
            stack(.horizontal, distribution: .equalCentering)(
                Spacer(),
                signInWithAppleButton.sizing(toWidth: 240, height: 50),
                Spacer()
            ),
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
        
        signInWithAppleObserver.subscribe(with: self) { (signInWithAppleObserver) in
            Hud.large.showWorking(message: "Signing you in with Apple")
            SparkAuth.signIn(providerID: self.providerIDForSignInWithApple, idTokenString: signInWithAppleObserver.idTokenString, nonce: signInWithAppleObserver.nonce) { (result) in
                switch result {
                case .success(let authDataResult):
                    let profile = Profile(uid: authDataResult.user.uid,
                                          name: signInWithAppleObserver.name)
                    SparkBuckets.currentUserProfile.value = profile
                    Hud.large.hide()
                    self.dismiss(animated: true, completion: nil)
                    // let configureFirebaseStateDidChange take care of saving the currentUserProfile to Firestore / updating the currentUserProfile in Firestore if necessary

                case .failure(let err):
                    Hud.large.hideWithErrorAlert(message: err.localizedDescription)
                }
            }
        }
        
        signInWithAppleErrorObserver.subscribe(with: self) { (signInWithAppleErrorObserver) in
            Alert.showError(message: signInWithAppleErrorObserver.error.localizedDescription)
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

