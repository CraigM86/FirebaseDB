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
    
    lazy var addBarButtomItem = UIBarButtonItem(title: "Add", style: .done) {
        
        let addCategory = UIAlertAction(title: "New Category", style: .default) { (action) in
            let controller = CategoryViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
        let addItem = UIAlertAction(title: "New Item", style: .default) { (action) in
            var actions = [UIAlertAction]()
            
            SparkBuckets.categories.value.forEach { (category) in
                let action = UIAlertAction(title: category.name, style: .default) { (action) in
                    let controller = ItemViewController()
                    controller.category = category
                    self.navigationController?.pushViewController(controller, animated: true)
                }
                actions.append(action)
            }
            
            actions.append(Alert.cancelAction())
            Alert.show(.actionSheet, title: "Choose category", message: nil, actions: actions, completion: nil)
        }
        
        Alert.show(.actionSheet, title: "Add", message: nil, actions: [addCategory, addItem, Alert.cancelAction()], completion: nil)
    }
    
    // MARK: - Views
    
    lazy var flowLayout = FlowLayout().item(width: self.view.frame.width, height: 50).scrollDirection(.vertical)
    lazy var collectionView = CollectionView(with: flowLayout, delegateAndDataSource: self)
        .registerCell(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
    
    // MARK: - init - deinit
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
        fetch()
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
            collectionView
        ).fillingParent().layout(in: container)
        
    }
    
    override func configureViews() {
        super.configureViews()
    }
    
    override func addActions() {
        super.addActions()
        
    }
    
    override func subscribe() {
        super.subscribe()
        
        SparkBuckets.categories.subscribe(with: self) { (categories) in
            self.collectionView.reloadData()
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
    
    fileprivate func fetch() {
        Hud.large.showWorking(message: "Fetching categories...")
        SparkFirestore.retreiveCategories { (result) in
            Hud.large.hide()
            switch result {
            case .success(let categories):
                SparkBuckets.categories.value = categories
            case .failure(let err):
                Alert.showError(message: err.localizedDescription)
            }
        }
    }
    
    // MARK: - public
    
    // MARK: - open
    
    // MARK: - @objc Selectors
    
}

// MARK: - Delegates

extension AdminViewController: UICollectionViewDelegateFlowLayout {
    
}

// MARK: - Datasources

extension AdminViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        SparkBuckets.categories.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as! CategoryCell
        let category = SparkBuckets.categories.value[indexPath.row]
        cell.setup(with: category, at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = SparkBuckets.categories.value[indexPath.row]
        
        let controller = CategoryViewController()
        controller.category = category
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

// MARK: - Extensions

