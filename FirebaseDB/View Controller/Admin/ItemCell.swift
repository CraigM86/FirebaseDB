//
//  ItemCell.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 02.12.2020.
//

import UIKit
import SparkUI
import Layoutless

protocol ItemCellDelegate {
    func didTap(_ item: Item)
}

class ItemCell: CollectionCell<Item>, SelfConfiguringCell {
    
    static var reuseIdentifier: String = "cell"
    
    var isLiked = false
    
    var delegate: ItemCellDelegate?
    
    lazy var imageView = UIImageView()
        .masksToBounds()
        .contentMode(.scaleAspectFill)
        .square(self.frame.size.width)
    
    lazy var messageLabel = UILabel()
        .text(color: .systemBlack)
        .font(.boldSystemFont(ofSize: 15))//.width(self.frame.width - 110)
    
    lazy var heartImageView = UIImageView()
        .templateImageColor(.red)
        .masksToBounds()
        .contentMode(.scaleAspectFit)
        .square(44)
    
    override func layoutViews() {
        super.layoutViews()
        
        stack(.vertical, spacing: 15)(
            imageView,
            stack(.horizontal)(
                messageLabel,
                heartImageView
            ),
            Spacer()
//            stack(.vertical)(
//                Spacer().setHeight(5),
//                messageLabel,
//                Spacer(),
//                SDivider()
//            )
        ).insetting(leftBy: 12, rightBy: 12, topBy: 12, bottomBy: 0).fillingParent().layout(in: container)
        
    }
    
    override func configureViews(for item: Item?) {
        super.configureViews(for: item)
        guard let item = item else { return }
        imageView.setImage(from: item.headerImageUrl, renderingMode: .alwaysOriginal, contentMode: .scaleAspectFill, placeholderImage: nil, indicatorType: .activity)
        messageLabel.text = item.name
        heartImageView.setSystemImage(isLiked ? "heart.fill" : "heart")
    }
    
    override func addActions() {
        super.addActions()
        
        heartImageView.addAction {
            guard let item = self.item else { return }
            self.delegate?.didTap(item)
        }
    }
}

