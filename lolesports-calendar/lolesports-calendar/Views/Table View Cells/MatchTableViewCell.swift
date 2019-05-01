//
//  MatchTableViewCell.swift
//  lolesports-calendar
//
//  Created by Theodore Gallao on 3/19/19.
//  Copyright © 2019 Theodore Gallao. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class MatchTableViewCell: BasicTableViewCell {
    override open var id: String {
        return "__MATCH_TABLE_VIEW_CELL__"
    }
    
    private var matchWinnerStatus = -1
    private var isFavorite = false
    
    let hourLabel: UILabel = {
        let label             = UILabel()
        label.text            = "TBD"
        label.backgroundColor = UIColor.clear
        label.font            = UIFont.Trebuchet.bold.withSize(17)
        label.textColor       = UIColor.black
        label.textAlignment   = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let meridiemLabel: UILabel = {
        let label             = UILabel()
        label.backgroundColor = UIColor.clear
        label.font            = UIFont.Trebuchet.bold.withSize(10)
        label.textColor       = UIColor.black
        label.textAlignment   = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let scoresLabel: UILabel = {
        let label             = UILabel()
        label.text            = "0-0"
        label.backgroundColor = UIColor.clear
        label.font            = UIFont.Trebuchet.bold.withSize(14)
        label.textColor       = UIColor.LOLEsports.Black.black
        label.textAlignment   = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let versusLiteralLabel: UILabel = {
        let label             = UILabel()
        label.text            = "VS"
        label.backgroundColor = UIColor.clear
        label.font            = UIFont.Trebuchet.bold.withSize(14)
        label.textColor       = UIColor.LOLEsports.Gray.lightGray
        label.textAlignment   = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let winnerIndicatorImageView: UIImageView = {
        let imageView             = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode     = UIView.ContentMode.scaleToFill
        imageView.tintColor       = UIColor.Flat.Red.alizarin
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let team0ImageView: UIImageView = {
        let imageView             = UIImageView()
        imageView.image           = UIImage(named: "Circle")
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode     = UIView.ContentMode.scaleAspectFit
        imageView.tintColor       = UIColor.Flat.White.silver
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.vertical)
        imageView.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.horizontal)
        
        return imageView
    }()
    
    let team1ImageView: UIImageView = {
        let imageView             = UIImageView()
        imageView.image           = UIImage(named: "Circle")
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode     = UIView.ContentMode.scaleAspectFit
        imageView.tintColor       = UIColor.Flat.White.silver
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.vertical)
        imageView.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.horizontal)
        
        return imageView
    }()
    
    private let team0NameLabel: UILabel = {
        let label             = UILabel()
        label.text            = "TBD"
        label.backgroundColor = UIColor.clear
        label.font            = UIFont.Trebuchet.bold.withSize(14)
        label.textColor       = UIColor.LOLEsports.Black.black
        label.textAlignment   = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.vertical)
        
        return label
    }()
    
    private let team1NameLabel: UILabel = {
        let label             = UILabel()
        label.text            = "TBD"
        label.backgroundColor = UIColor.clear
        label.font            = UIFont.Trebuchet.bold.withSize(14)
        label.textColor       = UIColor.LOLEsports.Black.black
        label.textAlignment   = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.vertical)
        
        return label
    }()
    
    private let leagueLabel: UILabel = {
        let label             = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor       = UIColor.LOLEsports.Gray.lightGray
        label.textAlignment   = NSTextAlignment.right
        label.font            = UIFont.Trebuchet.bold.withSize(10)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let favoriteIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Flat.Red.alizarin
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var hourLabelConstraints                = [NSLayoutConstraint]()
    private var meridiemLabelConstraints            = [NSLayoutConstraint]()
    private var scoresLabelConstraints              = [NSLayoutConstraint]()
    private var versusLiteralLabelConstraints       = [NSLayoutConstraint]()
    private var winnerIndicatorImageViewConstraints = [NSLayoutConstraint]()
    private var team0ImageViewConstraints           = [NSLayoutConstraint]()
    private var team1ImageViewConstraints           = [NSLayoutConstraint]()
    private var team0NameLabelConstraints           = [NSLayoutConstraint]()
    private var team1NameLabelConstraints           = [NSLayoutConstraint]()
    private var favoriteIndicatorViewConstraints    = [NSLayoutConstraint]()
    private var leagueLabelConstraints              = [NSLayoutConstraint]()
    
    override func commonInit() {
        super.commonInit()
        
        self.contentView.addSubview(self.hourLabel)
        self.contentView.addSubview(self.meridiemLabel)
        self.contentView.addSubview(self.scoresLabel)
        self.contentView.addSubview(self.versusLiteralLabel)
        self.contentView.addSubview(self.winnerIndicatorImageView)
        self.contentView.addSubview(self.team0ImageView)
        self.contentView.addSubview(self.team1ImageView)
        self.contentView.addSubview(self.team0NameLabel)
        self.contentView.addSubview(self.team1NameLabel)
        self.contentView.addSubview(self.favoriteIndicatorView)
        self.contentView.addSubview(self.leagueLabel)
        
        self.configureHourLabelConstraints()
        self.configureMeridiemConstraints()
        self.configureScoresLabelConstraints()
        self.configureVersusLiteralLabelConstraints()
        self.configureWinnerIndicatorImageViewConstraints()
        self.configureTeam0ImageViewConstraints()
        self.configureTeam1ImageViewConstraints()
        self.configureTeam0NameLabelConstraints()
        self.configureTeam1NameLabelConstraints()
        self.configureFavoriteIndicatorViewConstraints()
        self.configureLeagueLabelConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.topSeparatorView.alpha    = 1
        self.bottomSeparatorView.alpha = 1
        
        self.hourLabel.text      = "TBD"
        self.hourLabel.alpha     = 1
        self.hourLabel.textColor = UIColor.black
        
        self.meridiemLabel.text      = ""
        self.meridiemLabel.alpha     = 1
        self.meridiemLabel.textColor = UIColor.black
        
        self.team0ImageView.image     = UIImage(named: "Circle")
        self.team0ImageView.alpha     = 1
        self.team0NameLabel.text      = "TBD"
        self.team0NameLabel.textColor = UIColor.LOLEsports.Black.black
        
        self.team1ImageView.image     = UIImage(named: "Circle")
        self.team1ImageView.alpha     = 1
        self.team1NameLabel.textColor = UIColor.LOLEsports.Black.black
        self.team1NameLabel.text      = "TBD"
    }
    
    private func configureHourLabelConstraints() {
        NSLayoutConstraint.deactivate(self.hourLabelConstraints)
        
        self.hourLabelConstraints = [
            self.hourLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            self.hourLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0)
        ]
        
        NSLayoutConstraint.activate(self.hourLabelConstraints)
    }
    
    private func configureMeridiemConstraints() {
        NSLayoutConstraint.deactivate(self.meridiemLabelConstraints)
        
        self.meridiemLabelConstraints = [
            self.meridiemLabel.leftAnchor.constraint(equalTo: self.hourLabel.rightAnchor, constant: 2),
            self.meridiemLabel.topAnchor.constraint(equalTo: self.hourLabel.topAnchor, constant: 2)
        ]
        
        NSLayoutConstraint.activate(self.meridiemLabelConstraints)
    }
    
    private func configureScoresLabelConstraints() {
        NSLayoutConstraint.deactivate(self.scoresLabelConstraints)
        
        self.scoresLabelConstraints = [
            self.scoresLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0),
            self.scoresLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: 0)
        ]
        
        NSLayoutConstraint.activate(self.scoresLabelConstraints)
    }
    
    
    private func configureVersusLiteralLabelConstraints() {
        NSLayoutConstraint.deactivate(self.versusLiteralLabelConstraints)
        
        self.versusLiteralLabelConstraints = [
            self.versusLiteralLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0),
            self.versusLiteralLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: 0)
        ]
        
        NSLayoutConstraint.activate(self.versusLiteralLabelConstraints)
    }
    
    private func configureWinnerIndicatorImageViewConstraints() {
        NSLayoutConstraint.deactivate(self.winnerIndicatorImageViewConstraints)
        
        var constraints = [
            self.winnerIndicatorImageView.heightAnchor.constraint(equalToConstant: 14),
            self.winnerIndicatorImageView.widthAnchor.constraint(equalToConstant: 18),
            self.winnerIndicatorImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0),
        ]
        
        if self.matchWinnerStatus == 0 {
            constraints.append(self.winnerIndicatorImageView.rightAnchor.constraint(equalTo: self.scoresLabel.leftAnchor, constant: 1))
        } else if self.matchWinnerStatus == 1 {
            constraints.append(self.winnerIndicatorImageView.leftAnchor.constraint(equalTo: self.scoresLabel.rightAnchor, constant: -1))
        }
        
        self.winnerIndicatorImageViewConstraints = constraints
        
        NSLayoutConstraint.activate(self.winnerIndicatorImageViewConstraints)
    }
    
    private func configureTeam0ImageViewConstraints() {
        NSLayoutConstraint.deactivate(self.team0ImageViewConstraints)
        
        self.team0ImageViewConstraints = [
            self.team0ImageView.widthAnchor.constraint(equalTo: self.team0ImageView.heightAnchor, multiplier: 1.0),
            self.team0ImageView.rightAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: -42),
            self.team0ImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
        ]
        
        NSLayoutConstraint.activate(self.team0ImageViewConstraints)
    }
    
    private func configureTeam1ImageViewConstraints() {
        NSLayoutConstraint.deactivate(self.team1ImageViewConstraints)
        
        self.team1ImageViewConstraints = [
            self.team1ImageView.widthAnchor.constraint(equalTo: self.team1ImageView.heightAnchor, multiplier: 1.0),
            self.team1ImageView.leftAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: 42),
            self.team1ImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
        ]
        
        NSLayoutConstraint.activate(self.team1ImageViewConstraints)
    }
    
    private func configureTeam0NameLabelConstraints() {
        NSLayoutConstraint.deactivate(self.team0NameLabelConstraints)
        
        self.team0NameLabelConstraints = [
            self.team0NameLabel.topAnchor.constraint(equalTo: self.team0ImageView.bottomAnchor, constant: 6),
            self.team0NameLabel.centerXAnchor.constraint(equalTo: self.team0ImageView.centerXAnchor, constant: 0),
            self.team0NameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(self.team0NameLabelConstraints)
    }
    
    private func configureTeam1NameLabelConstraints() {
        NSLayoutConstraint.deactivate(self.team1NameLabelConstraints)
        
        self.team1NameLabelConstraints = [
            self.team1NameLabel.topAnchor.constraint(equalTo: self.team1ImageView.bottomAnchor, constant: 6),
            self.team1NameLabel.centerXAnchor.constraint(equalTo: self.team1ImageView.centerXAnchor, constant: 0),
            self.team1NameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(self.team1NameLabelConstraints)
    }

    private func configureFavoriteIndicatorViewConstraints() {
        NSLayoutConstraint.deactivate(self.favoriteIndicatorViewConstraints)
        
        self.favoriteIndicatorViewConstraints = [
            self.favoriteIndicatorView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.favoriteIndicatorView.widthAnchor.constraint(equalToConstant: self.isFavorite ? 6 : 0),
            self.favoriteIndicatorView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0),
            self.favoriteIndicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ]
        
        NSLayoutConstraint.activate(self.favoriteIndicatorViewConstraints)
    }
    
    private func configureLeagueLabelConstraints() {
        NSLayoutConstraint.deactivate(self.leagueLabelConstraints)
        
        self.leagueLabelConstraints = [
            self.leagueLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20),
            self.leagueLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0)
        ]
        
        NSLayoutConstraint.activate(self.leagueLabelConstraints)
    }
    
    public func setDateRedundant(_ isDateRedundant: Bool) {
        if isDateRedundant {
            self.hourLabel.alpha     =  0
            self.meridiemLabel.alpha =  0
            self.topSeparatorViewLeftConstraint = 80
        } else {
            self.hourLabel.alpha     =  1
            self.meridiemLabel.alpha =  1
            self.topSeparatorViewLeftConstraint = 20
        }
    }
    
    public func setFirstCell(_ isFirstCell: Bool) {
        if isFirstCell {
            self.topSeparatorView.alpha = 0
        } else {
            self.topSeparatorView.alpha = 1
        }
    }
    
    public func setFavorite(_ isFavorite: Bool, animated: Bool) {
        self.isFavorite = isFavorite
        
        if animated {
            UIView.animate(withDuration: 1/3) {
                self.configureFavoriteIndicatorViewConstraints()
                self.contentView.layoutIfNeeded()
            }
        } else {
            self.configureFavoriteIndicatorViewConstraints()
            self.contentView.layoutIfNeeded()
        }
    }
    
    // Set function
    public func set(_ match: Match) {
        self.hourLabel.text                   = match.hourText
        self.meridiemLabel.text               = match.meridiemText
        self.topSeparatorView.backgroundColor = UIColor.Flat.White.silver
        self.topSeparatorViewRightConstraint  = -20
        self.bottomSeparatorView.alpha        = 0
        self.hourLabel.textColor              = match.hourTextColor
        self.meridiemLabel.textColor          = match.meridiemTextColor
        self.team0NameLabel.text              = match.team0NameText
        self.team0NameLabel.textColor         = match.team0NameTextColor
        self.team0ImageView.alpha             = match.team0ImageAlpha
        self.team1NameLabel.text              = match.team1NameText
        self.team1NameLabel.textColor         = match.team1NameTextColor
        self.team1ImageView.alpha             = match.team1ImageAlpha
        self.scoresLabel.text                 = match.scoresText
        self.matchWinnerStatus                = match.winnerStatus
        self.winnerIndicatorImageView.image   = match.winnerImage
        self.versusLiteralLabel.text          = match.versusText
        self.leagueLabel.text                 = match.leagueText
        
        let placeholderImage = UIImage(named: "Circle")
        DispatchQueue(label: "work", qos: DispatchQoS.utility).async {
            self.team0ImageView.sd_setImage(with: match.team0ImageUrl, placeholderImage: placeholderImage) { [weak self] (image, error, type, url) in
                if let image = image {
                    DispatchQueue.main.async {
                        self?.team0ImageView.image = image.resize(to: CGSize(width: 128, height: 128))
                    }
                }
            }
            
            self.team1ImageView.sd_setImage(with: match.team1ImageUrl, placeholderImage: placeholderImage) { [weak self] (image, error, type, url) in
                if let image = image {
                    DispatchQueue.main.async {
                        self?.team1ImageView.image = image.resize(to: CGSize(width: 128, height: 128))
                    }
                }
            }
        }
        
        self.configureWinnerIndicatorImageViewConstraints()
    }
}
