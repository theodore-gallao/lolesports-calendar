//
//  UIFont.swift
//  Po11
//
//  Created by Theodore Gallao on 5/4/18.
//  Copyright © 2018 Theodore Gallao. All rights reserved.
//

import Foundation
import UIKit

public extension UIFont {
    
    func withTraits(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    static func title(size: CGFloat) -> UIFont {
        return UIFont(name: "SavoyeLetPlain", size: size)!
    }
    
    static func mainBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Avenir-Black", size: size)!
    }
    
    static func mainHeavy(size: CGFloat) -> UIFont {
        return UIFont(name: "Avenir-Heavy", size: size)!
    }
    
    static func mainRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Avenir-Medium", size: size)!
    }
    
    static func mainRegularOblique(size: CGFloat) -> UIFont {
        return UIFont(name: "Avenir-MediumOblique", size: size)!
    }
    
    var italic : UIFont {
        return withTraits(.traitItalic)
    }
    
    var bold : UIFont {
        return withTraits(.traitBold)
    }
    
    var boldItalic: UIFont {
        return withTraits(.traitBold, .traitItalic)
    }
}

