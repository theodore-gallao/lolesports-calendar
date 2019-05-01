//
//  LiveMatchTableViewCell.swift
//  lolesports-calendar
//
//  Created by Theodore Gallao on 3/19/19.
//  Copyright © 2019 Theodore Gallao. All rights reserved.
//

import Foundation
import UIKit

class LiveMatchTableViewCell: MatchTableViewCell {
    private let liveIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Flat.Red.alizarin
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let liveIndicatorCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Flat.Red.alizarin
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        
        return view
    }()
    
    private let liveLiteralLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.Trebuchet.bold.withSize(10)
        label.text = "LIVE"
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override var id: String {
        return "__LIVE_MATCH_TABLE_VIEW_CELL"
    }
    
    override func commonInit() {
        self.contentView.addSubview(self.liveIndicatorView)
        self.contentView.addSubview(self.liveIndicatorCircleView)
        self.contentView.addSubview(self.liveLiteralLabel)
        
        super.commonInit()
        
        self.liveIndicatorView.topAnchor
            .constraint(equalTo: self.topAnchor, constant: 0)
            .isActive = true
        self.liveIndicatorView.leftAnchor
            .constraint(equalTo: self.leftAnchor, constant: 0)
            .isActive = true
        self.liveIndicatorView.bottomAnchor
            .constraint(equalTo: self.bottomAnchor, constant: 0)
            .isActive = true
        self.liveIndicatorView.widthAnchor
            .constraint(equalToConstant: 6)
            .isActive = true
        
        self.liveIndicatorCircleView.heightAnchor
            .constraint(equalToConstant: 8)
            .isActive = true
        self.liveIndicatorCircleView.widthAnchor
            .constraint(equalToConstant: 8)
            .isActive = true
        self.liveIndicatorCircleView.leftAnchor
            .constraint(equalTo: self.contentView.leftAnchor, constant: 20)
            .isActive = true
        self.liveIndicatorCircleView.centerYAnchor
            .constraint(equalTo: self.contentView.centerYAnchor, constant: 0)
            .isActive = true
        
        self.liveLiteralLabel.leftAnchor
            .constraint(equalTo: self.liveIndicatorCircleView.rightAnchor, constant: 6)
            .isActive = true
        self.liveLiteralLabel.centerYAnchor
            .constraint(equalTo: self.contentView.centerYAnchor, constant: 0.5)
            .isActive = true
    }
    
    override func set(_ match: Match) {
        super.set(match)
        
        self.hourLabel.alpha = 0
        self.meridiemLabel.alpha = 0
    }
    
    override func setDateRedundant(_ isDateRedundant: Bool) {
        super.setDateRedundant(isDateRedundant)
        
        self.hourLabel.alpha = 0
        self.meridiemLabel.alpha = 0
    }
}
