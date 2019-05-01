/******************************************************************************
 Title:         Colors.swift
 Author:        Theodore Gallao
 Created on:    February 2, 2019
 Description:   An extension of UIColor class to create static variables for
                different color palettes.
 Purpose:       Ease of use and more robust way of using colors.
 Usage:         let color = UIColor.[ColorPalette].[ColorType].[colorName]
 Modifications:
 ******************************************************************************/

import Foundation
import UIKit

extension UIColor {
    func onePixelImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// Flat colors
    class Flat {
        /// Flat green colors (turquoise, greenSea, emerald, nephritis)
        class Green {
            /// Blue-ish green
            static var turquoise: UIColor {
                return UIColor(red: 26/255, green: 188/255, blue: 156/255, alpha: 1.0)
            }
            
            /// Darker turquoise
            static var greenSea: UIColor {
                return UIColor(red: 22/255, green: 160/255, blue: 133/255, alpha: 1.0)
            }
            
            /// More traditional green
            static var emerald: UIColor {
                return UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
            }
            
            /// Darker emerald
            static var nephritis: UIColor {
                return UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1.0)
            }
        }
        
        /// Flat blue colors (peterRiver, belizeHole)
        class Blue {
            // More traditional blue
            static var peterRiver: UIColor {
                return UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
            }
            
            // Darker peter river
            static var belizeHole: UIColor {
                return UIColor(red: 41/255, green: 128/255, blue: 185/255, alpha: 1.0)
            }
        }
        
        ///Flat purple colors (amethyst, wisteria)
        class Purple {
            /// More Traditional Purple
            static var amethyst: UIColor {
                return UIColor(red: 155/255, green: 89/255, blue: 182/255, alpha: 1.0)
            }
            
            /// Darker amethyst
            static var wisteria: UIColor {
                return UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
            }
        }
        
        /// Flat yellow colors (sunFlower)
        class Yellow {
            /// More traditional yellow
            static var sunFlower: UIColor {
                return UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0)
            }
        }
        
        /// Flat orange colors (orange, carrot, pumpkin)
        class Orange {
            /// More traditional orange
            static var orange: UIColor {
                return UIColor(red: 243/255, green: 156/255, blue: 18/255, alpha: 1.0)
            }
            
            /// Darker orange (stereotypical carrot)
            static var carrot: UIColor {
                return UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1.0)
            }
            
            /// Darker carrot (stereotypical pumpkin)
            static var pumpkin: UIColor {
                return UIColor(red: 211/255, green: 84/255, blue: 0/255, alpha: 1.0)
            }
        }
        
        /// Flat red colors (alizarin, pomegrenade)
        class Red {
            /// More traditional red
            static var alizarin: UIColor {
                return UIColor(red: 255/255, green: 70/255, blue: 57/255, alpha: 1.0)
            }
            
            /// Darker alizarin (stereotypical carrot)
            static var pomegrenade: UIColor {
                return UIColor(red: 192/255, green: 57/255, blue: 43/255, alpha: 1.0)
            }
        }
        
        class Black {
            /// Blue-ish dark color
            static var wetAsphalt: UIColor {
                return UIColor(red: 52/255, green: 73/255, blue: 94/255, alpha: 1.0)
            }
            
            /// Darker wetAsphalt
            static var midnightBlue: UIColor {
                return UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
            }
        }
        
        class White {
            /// Lightest color in this palette
            static var clouds: UIColor {
                return UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1.0)
            }
            
            static var darkSilver: UIColor {
                return UIColor(red: 226/255, green: 230/255, blue: 231/255, alpha: 1.0)
            }
            
            /// Second lightest color in this palette
            static var silver: UIColor {
                return UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1.0)
            }
        }
    }
    
    class LOLEsports {
        class White {
            static var white: UIColor {
                return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            }
        }
        
        class Blue {
            static var indicator: UIColor {
                return UIColor(red: 80/255, green: 179/255, blue: 206/255, alpha: 1.0)
            }
        }
        
        class Red {
            static var live: UIColor {
                return UIColor(red: 216/255, green: 27/255, blue: 47/255, alpha: 1.0)
            }
        }
        
        class Yellow {
            static var logo: UIColor {
                return UIColor(red: 192/255, green: 147/255, blue: 77/255, alpha: 1.0)
            }
        }
        
        class Gray {
            static var lightGray: UIColor {
                return UIColor(red: 136/255, green: 150/255, blue: 161/255, alpha: 1.0)
            }
            
            static var gray: UIColor {
                return UIColor(red: 75/255, green: 83/255, blue: 89/255, alpha: 1.0)
            }
            
            static var darkGray: UIColor {
                return UIColor(red: 37/255, green: 40/255, blue: 43/255, alpha: 1.0)
            }
            
            static var darkerGray: UIColor {
                return UIColor(red: 21/255, green: 23/255, blue: 25/255, alpha: 1.0)
            }
        }
        
        class Black {
            static var black: UIColor {
                return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
            }
        }
    }
    
    func interpolateTo(_ color: UIColor, value: CGFloat) -> UIColor? {
        let f = min(max(0, value), 1)
        
        guard let c1 = self.cgColor.components, let c2 = color.cgColor.components else { return nil }
        
        let r: CGFloat = CGFloat(c1[0] + (c2[0] - c1[0]) * f)
        let g: CGFloat = CGFloat(c1[1] + (c2[1] - c1[1]) * f)
        let b: CGFloat = CGFloat(c1[2] + (c2[2] - c1[2]) * f)
        let a: CGFloat = CGFloat(c1[3] + (c2[3] - c1[3]) * f)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
