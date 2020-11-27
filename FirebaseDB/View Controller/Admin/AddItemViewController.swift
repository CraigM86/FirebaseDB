//
//  AddItemViewController.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 27.11.2020.
//

import UIKit
import SparkUI
import Layoutless

// MARK: - Protocols

class AddItemViewController: SImagePickerViewController {
    
    // MARK: - Dependencies
    
    // MARK: - Delegates
    
    // MARK: - Properties
    
    // MARK: - Buckets
    
    // MARK: - Navigation items
    
    lazy var saveBarButtonItem = UIBarButtonItem(title: "Save", style: .done) {
        guard let image = self.headerImageView.image, let name = self.nameTextField.object.text, name != "" else {
            return
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
        title = "Add new item"
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

