//
//  SettingsViewController.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 27.11.2020.
//

import UIKit
import SparkUI
import Layoutless

// MARK: - Protocols

class SettingsViewController: SImagePickerViewController {
    
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
        SparkStorage.handleImageChange(newImage: image, folderPath: SparkKey.StoragePath.profileImages, compressionQuality: Setup.profilImageCompressionQuality, oldImageUrl: SparkBuckets.currentUserProfile.value.profileImageUrl) { (result) in
            switch result {
            case .success(let url):
                Hud.large.update(message: "Updating database...")
                let profile = Profile(uid: "", name: name, profileImageUrl: url.absoluteString)
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
                Alert.showError(message: err.localizedDescription)
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
            Spacer()
        ).insetting(by: 12).fillingParent().layout(in: container)
        
    }
    
    override func configureViews() {
        super.configureViews()
        self.profileImageView.setImage(from: SparkBuckets.currentUserProfile.value.profileImageUrl, renderingMode: .alwaysOriginal, contentMode: .scaleAspectFill, placeholderImage: nil, indicatorType: .activity)
        self.nameTextField.text(SparkBuckets.currentUserProfile.value.name)
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
    }
    
    override func subscribe() {
        super.subscribe()
        
        SparkBuckets.currentUserProfile.subscribe(with: self) { (profile) in
            self.nameTextField.text(profile.name)
        }
        
        imagePickerControllerImage.subscribe(with: self) { (image) in
            self.profileImageView.image = image
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

