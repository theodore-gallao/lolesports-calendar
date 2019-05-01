//
//  BasicTableViewCell.swift
//  Po11
//
//  Created by Theodore Gallao on 1/25/18.
//  Copyright © 2018 Theodore Gallao. All rights reserved.
//

import Foundation
import UIKit

class BasicTableViewCell : UITableViewCell {
    open var id: String {
        return "__MATCH_TABLE_VIEW_CELL__"
    }
    
    var topSeparatorViewLeftConstraint: CGFloat = 0
    var topSeparatorViewRightConstraint: CGFloat = 0
    var bottomSeparatorViewLeftConstraint: CGFloat = 0
    var bottomSeparatorViewRightConstraint: CGFloat = 0
    
    var topSeparatorViewConstraints = [NSLayoutConstraint]()
    var bottomSeparatorViewConstraints = [NSLayoutConstraint]()
    
    let topSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let bottomSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init() {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "")
        
        self.commonInit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    public func commonInit() {
        self.addSubview(self.topSeparatorView)
        self.addSubview(self.bottomSeparatorView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.configureTopSeparatorViewConstraints()
        self.configureBottomSeparatorViewConstraints()
    }
    
    func configureTopSeparatorViewConstraints() {
        NSLayoutConstraint.deactivate(self.topSeparatorViewConstraints)
        
        self.topSeparatorViewConstraints = [
            self.topSeparatorView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.topSeparatorView.heightAnchor.constraint(equalToConstant: 1),
            self.topSeparatorView.leftAnchor.constraint(equalTo: self.leftAnchor,
                                                        constant: self.topSeparatorViewLeftConstraint),
            self.topSeparatorView.rightAnchor.constraint(equalTo: self.rightAnchor,
                                                         constant: self.topSeparatorViewRightConstraint)
        ]
        
        NSLayoutConstraint.activate(self.topSeparatorViewConstraints)
    }
    
    func configureBottomSeparatorViewConstraints() {
        NSLayoutConstraint.deactivate(self.bottomSeparatorViewConstraints)
        
        self.bottomSeparatorViewConstraints = [
            self.bottomSeparatorView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
            self.bottomSeparatorView.heightAnchor.constraint(equalToConstant: 1),
            self.bottomSeparatorView.leftAnchor.constraint(equalTo: self.leftAnchor,
                                                        constant: self.bottomSeparatorViewLeftConstraint),
            self.bottomSeparatorView.rightAnchor.constraint(equalTo: self.rightAnchor,
                                                         constant: self.bottomSeparatorViewRightConstraint)
        ]
        
        NSLayoutConstraint.activate(self.bottomSeparatorViewConstraints)
    }
}
