//
//  CategoryCell.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 02.12.2020.
//

import UIKit
import SparkUI
import Layoutless

class CategoryCell: CollectionCell<Category>, SelfConfiguringCell {
    
    static var reuseIdentifier: String = "cell"
    
//    let imageView = UIImageView()
//        .setImage("DefaultProfileImage")
//        .masksToBounds()
//        .contentMode(.scaleAspectFill)
//        .square(24)
//        .templateImageColor(.systemYellow)
    
    lazy var messageLabel = UILabel()
        .text(color: .systemBlack)
        .font(.boldSystemFont(ofSize: 15))//.width(self.frame.width - 110)
    
    override func layoutViews() {
        super.layoutViews()
        
        stack(.vertical, spacing: 10)(
            messageLabel,
            Spacer()
        ).insetting(by: 12).fillingParent().layout(in: container)
        
    }
    
    override func configureViews(for item: Category?) {
        super.configureViews(for: item)
        guard let item = item else { return }
        messageLabel.text = item.name
    }
}
