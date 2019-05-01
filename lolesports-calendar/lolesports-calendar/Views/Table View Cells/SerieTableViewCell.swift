//
//  SerieTableViewCell.swift
//  lolesports-calendar
//
//  Created by Theodore Gallao on 4/2/19.
//  Copyright © 2019 Theodore Gallao. All rights reserved.
//

import Foundation
import UIKit

class SerieTableViewCell: UITableViewCell {
    open var id: String {
        return "__SERIE_TABLE_VIEW_CELL__"
    }
    
    let liveIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Flat.Red.alizarin
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let serieNameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let rightArrowImageView: UIView = {
        let imageView = UIImageView(image: UIImage(named: "Forward Arrow"))
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.tintColor = UIColor.black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.contentView.addSubview(self.serieNameLabel)
        self.contentView.addSubview(self.rightArrowImageView)
        self.contentView.addSubview(self.liveIndicatorView)
        
        self.liveIndicatorView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.liveIndicatorView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.liveIndicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        self.liveIndicatorView.widthAnchor.constraint(equalToConstant: 4).isActive = true
        
        self.serieNameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        self.serieNameLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20).isActive = true
        self.serieNameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0).isActive = true
        self.serieNameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
        
        self.rightArrowImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.rightArrowImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        self.rightArrowImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        self.rightArrowImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.serieNameLabel.text = ""
    }
}
