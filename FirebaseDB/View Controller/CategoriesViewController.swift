//
//  CategoriesViewController.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 04.01.2021.
//

import UIKit
import SparkUI
import Stax

// MARK: - Protocols

class CategoriesViewController: SViewController {
    
    // MARK: - Dependencies
    
    // MARK: - Delegates
    
    // MARK: - Properties
    
    // MARK: - Buckets
    
    // MARK: - Navigation items
    
    // MARK: - Views
    
    lazy var categoriesFlowLayout = FlowLayout()
        .item(width: self.view.frame.width, height: 100)
        .scrollDirection(.vertical)
    lazy var categoriesCollectionView = CollectionView(with: categoriesFlowLayout, delegateAndDataSource: self)
        .registerCell(CategoriesCategoryCell.self, forCellWithReuseIdentifier: CategoriesCategoryCell.reuseIdentifier)
        .hidesVerticalScrollIndicator()
    
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
        
        title = "Category"
    }
    
    override func setupViews() {
        super.setupViews()
    }
    
    override func layoutViews() {
        super.layoutViews()
        
        VStack(
            categoriesCollectionView
        ).layout(in: container, withSafeArea: false)
        
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
            self.categoriesCollectionView.reloadData()
        }
    }
    
    override func onLoad() {
        super.onLoad()
        fetchData()
    }
    
    override func onDisappear() {
        super.onDisappear()
    }
    
    // MARK: - internal
    
    // MARK: - private
    
    // MARK: - fileprivate
    
    fileprivate func fetchData() {
        Hud.large.showWorking(message: "Fetching categories...")
        SparkFirestore.retreiveCategories { (result) in
            Hud.large.hide()
            switch result {
            case .success(let categories):
                print("categories count: \(categories.count)")
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

extension CategoriesViewController: UICollectionViewDelegateFlowLayout {
    
}

// MARK: - Datasources

extension CategoriesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        SparkBuckets.categories.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCategoryCell.reuseIdentifier, for: indexPath) as! CategoriesCategoryCell
        let item = SparkBuckets.categories.value[indexPath.row]
        cell.setup(with: item, at: indexPath)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = SparkBuckets.categories.value[indexPath.row]
        
        let controller = ItemListViewController()
        controller.category = item
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

// MARK: - Extensions

