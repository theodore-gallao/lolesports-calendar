//
//  Image.swift
//  Foodbase
//
//  Created by Theodore Gallao on 2/11/19.
//  Copyright © 2019 Theodore Gallao. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    /// Only use if your imageView's contentMode is scaleAspectFill
    func crop(to cropRect: CGRect, viewWidth: CGFloat, viewHeight: CGFloat, xOffset: CGFloat = 0, yOffset: CGFloat = 0) -> UIImage? {
        let widthScale = self.size.width / viewWidth
        let heightScale = self.size.height / viewHeight
        let imageViewScale = min(widthScale, heightScale)
        
        var imageOverflow: CGFloat
        if widthScale > heightScale { // Width will overflow
            let resizedImageWidth = self.size.width / imageViewScale
            imageOverflow = (resizedImageWidth - viewWidth)
        } else { // Height will overflow
            let resizedImageHeight = self.size.height / imageViewScale
            imageOverflow = (resizedImageHeight - viewHeight)
        }
        
        // Scale cropRect to handle images larger than shown-on-screen size
        // NOTE: x and y are INVERTED
        let cropZone = CGRect(x: (cropRect.origin.y * imageViewScale) + imageOverflow + yOffset,
                              y: cropRect.origin.x * imageViewScale + xOffset,
                              width: cropRect.width * imageViewScale,
                              height: cropRect.height * imageViewScale)
        
        // Perform cropping in Core Graphics
        guard let croppedImageRef: CGImage = self.cgImage?.cropping(to: cropZone)
            else {
                return nil
        }
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let croppedImage: UIImage = UIImage(cgImage: croppedImageRef, scale: self.scale, orientation: self.imageOrientation)
        
        return croppedImage
    }
    
    func resize(to targetSize: CGSize) -> UIImage? {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func pixelBuffer() -> CVPixelBuffer? {
        
        let width = Int(self.size.width)
        let height = Int(self.size.height)
        
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard status == kCVReturnSuccess else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(data: pixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else {
            return nil
        }
        
        context.translateBy(x: 0, y: CGFloat(height))
        context.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
}
