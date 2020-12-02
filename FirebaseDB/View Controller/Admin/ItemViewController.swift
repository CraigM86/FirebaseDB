//
//  ItemViewController.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 27.11.2020.
//

import UIKit
import SparkUI
import Layoutless

// MARK: - Protocols

class ItemViewController: SImagePickerViewController {
    
    // MARK: - Dependencies
    
    var item: Item?
    var category: Category?
    
    // MARK: - Delegates
    
    // MARK: - Properties
    
    // MARK: - Buckets
    
    // MARK: - Navigation items
    
    lazy var saveBarButtonItem = UIBarButtonItem(title: "Save", style: .done) {
        guard let image = self.headerImageView.image,
              let name = self.nameTextField.object.text, name != "",
              let category = self.category else {
            return
        }
        
        Hud.large.showWorking(message: self.item == nil ? "Adding new item..." : "Updating item...")
        SparkStorage.handleImageChange(newImage: image, folderPath: SparkKey.StoragePath.itemHeaderImages, compressionQuality: Setup.itemHeaderImageCompressionQuality, oldImageUrl: self.item == nil ? "" : self.item!.headerImageUrl) { (result) in
            switch result {
            case .success(let url):
                Hud.large.update(message: "Updating database...")
                if self.item == nil {
                    let item = Item(uid: "", categoryUid: category.uid, name: name, headerImageUrl: url.absoluteString)
                    SparkFirestore.createItem(item) { (result) in
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
                } else {
                    var updatedItem = Item(uid: self.item!.uid, categoryUid: category.uid, name: name, headerImageUrl: url.absoluteString)
                    
                    SparkFirestore.updateItem(updatedItem) { (result) in
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
    let deleteLabel = UILabel().text("Delete").textAlignment(.center).bold().text(color: .systemRed)
    
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
        title = "\(item == nil ? "Add new item" : "Edit item")"
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        self.navigationItem.setRightBarButton(saveBarButtonItem, animated: false)
    }
    
    override func setupViews() {
        super.setupViews()
        
        deleteLabel.isHidden(item == nil)
        
        guard let item = item else { return }
        
        headerImageView.setImage(from: item.headerImageUrl, renderingMode: .alwaysOriginal, contentMode: .scaleAspectFill, placeholderImage: nil, indicatorType: .activity)
        nameTextField.text(item.name)
    }
    
    override func layoutViews() {
        super.layoutViews()
        
        stack(.vertical, spacing: 15)(
            headerImageView,
            nameTextField,
            deleteLabel,
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
        
        deleteLabel.addAction {
            guard let item = self.item else { return }
            let confirmAction = UIAlertAction(title: "Confirm", style: .destructive) { (action) in
                Hud.large.showWorking(message: "Deleting item...")
                SparkFirestore.deleteItem(uid: item.uid) { (result) in
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
            
            Alert.show(.alert, title: "Delete", message: "Do you really want to delete this item?", actions: [confirmAction, Alert.cancelAction()], completion: nil)
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

