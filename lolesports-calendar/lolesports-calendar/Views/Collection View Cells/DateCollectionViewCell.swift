//
//  DateCollectionViewCell.swift
//  lolesports-calendar
//
//  Created by Theodore Gallao on 3/19/19.
//  Copyright © 2019 Theodore Gallao. All rights reserved.
//

import Foundation
import UIKit

class DateCollectionViewCell: LabelCollectionViewCell {
    override var id: String {
        return "__DATE_COLLECTION_VIEW_CELL_ID__"
    }
    
    private(set) var date: Date = Date()
    
    private let todayIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Flat.Red.alizarin
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func commonInit() {
        self.contentView.addSubview(self.todayIndicatorView)
        
        super.commonInit()
        self.configureLayout()
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        self.todayIndicatorView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        self.todayIndicatorView.widthAnchor.constraint(equalToConstant: 4).isActive = true
        self.todayIndicatorView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: 0).isActive = true
        self.todayIndicatorView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 2).isActive = true
    }
    
    func setDate(date: Date) {
        self.date = date
        self.todayIndicatorView.alpha = 0
        let day = Calendar.current.component(Calendar.Component.day, from: date)
        
        self.label.text = "\(day)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
