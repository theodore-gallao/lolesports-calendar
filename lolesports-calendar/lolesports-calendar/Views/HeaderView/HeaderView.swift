//
//  BasicHeaderView.swift
//  lolesports-calendar
//
//  Created by Theodore Gallao on 4/1/19.
//  Copyright © 2019 Theodore Gallao. All rights reserved.
//

import Foundation
import UIKit

protocol HeaderViewDelegate {
    func headerView(_ headerView: HeaderView, didTap withTag: Int)
}

class HeaderView: UIView {
    var delegate: HeaderViewDelegate?
    
    
    private let tapGestureRecognizer = UITapGestureRecognizer()
    
    init() {
        super.init(frame: CGRect.zero)
        
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func commonInit() {
        self.addGestureRecognizer(self.tapGestureRecognizer)
        self.tapGestureRecognizer.addTarget(self, action: #selector(self.handleTapGestureRecognizer(_:)))
    }
    
    @objc private func handleTapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        self.delegate?.headerView(self, didTap: self.tag)
    }
}
