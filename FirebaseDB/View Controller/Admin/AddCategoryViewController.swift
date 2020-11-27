//
//  AddCategoryViewController.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 27.11.2020.
//

import UIKit
import SparkUI
import Layoutless

// MARK: - Protocols

class AddCategoryViewController: SImagePickerViewController {
    
    // MARK: - Dependencies
    
    var category: Category?
    
    // MARK: - Delegates
    
    // MARK: - Properties
    
    // MARK: - Buckets
    
    // MARK: - Navigation items
    
    lazy var saveBarButtonItem = UIBarButtonItem(title: "Save", style: .done) {
        guard let image = self.headerImageView.image, let name = self.nameTextField.object.text, name != "" else {
            return
        }
        
        Hud.large.showWorking(message: self.category == nil ? "Adding new category" : "Updating category")
        SparkStorage.handleImageChange(newImage: image, folderPath: SparkKey.StoragePath.categoryHeaderImages, compressionQuality: Setup.categoryHeaderImageCompressionQuality, oldImageUrl: self.category == nil ? "" : self.category!.headerImageUrl) { (result) in
            switch result {
            case .success(let url):
                Hud.large.update(message: "Updating database...")
                if self.category == nil {
                    // update category here later
                } else {
                    let category = Category(uid: "", name: name, headerImageUrl: url.absoluteString)
                    SparkFirestore.createCategory(category) { (result) in
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
                }
            case .failure(let err):
                Hud.large.hideWithErrorAlert(message: err.localizedDescription)
            }
        }
        
    }
    
    // MARK: - Views
    
    lazy var headerImageView = UIImageView()
        .background(color: .systemGray5)
        .square(self.view.frame.size.width)
    let nameTextField = STextField().placeholder("Name")
    
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
        title = "Add new category"
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
            headerImageView,
            nameTextField,
            Spacer()
        ).insetting(by: 12).scrolling(.vertical).fillingParent().layout(in: container)
        
    }
    
    override func configureViews() {
        super.configureViews()
    }
    
    override func addActions() {
        super.addActions()
        
        headerImageView.addAction {
            self.showChooseImageSourceTypeAlertController()
        }
    }
    
    override func subscribe() {
        super.subscribe()
        
        imagePickerControllerImage.subscribe(with: self) { (image) in
            self.headerImageView.image = image
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

