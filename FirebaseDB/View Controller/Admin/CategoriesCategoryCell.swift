//
//  CategoriesCategoryCell.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 04.01.2021.
//

import UIKit
import SparkUI
import Stax

class CategoriesCategoryCell: CollectionCell<Category>, SelfConfiguringCell {
    
    static var reuseIdentifier: String = "cell"
    
    lazy var imageView = UIImageView()
        .masksToBounds()
        .contentMode(.scaleAspectFit)
    
    lazy var titleLabel = UILabel()
        .text(color: .systemBlack)
        .font(.boldSystemFont(ofSize: 15))
        .setMultiline()
    
    override func layoutViews() {
        super.layoutViews()
        
        VStack(
            HStack(
                HStack(titleLabel).padding(.leading, 24),
                Spacer(),
                imageView.size(width: self.frame.width * 0.33, height: self.frame.height - 24)
            )
            .width(self.frame.width - 24)
            .background(color: .systemGray4)
            .setCorner(15)
        ).padding(by: 12).layout(in: container, withSafeArea: false)
        
    }
    
    override func configureViews(for item: Category?) {
        super.configureViews(for: item)
        guard let item = item else { return }
        imageView.setImage(from: item.headerImageUrl, renderingMode: .alwaysOriginal, contentMode: .scaleAspectFill, placeholderImage: nil, indicatorType: .activity)
        titleLabel.text = item.name
    }
}



