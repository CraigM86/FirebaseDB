//
//  ItemListViewController.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 02.12.2020.
//

import UIKit
import SparkUI
import Layoutless
import FirebaseAuth

// MARK: - Protocols

class ItemListViewController: SViewController {
    
    // MARK: - Dependencies
    
    var category: Category?
    
    // MARK: - Delegates
    
    // MARK: - Properties
    
    // MARK: - Buckets
    
    // MARK: - Navigation items
    
    // MARK: - Views
    
    lazy var imageView = UIImageView()
        .masksToBounds()
        .contentMode(.scaleAspectFill)
        .height(200)
    
    let itemsCountLabel = UILabel()
        .text(color: .systemGray3)
        .textAlignment(.left)
        .font(.boldSystemFont(ofSize: 12))
    
    lazy var flowLayout = FlowLayout().item(width: self.view.frame.width * 0.5, height: self.view.frame.width * 0.7).scrollDirection(.vertical)
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
        
        guard let category = category else { return }
        title = category.name
    }
    
    override func setupViews() {
        super.setupViews()
    }
    
    override func layoutViews() {
        super.layoutViews()
        
        stack(.vertical)(
            imageView,
            itemsCountLabel.insetting(by: 8),
            SDivider(),
            collectionView
        ).fillingParent().layout(in: container)
        
    }
    
    override func configureViews() {
        super.configureViews()
        
        guard let category = category else { return }
        imageView.setImage(from: category.headerImageUrl, renderingMode: .alwaysOriginal, contentMode: .scaleAspectFill, placeholderImage: nil, indicatorType: .activity)
    }
    
    override func addActions() {
        super.addActions()
    }
    
    override func subscribe() {
        super.subscribe()
        
        SparkBuckets.items.subscribe(with: self) { (items) in
            self.itemsCountLabel.text = "\(items.count) ITEM\(items.count == 0 ? "" : "S")"
            self.collectionView.reloadData()
            
            var dummyLikes = [Bool]()
            items.forEach { (item) in
                dummyLikes.append(false)
            }
            SparkBuckets.likes.value = dummyLikes
            self.fetchLikes(items)
        }
        
        SparkBuckets.likes.subscribe(with: self) { (likes) in
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
    
    fileprivate func fetchLikes(_ items: [Item]) {
        
        items.forEach { (item) in
            guard let ownerUid = Auth.auth().currentUser?.uid else { return }
            let itemUid = item.uid
            let like = Like(uid: "", ownerUid: ownerUid, itemUid: itemUid)
            SparkFirestore.retreiveLike(like) { (result) in
                switch result {
                case .success(let likes):
                    if likes.count >= 1 {
                        var likes = [Bool]()
                        for i in 0..<SparkBuckets.items.value.count {
                            let currentItem = SparkBuckets.items.value[i]
                            if currentItem.uid == item.uid {
                                likes.append(true)
                            } else {
                                likes.append(false)
                            }
                        }
                        SparkBuckets.likes.value = likes
                    }
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
        }
        
        
    }
    
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
        cell.delegate = self
        cell.isLiked = SparkBuckets.likes.value[indexPath.row]
        let item = SparkBuckets.items.value[indexPath.row]
        cell.setup(with: item, at: indexPath)
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let item = SparkBuckets.items.value[indexPath.row]
//        
//        if SparkBuckets.isAdmin.value {
//            let controller = ItemViewController()
//            controller.item = item
//            controller.category = category
//            self.navigationController?.pushViewController(controller, animated: true)
//        } else {
//            let url = item.purchaseUrl
//            guard url.contains("https://") else { return }
//            let controller = SWebViewController(url: url)
//            self.navigationController?.pushViewController(controller, animated: true)
//        }
//    }
    
}

// MARK: - Extensions

extension ItemListViewController: ItemCellDelegate {
    func didTap(_ item: Item) {
        guard let ownerUid = Auth.auth().currentUser?.uid else { return }
        let like = Like(uid: "", ownerUid: ownerUid, itemUid: item.uid)
        SparkFirestore.createLike(like) { (result) in
            switch result {
            case .success(let finished):
                print("Finished liking: \(finished)")
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}
