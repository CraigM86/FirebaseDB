//
//  HomeViewController.swift
//  FirebaseDB
//
//  Created by MAC on 18/11/20.
//

import UIKit
import SparkUI
import Stax

// MARK: - Protocols

class HomeViewController: SViewController {
    
    // MARK: - Dependencies
    
    // MARK: - Delegates
    
    // MARK: - Properties
    
    // MARK: - Buckets
    
    // MARK: - Navigation items
    
    // MARK: - Views
    
//    let view0 = UIView(height: 100, backgroundColor: .systemBlue, staxDebugOptions: StaxDebugOptions())
    
    lazy var featuredItemsCollectionViewCellHeight = self.view.frame.width * Setup.featuredItemCellHeightPercentage
    lazy var featuredItemsFlowLayout = FlowLayout()
        .item(width: self.view.frame.width, height: featuredItemsCollectionViewCellHeight)
        .scrollDirection(.horizontal)
    lazy var featuredItemsCollectionView = CollectionView(with: featuredItemsFlowLayout, delegateAndDataSource: self)
        .registerCell(FeaturedItemCell.self, forCellWithReuseIdentifier: FeaturedItemCell.reuseIdentifier)
        .enablePaging()
        .hidesHorizontalScrollIndicator()
    
    lazy var categoriesCollectionViewHeight = Setup.homeCategoriesCellHeight * 5
    lazy var categoriesFlowLayout = FlowLayout()
        .item(width: self.view.frame.width, height: Setup.homeCategoriesCellHeight)
        .scrollDirection(.vertical)
    lazy var categoriesCollectionView = CollectionView(with: categoriesFlowLayout, delegateAndDataSource: self)
        .registerCell(HomeCategoryCell.self, forCellWithReuseIdentifier: HomeCategoryCell.reuseIdentifier)
    
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
        
        VStack(
            featuredItemsCollectionView.height(featuredItemsCollectionViewCellHeight),
            categoriesCollectionView.height(categoriesCollectionViewHeight),
            Spacer()
        ).scrolls().hidesScrollIndicator().layout(in: view, withSafeArea: true)
        
    }
    
    override func configureViews() {
        super.configureViews()
        
        featuredItemsCollectionView.tag = 0
        categoriesCollectionView.tag = 1
    }
    
    override func addActions() {
        super.addActions()
    }
    
    override func subscribe() {
        super.subscribe()
        
        SparkBuckets.items.subscribe(with: self) { (categories) in
            self.featuredItemsCollectionView.reloadData()
        }
        
        SparkBuckets.categories.subscribe(with: self) { (categories) in
            self.categoriesCollectionView.reloadData()
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
        SparkBuckets.items.value = [
            Item(uid: "", categoryUid: "", name: SLoremIpsum.extraShort, headerImageUrl: "cat0"),
            Item(uid: "", categoryUid: "", name: "Hello1", headerImageUrl: "cat1"),
            Item(uid: "", categoryUid: "", name: "Hello2", headerImageUrl: "cat2")
        ]
        
        SparkBuckets.categories.value = [
            Category(uid: "", name: SLoremIpsum.short, headerImageUrl: "cat0"),
            Category(uid: "", name: SLoremIpsum.extraShort, headerImageUrl: "cat1"),
            Category(uid: "", name: "Cat2", headerImageUrl: "cat2"),
            Category(uid: "", name: "Cat3", headerImageUrl: "cat3"),
            Category(uid: "", name: "Cat4", headerImageUrl: "cat4")
        ]
    }
    
    // MARK: - public
    
    // MARK: - open
    
    // MARK: - @objc Selectors
    
}

// MARK: - Delegates

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
}

// MARK: - Datasources

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return SparkBuckets.items.value.count
        } else {
            return SparkBuckets.categories.value.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedItemCell.reuseIdentifier, for: indexPath) as! FeaturedItemCell
            let item = SparkBuckets.items.value[indexPath.row]
            cell.setup(with: item, at: indexPath)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCategoryCell.reuseIdentifier, for: indexPath) as! HomeCategoryCell
            let item = SparkBuckets.categories.value[indexPath.row]
            cell.setup(with: item, at: indexPath)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = SparkBuckets.items.value[indexPath.row]
        
//        let controller = ItemViewController()
//        controller.item = item
//        controller.category = category
//        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}


// MARK: - Extensions


