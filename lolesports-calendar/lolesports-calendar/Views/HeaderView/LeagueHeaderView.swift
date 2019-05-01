//
//  LeagueHeaderView.swift
//  lolesports-calendar
//
//  Created by Theodore Gallao on 3/31/19.
//  Copyright © 2019 Theodore Gallao. All rights reserved.
//

import Foundation
import UIKit

class LeagueHeaderView: BasicHeaderView {
    private let leagueImageView: UIImageView = {
        let imageView             = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode     = UIView.ContentMode.scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let leagueLabel: UILabel = {
        let label             = UILabel()
        label.backgroundColor = UIColor.clear
        label.font            = UIFont.Trebuchet.bold.withSize(12)
        label.textColor       = UIColor.LOLEsports.Black.black
        label.textAlignment   = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let regionLabel: UILabel = {
        let label             = UILabel()
        label.backgroundColor = UIColor.clear
        label.font            = UIFont.Trebuchet.bold.withSize(12)
        label.textColor       = UIColor.LOLEsports.Gray.lightGray
        label.textAlignment   = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func commonInit() {
        super.commonInit()
        
        self.addSubview(self.topSeparatorView)
        self.addSubview(self.bottomSeparatorView)
        self.addSubview(self.leagueImageView)
        self.addSubview(self.leagueLabel)
        self.addSubview(self.regionLabel)

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
            .constraint(equalTo: self.bottomAnchor, constant: 0)
            .isActive = true
        self.bottomSeparatorView.leftAnchor
            .constraint(equalTo: self.leftAnchor, constant: 0)
            .isActive = true
        self.bottomSeparatorView.rightAnchor
            .constraint(equalTo: self.rightAnchor, constant: 0)
            .isActive = true

        self.leagueImageView.topAnchor
            .constraint(equalTo: self.topAnchor, constant: 6)
            .isActive = true
        self.leagueImageView.leftAnchor
            .constraint(equalTo: self.leftAnchor, constant: 20)
            .isActive = true
        self.leagueImageView.bottomAnchor
            .constraint(equalTo: self.bottomAnchor, constant: -6)
            .isActive = true
        self.leagueImageView.widthAnchor
            .constraint(equalTo: self.leagueImageView.heightAnchor, constant: 0)
            .isActive = true

        self.leagueLabel.leftAnchor
            .constraint(equalTo: self.leagueImageView.rightAnchor, constant: 16)
            .isActive = true
        self.leagueLabel.bottomAnchor
            .constraint(equalTo: self.centerYAnchor, constant: 1)
            .isActive = true

        self.regionLabel.leftAnchor
            .constraint(equalTo: self.leagueImageView.rightAnchor, constant: 16)
            .isActive = true
        self.regionLabel.topAnchor
            .constraint(equalTo: self.centerYAnchor, constant: -1)
            .isActive = true
    }
    
    public func set(_ league: League, tournamentType: String) {
        DispatchQueue.main.async {
            self.leagueImageView.image = league.image
        }
        
        self.leagueLabel.text = league.name.uppercased() + " - " + tournamentType.uppercased()
        self.regionLabel.text = league.regionName.uppercased()
    }
}
