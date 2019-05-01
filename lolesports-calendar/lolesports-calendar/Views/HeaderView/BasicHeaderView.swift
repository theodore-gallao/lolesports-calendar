//
//  BasicHeaderView.swift
//  lolesports-calendar
//
//  Created by Theodore Gallao on 4/1/19.
//  Copyright © 2019 Theodore Gallao. All rights reserved.
//

import Foundation
import UIKit

class BasicHeaderView: HeaderView {
    let topSeparatorView: UIView = {
        let view             = UIView()
        view.backgroundColor = UIColor.Flat.White.silver
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 1
        
        return view
    }()
    
    let bottomSeparatorView: UIView = {
        let view             = UIView()
        view.backgroundColor = UIColor.Flat.White.silver
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.Trebuchet.bold.withSize(12)
        label.textColor = UIColor.LOLEsports.Black.black
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.Trebuchet.bold.withSize(12)
        label.textColor = UIColor.LOLEsports.Gray.lightGray
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let imageIndicatorView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let tapGestureRecognizer = UITapGestureRecognizer()
    
    override func commonInit() {
        super.commonInit()
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.subtitleLabel)
        self.addSubview(self.topSeparatorView)
        self.addSubview(self.bottomSeparatorView)
        self.addSubview(self.imageIndicatorView)

        self.titleLabel.leftAnchor
            .constraint(equalTo: self.leftAnchor, constant: 20)
            .isActive = true
        self.titleLabel.rightAnchor
            .constraint(equalTo: self.rightAnchor, constant: -20)
            .isActive = true
        self.titleLabel.bottomAnchor
            .constraint(equalTo: self.centerYAnchor, constant: 2)
            .isActive = true

        self.subtitleLabel.leftAnchor
            .constraint(equalTo: self.leftAnchor, constant: 20)
            .isActive = true
        self.subtitleLabel.rightAnchor
            .constraint(equalTo: self.rightAnchor, constant: -20)
            .isActive = true
        self.subtitleLabel.topAnchor
            .constraint(equalTo: self.centerYAnchor, constant: 0)
            .isActive = true

        self.topSeparatorView.heightAnchor
            .constraint(equalToConstant: 1)
            .isActive = true
        self.topSeparatorView.topAnchor
            .constraint(equalTo: self.topAnchor, constant: 0)
            .isActive = true
        self.topSeparatorView.leftAnchor
            .constraint(equalTo: self.leftAnchor, constant: 0)
            .isActive = true
        self.topSeparatorView.rightAnchor
            .constraint(equalTo: self.rightAnchor, constant: 0)
            .isActive = true

        self.bottomSeparatorView.heightAnchor
            .constraint(equalToConstant: 1)
            .isActive = true
        self.bottomSeparatorView.bottomAnchor
            .constraint(equalTo: self.bottomAnchor, constant: 1)
            .isActive = true
        self.bottomSeparatorView.leftAnchor
            .constraint(equalTo: self.leftAnchor, constant: 0)
            .isActive = true
        self.bottomSeparatorView.rightAnchor
            .constraint(equalTo: self.rightAnchor, constant: 0)
            .isActive = true

        self.imageIndicatorView.heightAnchor
            .constraint(equalToConstant: 20)
            .isActive = true
        self.imageIndicatorView.widthAnchor
            .constraint(equalToConstant: 20)
            .isActive = true
        self.imageIndicatorView.centerYAnchor
            .constraint(equalTo: self.centerYAnchor, constant: 0)
            .isActive = true
        self.imageIndicatorView.rightAnchor
            .constraint(equalTo: self.rightAnchor, constant: -20)
            .isActive = true
    }
}
