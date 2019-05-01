/******************************************************************************
 Title:         Fonts.swift
 Author:        Theodore Gallao
 Created on:    February 2, 2019
 Description:   An extension of UIFont class to create static variables for
                different fonts.
 Purpose:       Ease of use and more robust way of using fonts.
 Usage:         let font = UIFont.[FontName].[fontType]
 Modifications:
 ******************************************************************************/

import Foundation
import UIKit

extension UIFont {
    /// Courier fonts
    class Courier {
        static var regular: UIFont {
            return UIFont(name: "Courier", size: 17)!
        }
        
        static var bold: UIFont {
            return UIFont(name: "Courier-Bold", size: 17)!
        }
        
        static var boldOblique: UIFont {
            return UIFont(name: "Courier-BoldOblique", size: 17)!
        }
        
        static var oblique: UIFont {
            return UIFont(name: "Courier-Oblique", size: 17)!
        }
    }
    
    /// Trebuchet fonts
    class Trebuchet {
        static var regular: UIFont {
            return UIFont(name: "AvenirNext-Demibold", size: 17)!
        }
        
        static var bold: UIFont {
            return UIFont(name: "AvenirNext-Bold", size: 17)!
        }
        
        static var boldOblique: UIFont {
            return UIFont(name: "AvenirNext-BoldItalic", size: 17)!
        }
        
        static var oblique: UIFont {
            return UIFont(name: "AvenirNext-Italic", size: 17)!
        }
    }
}
