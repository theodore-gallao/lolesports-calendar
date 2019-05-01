//
//  LeagueTableViewCell.swift
//  lolesports-calendar
//
//  Created by Theodore Gallao on 3/29/19.
//  Copyright © 2019 Theodore Gallao. All rights reserved.
//

import Foundation
import UIKit

class LeagueTableViewCell: BasicTableViewCell {
    override open var id: String {
        return "__LEAGUE_TABLE_VIEW_CELL__"
    }
    
    private let selectedMarkerIndicatorView: UIView = {
        let view             = UIView()
        view.alpha           = 1
        view.backgroundColor = UIColor.Flat.Red.alizarin
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let leagueImageView: UIImageView = {
        let imageView             = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode     = UIView.ContentMode.scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let leagueNameLabel: UILabel = {
        let label             = UILabel()
        label.backgroundColor = UIColor.clear
        label.font            = UIFont.Trebuchet.bold.withSize(12)
        label.textColor       = UIColor.LOLEsports.Black.black
        label.textAlignment   = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let leagueRegionNameLabel: UILabel = {
        let label           = UILabel()
        label.font          = UIFont.Trebuchet.bold.withSize(12)
        label.textColor     = UIColor.LOLEsports.Gray.lightGray
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var selectedMarkerIndicatorViewConstraints = [NSLayoutConstraint]()
    
    override func commonInit() {
        super.commonInit()
        
        self.contentView.addSubview(self.selectedMarkerIndicatorView)
        self.contentView.addSubview(self.leagueImageView)
        self.contentView.addSubview(self.leagueNameLabel)
        self.contentView.addSubview(self.leagueRegionNameLabel)
        
        self.selectedMarkerIndicatorView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.selectedMarkerIndicatorView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.selectedMarkerIndicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        self.selectedMarkerIndicatorView.widthAnchor.constraint(equalToConstant: 6).isActive = true
        
        self.leagueImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        self.leagueImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        self.leagueImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10).isActive = true
        self.leagueImageView.widthAnchor.constraint(equalTo: self.leagueImageView.heightAnchor, multiplier: 1).isActive = true
        
        self.leagueNameLabel.bottomAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0).isActive = true
        self.leagueNameLabel.leftAnchor.constraint(equalTo: self.leagueImageView.rightAnchor, constant: 16).isActive = true
        self.leagueNameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20).isActive = true
        
        self.leagueRegionNameLabel.topAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        self.leagueRegionNameLabel.leftAnchor.constraint(equalTo: self.leagueImageView.rightAnchor, constant: 16).isActive = true
        self.leagueRegionNameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20).isActive = true
    }
    
    override func prepareForReuse() {
        self.leagueImageView.alpha      = 0.4
        self.leagueImageView.image      = nil
        self.leagueNameLabel.text       = ""
        self.leagueRegionNameLabel.text = ""
        self.leagueNameLabel.textColor  = UIColor.LOLEsports.Gray.lightGray
    }
    
    open func set(_ league: League, selected: Bool, animated: Bool) {
        DispatchQueue.main.async {
            self.leagueImageView.image      = league.image
            self.leagueNameLabel.text       = league.name.uppercased()
            self.leagueRegionNameLabel.text = league.regionName.uppercased()
            
            if selected {
                self.leagueNameLabel.textColor         = UIColor.Flat.Red.alizarin
                self.leagueRegionNameLabel.textColor   = UIColor.LOLEsports.Gray.lightGray
                self.leagueImageView.alpha             = 1
                self.selectedMarkerIndicatorView.alpha = 1
            } else {
                self.leagueNameLabel.textColor         = UIColor.LOLEsports.Gray.lightGray
                self.leagueRegionNameLabel.textColor   = UIColor.LOLEsports.Gray.lightGray.withAlphaComponent(0.5)
                self.leagueImageView.alpha             = 0.4
                self.selectedMarkerIndicatorView.alpha = 0
            }
        }
    }
}
