//
//  LabelCollectionViewCell.swift
//  Foodbase
//
//  Created by Theodore Gallao on 2/10/19.
//  Copyright © 2019 Theodore Gallao. All rights reserved.
//

import Foundation
import UIKit

class LabelCollectionViewCell: UICollectionViewCell {
    open var id: String {
        return "__LABEL_COLLECTION_VIEW_CELL_ID__"
    }
    
    private var labelConstraints = [NSLayoutConstraint]()
    
    let label: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.setContentHuggingPriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.vertical)
        label.setContentHuggingPriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.horizontal)
        
        label.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.vertical)
        label.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.horizontal)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func commonInit() {
        self.contentView.addSubview(self.label)
        
        self.configureLayout()
    }
    
    open func configureLayout() {
        self.label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        self.label.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 0).isActive = true
        self.label.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0).isActive = true
        self.label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
    }
}
