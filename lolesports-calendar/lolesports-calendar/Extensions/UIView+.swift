//
//  View.swift
//  Virtual-Computer
//
//  Created by Theodore Gallao on 2/2/19.
//  Copyright © 2019 Theodore Gallao. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func configureConstraints(_ constraints: inout [NSLayoutConstraint], with newConstraints: () -> [NSLayoutConstraint]) {
        NSLayoutConstraint.deactivate(constraints)
        
        constraints = newConstraints()
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func dropShadow(color:      UIColor = UIColor.black,
                    opacity:    Float = 0.5,
                    offSet:     CGSize,
                    radius:     CGFloat = 1) {
        self.layer.masksToBounds    = false
        self.layer.shadowColor      = color.cgColor
        self.layer.shadowOpacity    = opacity
        self.layer.shadowOffset     = offSet
        self.layer.shadowRadius     = radius
    }
    
    func animateTap(duration: TimeInterval, scaleDownFactor: CGFloat, scaleUpFactor: CGFloat) {
        let duration1 = duration * 0.2
        let duration2 = duration * 0.4
        let duration3 = duration * 0.6
        UIView.animate(withDuration: duration1, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.transform = CGAffineTransform(scaleX: scaleDownFactor, y: scaleDownFactor)
        }) { _ in
            UIView.animate(withDuration: duration2, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                self.transform = CGAffineTransform(scaleX: scaleUpFactor, y: scaleUpFactor)
            }) { _ in
                UIView.animate(withDuration: duration3, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                    self.transform = CGAffineTransform.identity
                }, completion: nil )
            }
        }
    }
}

extension UIScrollView {
    
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        setContentOffset(bottomOffset, animated: true)
    }
}
