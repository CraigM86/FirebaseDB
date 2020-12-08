//
//  HomeIndoorOutdoorItemCell.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 08.12.2020.
//

import UIKit
import SparkUI
import Stax

class HomeIndoorOutdoorItemCell: CollectionCell<Item>, SelfConfiguringCell {
    
    static var reuseIdentifier: String = "cell"
    
    lazy var imageView = UIImageView()
        .masksToBounds()
        .contentMode(.scaleAspectFill)
        .cornerRadius(5)
        .square(self.frame.width - 24)
    
    lazy var titleLabel = UILabel()
        .text(color: .systemBlack)
        .textAlignment(.left)
        .regular(21)
    
    lazy var subtitleLabel = UILabel()
        .text(color: .systemGray3)
        .textAlignment(.left)
        .regular(21)
    
    override func layoutViews() {
        super.layoutViews()
        
        VStack(
            imageView,
            titleLabel,
            subtitleLabel,
            Spacer()
        ).spacing(6).padding(by: 12).layout(in: container, withSafeArea: false)
        
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



