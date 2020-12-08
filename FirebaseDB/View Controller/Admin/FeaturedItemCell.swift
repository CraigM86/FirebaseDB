//
//  FeaturedItemCell.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 08.12.2020.
//

import UIKit
import SparkUI
import Stax

class FeaturedItemCell: CollectionCell<Item>, SelfConfiguringCell {
    
    static var reuseIdentifier: String = "cell"
    
    lazy var imageView = UIImageView()
        .masksToBounds()
        .contentMode(.scaleAspectFill)
        .cornerRadius(15)
        .size(CGSize(width: self.frame.width - 24, height: self.frame.height - 24))
    
    lazy var titleLabel = UILabel()
        .text(color: .systemWhite)
        .textAlignment(.left)
        .font(.boldSystemFont(ofSize: 48))
        .setMultiline()
    
    override func layoutViews() {
        super.layoutViews()
        
        VStack(
            imageView
        ).padding(by: 12).layout(in: container)
        
        VStack(
            titleLabel,
            Spacer()
        ).padding(by: 36).layout(in: container, withSafeArea: false)
        
    }
    
    override func configureViews(for item: Item?) {
        super.configureViews(for: item)
        guard let item = item else { return }
        imageView.setImage(from: item.headerImageUrl, renderingMode: .alwaysOriginal, contentMode: .scaleAspectFill, placeholderImage: nil, indicatorType: .activity)
        titleLabel.text = item.name
    }
}


