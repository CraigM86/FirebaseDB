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
    
    let indoorTitleLabel = UILabel().text("Indoor Items").bold(28)
    let indoorSeeAllLabel = UILabel().text("See All").text(color: .systemRed).regular(18)
    
    lazy var indoorItemsFlowLayout = FlowLayout()
        .itemSize(Setup.homeIndoorOutdoorItemCellSize)
        .scrollDirection(.horizontal)
    lazy var indoorItemsCollectionView = CollectionView(with: indoorItemsFlowLayout, delegateAndDataSource: self)
        .registerCell(HomeIndoorOutdoorItemCell.self, forCellWithReuseIdentifier: HomeIndoorOutdoorItemCell.reuseIdentifier)
        .hidesHorizontalScrollIndicator()
    
    let outdoorTitleLabel = UILabel().text("Outdoor Items").bold(28)
    let outdoorSeeAllLabel = UILabel().text("See All").text(color: .systemRed).regular(18)
    
    lazy var outdoorItemsFlowLayout = FlowLayout()
        .itemSize(Setup.homeIndoorOutdoorItemCellSize)
        .scrollDirection(.horizontal)
    lazy var outdoorItemsCollectionView = CollectionView(with: outdoorItemsFlowLayout, delegateAndDataSource: self)
        .registerCell(HomeIndoorOutdoorItemCell.self, forCellWithReuseIdentifier: HomeIndoorOutdoorItemCell.reuseIdentifier)
        .hidesHorizontalScrollIndicator()
    
    let accessoriesTitleLabel = UILabel().text("Accessories").bold(28)
    let accessoriesSeeAllLabel = UILabel().text("See All").text(color: .systemRed).regular(18)
    
    lazy var accessoriesCollectionViewHeight = Setup.homeAccessoriesCellHeight * 5
    lazy var accessoriesFlowLayout = FlowLayout()
        .item(width: self.view.frame.width - 24, height: Setup.homeAccessoriesCellHeight)
        .scrollDirection(.vertical)
    lazy var accessoriesCollectionView = CollectionView(with: accessoriesFlowLayout, delegateAndDataSource: self)
        .registerCell(HomeAccessoriesCell.self, forCellWithReuseIdentifier: HomeAccessoriesCell.reuseIdentifier)
    
    
    
    
    
    
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
            
            HLine(),
            HStack(
                indoorTitleLabel,
                Spacer(),
                indoorSeeAllLabel
            ).padding(.horizontal, 24).padding(.top),
            indoorItemsCollectionView.height(Setup.homeIndoorOutdoorItemCellSize.height),
            
            HLine(),
            HStack(
                outdoorTitleLabel,
                Spacer(),
                outdoorSeeAllLabel
            ).padding(.horizontal, 24).padding(.top),
            outdoorItemsCollectionView.height(Setup.homeIndoorOutdoorItemCellSize.height),
            
            HLine(),
            HStack(
                accessoriesTitleLabel,
                Spacer(),
                accessoriesSeeAllLabel
            ).padding(.horizontal, 24).padding(.top),
            VStack(
                accessoriesCollectionView.height(accessoriesCollectionViewHeight)
            ).padding(by: 12),
            
//            categoriesCollectionView.height(categoriesCollectionViewHeight),
            Spacer()
        ).scrolls().hidesScrollIndicator().layout(in: view, withSafeArea: true)
        
    }
    
    override func configureViews() {
        super.configureViews()
        
        featuredItemsCollectionView.tag = 0
        indoorItemsCollectionView.tag = 1
        outdoorItemsCollectionView.tag = 2
        accessoriesCollectionView.tag = 3
    }
    
    override func addActions() {
        super.addActions()
        
        indoorSeeAllLabel.addAction {
            print("Tapped indoorSeeAllLabel")
        }
        
        outdoorSeeAllLabel.addAction {
            print("Tapped outdoorSeeAllLabel")
        }
        
        accessoriesSeeAllLabel.addAction {
            print("Tapped accessoriesSeeAllLabel")
        }
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
            Item(uid: "", categoryUid: "", name: "Hello2", headerImageUrl: "cat2"),
            Item(uid: "", categoryUid: "", name: "Hello3", headerImageUrl: "cat3"),
            Item(uid: "", categoryUid: "", name: "Hello4", headerImageUrl: "cat4")
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
        } else if collectionView.tag == 1 {
            return SparkBuckets.items.value.count
        } else if collectionView.tag == 2 {
            return SparkBuckets.items.value.count
        } else {
            return SparkBuckets.items.value.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedItemCell.reuseIdentifier, for: indexPath) as! FeaturedItemCell
            let item = SparkBuckets.items.value[indexPath.row]
            cell.setup(with: item, at: indexPath)
            return cell
        } else if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeIndoorOutdoorItemCell.reuseIdentifier, for: indexPath) as! HomeIndoorOutdoorItemCell
            let item = SparkBuckets.items.value[indexPath.row]
            cell.setup(with: item, at: indexPath)
            return cell
        } else if collectionView.tag == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeIndoorOutdoorItemCell.reuseIdentifier, for: indexPath) as! HomeIndoorOutdoorItemCell
            let item = SparkBuckets.items.value[indexPath.row]
            cell.setup(with: item, at: indexPath)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeAccessoriesCell.reuseIdentifier, for: indexPath) as! HomeAccessoriesCell
            let item = SparkBuckets.items.value[indexPath.row]
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


