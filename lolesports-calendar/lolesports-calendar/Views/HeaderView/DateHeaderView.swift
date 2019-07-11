//
//  DateHeaderView.swift
//  lolesports-calendar
//
//  Created by Theodore Gallao on 4/16/19.
//  Copyright © 2019 Theodore Gallao. All rights reserved.
//

import Foundation
import UIKit

class DateHeaderView: BasicHeaderView {
    public func set(_ dateModel: DateModel?) {
        let image = UIImage(named: "Expand Arrow")?
            .resize(to: CGSize(width: 64, height: 64))?
            .withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        
        self.backgroundColor = UIColor.white
        self.titleLabel.font              = UIFont.Trebuchet.bold.withSize(12)
        self.titleLabel.textColor         = UIColor.black
        self.titleLabel.textAlignment     = NSTextAlignment.left
        self.subtitleLabel.font           = UIFont.Trebuchet.bold.withSize(12)
        self.subtitleLabel.textAlignment  = NSTextAlignment.left
        self.subtitleLabel.textColor      = UIColor.LOLEsports.Gray.lightGray
        self.imageIndicatorView.image     = image
        self.imageIndicatorView.tintColor = UIColor.LOLEsports.Gray.lightGray
        
        let yesterday = Calendar.current.date(byAdding: Calendar.Component.day, value: -1, to: Date())!
        let tomorrow  = Calendar.current.date(byAdding: Calendar.Component.day, value: 1, to: Date())!
        
        if let dateModel = dateModel {
            self.titleLabel.text = "\(dateModel.monthStr.uppercased()) \(dateModel.day), \(dateModel.year)"
            
            if dateModel.date.isInToday {
                self.subtitleLabel.text = "TODAY"
                self.subtitleLabel.textColor = UIColor.Flat.Red.alizarin
            } else if dateModel.date.isInSameDay(date: yesterday, timeZone: TimeZone(abbreviation: "UTC")!) {
                self.subtitleLabel.text = "YESTERDAY"
            } else if dateModel.date.isInSameDay(date: tomorrow, timeZone: TimeZone(abbreviation: "UTC")!) {
                self.subtitleLabel.text = "TOMORROW"
            } else {
                self.subtitleLabel.text = dateModel.weekdayStr.uppercased()
            }
        } else {
            self.titleLabel.text = "TBD"
            self.subtitleLabel.text = "TBD"
        }
    }
}
