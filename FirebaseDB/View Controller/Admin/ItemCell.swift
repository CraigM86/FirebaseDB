//
//  ItemCell.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 02.12.2020.
//

import UIKit
import SparkUI
import Layoutless

class ItemCell: CollectionCell<Item>, SelfConfiguringCell {
    
    static var reuseIdentifier: String = "cell"
    
    let imageView = UIImageView()
        .masksToBounds()
        .contentMode(.scaleAspectFill)
        .square(50)
    
    lazy var messageLabel = UILabel()
        .text(color: .systemBlack)
        .font(.boldSystemFont(ofSize: 15))//.width(self.frame.width - 110)
    
    override func layoutViews() {
        super.layoutViews()
        
        stack(.horizontal, spacing: 15)(
            imageView,
            stack(.vertical)(
                Spacer().setHeight(5),
                messageLabel,
                Spacer(),
                SDivider()
            )
        ).fillingParent().layout(in: container)
        
    }
    
    override func configureViews(for item: Item?) {
        super.configureViews(for: item)
        guard let item = item else { return }
        imageView.setImage(from: item.headerImageUrl, renderingMode: .alwaysOriginal, contentMode: .scaleAspectFill, placeholderImage: nil, indicatorType: .activity)
        messageLabel.text = item.name
    }
}

