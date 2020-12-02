//
//  ItemListViewController.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 02.12.2020.
//

import UIKit
import SparkUI
import Layoutless

// MARK: - Protocols

class ItemListViewController: SViewController {
    
    // MARK: - Dependencies
    
    var category: Category?
    
    // MARK: - Delegates
    
    // MARK: - Properties
    
    // MARK: - Buckets
    
    // MARK: - Navigation items
    
    // MARK: - Views
    
    lazy var flowLayout = FlowLayout().item(width: self.view.frame.width, height: 50).scrollDirection(.vertical)
    lazy var collectionView = CollectionView(with: flowLayout, delegateAndDataSource: self)
        .registerCell(ItemCell.self, forCellWithReuseIdentifier: ItemCell.reuseIdentifier)
    
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
        
        SparkBuckets.items.subscribe(with: self) { (categories) in
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
        guard let category = category else { return }
        Hud.large.showWorking(message: "Fetching items...")
        SparkFirestore.retreiveItems(categoryUid: category.uid) { (result) in
            Hud.large.hide()
            switch result {
            case .success(let items):
                SparkBuckets.items.value = items
                if items.count == 0 {
                    let goBackAction = UIAlertAction(title: "Go back", style: .default) { (action) in
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    let deleteAction = UIAlertAction(title: "Delete '\(category.name)'", style: .destructive) { (action) in
                        
                        let confirmAction = UIAlertAction(title: "Confirm", style: .destructive) { (action) in
                            Hud.large.showWorking(message: "Deleting category...")
                            SparkFirestore.deleteCategory(uid: category.uid) { (result) in
                                Hud.large.hide()
                                switch result {
                                case .success(let finished):
                                    if finished {
                                        self.navigationController?.popToViewController(adminController, animated: true)
                                    } else {
                                        Alert.showErrorSomethingWentWrong()
                                    }
                                case .failure(let err):
                                    Alert.showError(message: err.localizedDescription)
                                }
                            }
                        }
                        Alert.show(.alert, title: "Delete", message: "Do you really want to delete this category?", actions: [confirmAction, goBackAction], completion: nil)
                    }
                    
                    Alert.show(.alert, title: "No items found", message: nil, actions: [deleteAction, goBackAction], completion: nil)
                    return
                }
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

extension ItemListViewController: UICollectionViewDelegateFlowLayout {
    
}

// MARK: - Datasources

extension ItemListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        SparkBuckets.items.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.reuseIdentifier, for: indexPath) as! ItemCell
        let item = SparkBuckets.items.value[indexPath.row]
        cell.setup(with: item, at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = SparkBuckets.items.value[indexPath.row]
        
        let controller = ItemViewController()
        controller.item = item
        controller.category = category
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

// MARK: - Extensions

