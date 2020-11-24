//
//  CollectionHeader.swift
//  FirebaseDB
//
//  Created by MAC on 24/11/20.
//

import UIKit
import SparkUI
import Layoutless

protocol CollectionHeaderDelagate {
    func didTapTitleLabel(indexPath: IndexPath)
    func didBeginLongPress(indexPath: IndexPath)
}

class CollectionHeader: CollectionSupplementaryView<Section>, SelfConfiguringCell {
    
    static var reuseIdentifier: String = "header-cell"
    
    var delegate: CollectionHeaderDelagate?
    
    let titleLabel = UILabel().text(color: .systemBlack).bold()
    
    override func layoutViews() {
        super.layoutViews()
        
        stack(.horizontal)(
            titleLabel,
            Spacer()
            ).fillingParent().layout(in: container)
        
    }
    
    override func configureViews(for item: Section?) {
        super.configureViews(for: item)
        guard let item = item else { return }
        
        titleLabel.text = item.title
    }
}
