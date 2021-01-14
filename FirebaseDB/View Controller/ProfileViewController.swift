//
//  ProfileViewController.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 27.11.2020.
//

import UIKit
import SparkUI
import Layoutless
import FirebaseAuth

let adminController = AdminViewController()

// MARK: - Protocols

class ProfileViewController: SImagePickerViewController {
    
    // MARK: - Dependencies
    
    // MARK: - Delegates
    
    // MARK: - Properties
    
    // MARK: - Buckets
    
    // MARK: - Navigation items
    
    lazy var saveBarButtonItem = UIBarButtonItem(title: "Save", style: .done) {
        guard let image = self.profileImageView.image, let name = self.nameTextField.object.text, name != "" else {
            return
        }
        
        Hud.large.showWorking(message: "Saving profile changes...")
        SparkStorage.handleImageChange(newImage: image, folderPath: SparkKey.StoragePath.profileImages, compressionQuality: Setup.profileImageCompressionQuality, oldImageUrl: SparkBuckets.currentUserProfile.value.profileImageUrl) { (result) in
            switch result {
            case .success(let url):
                Hud.large.update(message: "Updating database...")
                guard let curentUserUid = Auth.auth().currentUser?.uid else { return }
                let profile = Profile(uid: curentUserUid, name: name, profileImageUrl: url.absoluteString)
                print("Updating profile: \(profile)")
                SparkFirestore.updateCurrentUserProfile(data: profile.dictionary(mapped: true)) { (result) in
                    Hud.large.hide()
                    switch result {
                    case .success(let finished):
                        if finished {
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            Alert.showErrorSomethingWentWrong()
                        }
                    case .failure(let err):
                        Alert.showError(message: err.localizedDescription)
                    }
                }
            case .failure(let err):
                Hud.large.hideWithErrorAlert(message: err.localizedDescription)
            }
        }
    }
    
    // MARK: - Views
    
    let profileImageView = UIImageView().background(color: .systemGray5)
    let nameTextField = STextField().placeholder("Full Name")
    let logoutLabel = UILabel()
        .text("Logout")
        .text(color: .systemBlue)
        .textAlignment(.center)
        .bold()
    
    let adminLabel = UILabel()
        .text("Admin Access")
        .text(color: .systemRed)
        .textAlignment(.center)
        .bold()
        .isHidden()
    
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
        self.navigationItem.setRightBarButton(saveBarButtonItem, animated: false)
    }
    
    override func setupViews() {
        super.setupViews()
    }
    
    override func layoutViews() {
        super.layoutViews()
        
        stack(.vertical, spacing: 15)(
            stack(.horizontal, distribution: .equalCentering)(
                Spacer(),
                profileImageView.circular(44),
                Spacer()
            ),
            nameTextField,
            SDivider(),
            logoutLabel,
            adminLabel,
            Spacer()
        ).insetting(by: 12).fillingParent().layout(in: container)
        
    }
    
    /*
     pod 'Firebase/Analytics'
     pod 'Firebase/Auth'
     pod 'Firebase/Firestore'
     pod 'Firebase/Storage'
     pod 'FirebaseFirestoreSwift'
     */
    
    override func configureViews() {
        super.configureViews()
        print("url: \(SparkBuckets.currentUserProfile.value.profileImageUrl)")
        profileImageView.setImage(from: SparkBuckets.currentUserProfile.value.profileImageUrl, renderingMode: .alwaysOriginal, contentMode: .scaleAspectFill, placeholderImage: nil, indicatorType: .activity)
        nameTextField.text(SparkBuckets.currentUserProfile.value.name)
        
        adminLabel.isHidden(!SparkBuckets.isAdmin.value)
    }
    
    override func addActions() {
        super.addActions()
        
        profileImageView.addAction {
            self.showChooseImageSourceTypeAlertController()
        }
        
        logoutLabel.addAction {
            let confirmAction = UIAlertAction(title: "Confirm", style: .destructive) { (action) in
                SparkAuth.signOut { (result) in
                    switch result {
                    case .success(let finished):
                        print("Logged out with success: \(finished)")
                        self.navigationController?.popViewController(animated: true)
                    case .failure(let err):
                        Alert.showError(message: err.localizedDescription)
                    }
                }
            }
            
            Alert.show(.alert, title: "Logout", message: "Are you sure you want to log out?", actions: [confirmAction, Alert.cancelAction()], completion: nil)
        }
        
        adminLabel.addAction {
            self.navigationController?.pushViewController(adminController, animated: true)
        }
    }
    
    override func subscribe() {
        super.subscribe()
        
        SparkBuckets.currentUserProfile.subscribe(with: self) { (profile) in
            self.nameTextField.text(profile.name)
        }
        
        imagePickerControllerImage.subscribe(with: self) { (image) in
            self.profileImageView.image = image
        }
        
        SparkBuckets.isAdmin.subscribe(with: self) { (isAdmin) in
            self.adminLabel.isHidden(!isAdmin)
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

