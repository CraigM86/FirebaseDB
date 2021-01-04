//
//  LikesViewController.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 04.01.2021.
//

import UIKit
import SparkUI
import Layoutless
import FirebaseAuth

// MARK: - Protocols

class LikesViewController: SViewController {
    
    // MARK: - Dependencies
    
    // MARK: - Delegates
    
    // MARK: - Properties
    
    // MARK: - Buckets
    
    // MARK: - Navigation items
    
    lazy var profileBarButtonItem = UIBarButtonItem(systemImageNamed: "person.fill") {
        let controller = ProfileViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Views
    
    lazy var flowLayout = FlowLayout().item(width: self.view.frame.width * 0.5, height: self.view.frame.width * 0.7).scrollDirection(.vertical)
    lazy var collectionView = CollectionView(with: flowLayout, delegateAndDataSource: self)
        .registerCell(ItemCell.self, forCellWithReuseIdentifier: ItemCell.reuseIdentifier)
    
    // MARK: - init - deinit
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
        SparkBuckets.items.value = []
        SparkBuckets.likes.value = []
        fetch()
    }
    
    override func preLoad() {
        super.preLoad()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        self.navigationItem.setRightBarButton(profileBarButtonItem, animated: false)
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
        
        SparkBuckets.items.subscribe(with: self) { (items) in
            self.collectionView.reloadData()
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
    
    fileprivate func fetch() {
        guard let ownerUid = Auth.auth().currentUser?.uid else { return }
        Hud.large.showWorking(message: "Fetching likes...")
        SparkFirestore.retreiveLikes(ownerUid: ownerUid) { (result) in
            Hud.large.hide()
            switch result {
            case .success(let likes):
                SparkBuckets.likes.value = likes
                
                likes.forEach { (like) in
                    let itemUid = like.itemUid
                    SparkFirestore.retreiveItem(uid: itemUid) { (result) in
                        switch result {
                        case .success(let item):
                            SparkBuckets.items.value.append(item)
                        case .failure(let err):
                            print(err.localizedDescription)
                        }
                    }
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

extension LikesViewController: UICollectionViewDelegateFlowLayout {
    
}

// MARK: - Datasources

extension LikesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        SparkBuckets.items.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.reuseIdentifier, for: indexPath) as! ItemCell
        cell.delegate = self
        cell.like = SparkBuckets.likes.value[indexPath.row]
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

extension LikesViewController: ItemCellDelegate {
    
    func didLikeItem(_ item: Item) {
        guard let ownerUid = Auth.auth().currentUser?.uid else { return }
        let like = Like(uid: "", ownerUid: ownerUid, itemUid: item.uid)
        SparkFirestore.createLike(like) { (result) in
            switch result {
            case .success(let like):
                print("Finished liking: \(like)")
                for i in 0..<SparkBuckets.items.value.count {
                    let currentItem = SparkBuckets.items.value[i]
                    if currentItem.uid == item.uid {
                        SparkBuckets.likes.value[i] = like
                    }
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func didUnlike(_ like: Like, item: Item) {
        guard let ownerUid = Auth.auth().currentUser?.uid else { return }
        guard ownerUid == like.ownerUid else { return }
        print("Going to delete like: \(like)")
        SparkFirestore.deleteLike(like) { (result) in
            switch result {
            case .success(let like):
                print("Finished unliking: \(like)")
                for i in 0..<SparkBuckets.items.value.count {
                    let currentItem = SparkBuckets.items.value[i]
                    if currentItem.uid == item.uid {
                        SparkBuckets.likes.value[i] = nil
                    }
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}


