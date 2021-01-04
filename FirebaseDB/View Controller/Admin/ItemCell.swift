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
    func didLikeItem(_ item: Item)
    func didUnlike(_ like: Like, item: Item)
}

class ItemCell: CollectionCell<Item>, SelfConfiguringCell {
    
    static var reuseIdentifier: String = "cell"
    
    var like: Like?
    
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
        ).insetting(leftBy: 12, rightBy: 12, topBy: 12, bottomBy: 0).fillingParent().layout(in: container)
        
    }
    
    override func configureViews(for item: Item?) {
        super.configureViews(for: item)
        guard let item = item else { return }
        imageView.setImage(from: item.headerImageUrl, renderingMode: .alwaysOriginal, contentMode: .scaleAspectFill, placeholderImage: nil, indicatorType: .activity)
        messageLabel.text = item.name
        heartImageView.setSystemImage(like != nil ? "heart.fill" : "heart")
    }
    
    override func addActions() {
        super.addActions()
        
        heartImageView.addAction {
            guard let item = self.item else { return }
            if self.like != nil {
                self.delegate?.didUnlike(self.like!, item: item)
                self.heartImageView.setSystemImage("heart")
            } else {
                self.delegate?.didLikeItem(item)
                self.heartImageView.setSystemImage("heart.fill")
            }
            
        }
    }
}

