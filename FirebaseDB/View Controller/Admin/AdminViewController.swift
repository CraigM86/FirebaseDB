//
//  AdminViewController.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 27.11.2020.
//

import UIKit
import SparkUI
import Layoutless

// MARK: - Protocols

class AdminViewController: SViewController {
    
    // MARK: - Dependencies
    
    // MARK: - Delegates
    
    // MARK: - Properties
    
    // MARK: - Buckets
    
    // MARK: - Navigation items
    
    // MARK: - Views
    
    let addCategoryLabel = UILabel()
        .text("Add Category")
        .text(color: .systemGreen)
        .textAlignment(.center)
        .bold()
    
    let addItemLabel = UILabel()
        .text("Add Item")
        .text(color: .systemGreen)
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
        title = "Admin: \(SparkBuckets.currentUserProfile.value.name)"
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
    }
    
    override func setupViews() {
        super.setupViews()
    }
    
    override func layoutViews() {
        super.layoutViews()
        
        stack(.vertical, spacing: 15)(
            addCategoryLabel,
            addItemLabel,
            Spacer()
        ).insetting(by: 12).fillingParent().layout(in: container)
        
    }
    
    override func configureViews() {
        super.configureViews()
    }
    
    override func addActions() {
        super.addActions()
        
        addCategoryLabel.addAction {
            let controller = AddCategoryViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        addItemLabel.addAction {
            let controller = AddItemViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
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

