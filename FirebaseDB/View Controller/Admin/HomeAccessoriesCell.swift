//
//  HomeAccessoriesCell.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 08.12.2020.
//

import UIKit
import SparkUI
import Stax

class HomeAccessoriesCell: CollectionCell<Item>, SelfConfiguringCell {
    
    static var reuseIdentifier: String = "cell"
    
    lazy var imageView = UIImageView()
        .masksToBounds()
        .contentMode(.scaleAspectFill)
        .cornerRadius(5)
        .square(self.frame.height - 12)
    
    lazy var titleLabel = UILabel()
        .text(color: .systemBlack)
        .textAlignment(.left)
        .regular(21)
    
    lazy var subtitleLabel = UILabel()
        .text(color: .systemGray3)
        .textAlignment(.left)
        .regular(16)
    
    override func layoutViews() {
        super.layoutViews()
        VStack(
            HStack(
                imageView,
                VStack(
                    titleLabel,
                    subtitleLabel
                ),
                Spacer()
            ).spacing(12).padding(by: 6),
            Spacer(),
            HLine(insets: UIEdgeInsets(top: 0, left: self.frame.height + 6, bottom: 0, right: 12))
        ).layout(in: container, withSafeArea: false)
        
    }
    
    override func configureViews(for item: Item?) {
        super.configureViews(for: item)
        guard let item = item else { return }
//        self.setCellBackgroundColor(all: .red)
        imageView.setImage(from: item.headerImageUrl, renderingMode: .alwaysOriginal, contentMode: .scaleAspectFill, placeholderImage: nil, indicatorType: .activity)
        titleLabel.text = item.name
        subtitleLabel.text = "Apple Music"
    }
}




