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
    
    var itemTypes = [
        ItemType.undefined.rawValue,
        ItemType.accessory.rawValue,
        ItemType.onSale.rawValue
    ]
    
    lazy var selectedItemType = itemTypes[0]
    
    var itemSpaces = [
        ItemSpace.undefined.rawValue,
        ItemSpace.indoor.rawValue,
        ItemSpace.outdoor.rawValue
    ]
    
    lazy var selectedItemSpace = itemSpaces[0]
    
    // MARK: - Buckets
    
    // MARK: - Navigation items
    
    lazy var saveBarButtonItem = UIBarButtonItem(title: "Save", style: .done) {
        guard let image = self.headerImageView.image,
              let name = self.nameTextField.object.text, name != "",
              let description = self.descriptionTextView.text,
              let purchaseUrl = self.purchaseUrlTextField.object.text,
              let isFeatured = self.isFeaturedSwitch.isOn(),
              self.selectedItemType != ItemType.undefined.rawValue,
              self.selectedItemSpace != ItemSpace.undefined.rawValue,
              let category = self.category else {
            return
        }
        
        Hud.large.showWorking(message: self.item == nil ? "Adding new item..." : "Updating item...")
        SparkStorage.handleImageChange(newImage: image, folderPath: SparkKey.StoragePath.itemHeaderImages, compressionQuality: Setup.itemHeaderImageCompressionQuality, oldImageUrl: self.item == nil ? "" : self.item!.headerImageUrl) { (result) in
            switch result {
            case .success(let url):
                Hud.large.update(message: "Updating database...")
                if self.item == nil {
                    let item = Item(uid: "", categoryUid: category.uid, name: name, description: description, headerImageUrl: url.absoluteString, purchaseUrl: purchaseUrl, isFeatured: isFeatured, itemSpace: self.selectedItemSpace, itemType: self.selectedItemType)
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
                    var updatedItem = Item(uid: self.item!.uid, categoryUid: category.uid, name: name, description: description, headerImageUrl: url.absoluteString, purchaseUrl: purchaseUrl, isFeatured: isFeatured, itemSpace: self.selectedItemSpace, itemType: self.selectedItemType)
                    
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
    lazy var nameTextField = STextField().placeholder("Name").delegate(self)
    let descriptionTextView = UITextView()
    let purchaseUrlButton = UILabel().text("Buy now").text(color: .systemBlue).textAlignment(.center).bold()
    let purchaseUrlTextField = STextField().placeholder("Purchase url")
    let isFeaturedContainerView = UIView()
    let isFeaturedLabel = UILabel().text("Featured").bold()
    let isFeaturedSwitch = SSwitch(uiSwitch: UISwitch())
    let itemTypePicker = UIPickerView()
    let itemSpacePicker = UIPickerView()
    
    let deleteLabel = UILabel().text("Delete").textAlignment(.center).bold().text(color: .systemRed)
    
    // MARK: - init - deinit
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
        
        itemTypePicker.tag = 0
        itemTypePicker.delegate = self
        itemTypePicker.dataSource = self
        
        itemSpacePicker.tag = 1
        itemSpacePicker.delegate = self
        itemSpacePicker.dataSource = self
    }
    
    override func preLoad() {
        super.preLoad()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        if SparkBuckets.isAdmin.value {
            title = "\(item == nil ? "Add new item" : "Edit item")"
        }
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        if SparkBuckets.isAdmin.value {
            self.navigationItem.setRightBarButton(saveBarButtonItem, animated: false)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        deleteLabel.isHidden(item == nil)
        
        guard let item = item else { return }
        
        headerImageView.setImage(from: item.headerImageUrl, renderingMode: .alwaysOriginal, contentMode: .scaleAspectFill, placeholderImage: nil, indicatorType: .activity)
        nameTextField.text(item.name)
        descriptionTextView.text = item.description
        purchaseUrlTextField.text(item.purchaseUrl)
        isFeaturedSwitch.object.isOn = item.isFeatured
        
        var itemTypeRow = 0
        for i in 0..<itemTypes.count {
            let itemType = itemTypes[i]
            if itemType == item.itemType {
                itemTypeRow = i
            }
        }
        itemTypePicker.select(itemTypeRow)
        selectedItemType = itemTypes[itemTypeRow]
        
        var itemSpaceRow = 0
        for i in 0..<itemSpaces.count {
            let itemSpace = itemSpaces[i]
            if itemSpace == item.itemSpace {
                itemSpaceRow = i
            }
        }
        itemSpacePicker.select(itemSpaceRow)
        selectedItemSpace = itemSpaces[itemSpaceRow]
        
        if !SparkBuckets.isAdmin.value {
            
            descriptionTextView.isEditable = false
            
            purchaseUrlButton.isHidden = false
            purchaseUrlTextField.isHidden = true
            
            isFeaturedContainerView.isHidden = true
            itemTypePicker.isHidden = true
            itemSpacePicker.isHidden = true
            deleteLabel.isHidden = true
        } else {
            purchaseUrlButton.isHidden = true
            purchaseUrlTextField.isHidden = false
        }
    }
    
    override func layoutViews() {
        super.layoutViews()
        
        stack(.horizontal)(
            isFeaturedLabel,
            Spacer(),
            isFeaturedSwitch
        ).fillingParent().layout(in: isFeaturedContainerView)
        
        stack(.vertical, spacing: 15)(
            headerImageView,
            nameTextField,
            descriptionTextView.height(160).background(color: .systemGray5),
            purchaseUrlButton,
            purchaseUrlTextField,
            isFeaturedContainerView,
            itemTypePicker.height(120),
            itemSpacePicker.height(120),
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
            if !SparkBuckets.isAdmin.value { return }
            self.showChooseImageSourceTypeAlertController()
        }
        
        purchaseUrlButton.addAction {
            guard let url = self.item?.purchaseUrl else {
                Alert.showInfo(message: "It looks like the purchase url is missing")
                return
            }
            guard url.contains("https://") else {
                Alert.showWarning(message: "It looks like the purchase url is not a valid one")
                return
            }
            let controller = SWebViewController(url: url)
            self.navigationController?.pushViewController(controller, animated: true)
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

extension ItemViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
}

extension ItemViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let tag = pickerView.tag
        if tag == 0 {
            return itemTypes.count
        } else {
            return itemSpaces.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let tag = pickerView.tag
        if tag == 0 {
            return itemTypes[row].capitalized
        } else {
            return itemSpaces[row].capitalized
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Selected: \(row) for picker tag: \(pickerView.tag)")
        let tag = pickerView.tag
        if tag == 0 {
            self.selectedItemType = itemTypes[row]
        } else {
            self.selectedItemSpace = itemSpaces[row]
        }
    }
}

extension ItemViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        SparkBuckets.isAdmin.value
    }
}
