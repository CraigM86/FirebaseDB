//
//  CollectionViewCell.swift
//  FirebaseDB
//
//  Created by MAC on 24/11/20.
//

import UIKit
import SparkUI
import Layoutless

class CollectionViewCell: CollectionCell<Item>, SelfConfiguringCell {
    
    static var reuseIdentifier: String = "cell"
    
    let titleLabel = UILabel()
        .text(color: .systemBlack)
        .bold()
        .textAlignment(.center)
    
    override func layoutViews() {
        super.layoutViews()
        
        stack(.vertical)(
            titleLabel
            ).fillingParent().layout(in: container)
        
    }
    
    override func configureViews(for item: Item?) {
        super.configureViews(for: item)
        guard let item = item else { return }
        
        titleLabel.text = "\(item.name)"
    }
}
