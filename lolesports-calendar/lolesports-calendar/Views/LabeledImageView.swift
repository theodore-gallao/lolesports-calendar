//
//  LabeledImageView.swift
//  lolesports-calendar
//
//  Created by Theodore Gallao on 4/17/19.
//  Copyright © 2019 Theodore Gallao. All rights reserved.
//

import Foundation
import UIKit

public enum LabelPosition {
    case top
    case left
    case right
    case bottom
}

public class LabeledImageView: UIView {
    /// Determines the content mode of the imageView
    override public var contentMode: UIView.ContentMode {
        didSet {
            super.contentMode = self.contentMode
            self.imageView.contentMode = self.contentMode
        }
    }
    
    /// The edge insets of the `UIImageView`. Default `UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)`
    public var imageEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            if self.didInitialize {
                self.configureLayout()
                self.layoutIfNeeded()
            }
        }
    }
    
    /// The edge insets of the `UILabel`. Default `UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)`
    public var labelEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            if self.didInitialize {
                self.configureLayout()
                self.layoutIfNeeded()
            }
        }
    }
    
    /// The position of the label. Default `LabelPosition.bottom`
    public var labelPosition: LabelPosition = .bottom {
        didSet {
            if self.didInitialize {
                self.configureLayout()
                self.layoutIfNeeded()
            }
        }
    }
    
    /// The image to be displayed. Default `nil`
    public var image: UIImage? = nil {
        didSet {
            self.imageView.image = self.image
        }
    }
    
    /// The text to be displayed in the label. Default `nil`
    public var text: String? = nil {
        didSet {
            self.label.text = self.text
        }
    }
    
    /// The font of the text in the label. Default `UIFont.systemFont(ofSize: 15)`
    public var font: UIFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            self.label.font = self.font
        }
    }
    
    /// The color of the text in the label. Default `UIColor.black`
    public var textColor: UIColor = UIColor.black {
        didSet {
            self.label.textColor = self.textColor
        }
    }
    
    /// The alignment of the text in the label. Default `NSTextAlignment.center`
    public var textAlignment: NSTextAlignment = NSTextAlignment.center {
        didSet {
            self.label.textAlignment = self.textAlignment
        }
    }
    
    private var didInitialize = false
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.vertical)
        imageView.setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.horizontal)
        
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 0
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.vertical)
        label.setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.horizontal)
        
        return label
    }()
    
    private var imageViewConstraints = [NSLayoutConstraint]()
    private var labelConstraints = [NSLayoutConstraint]()
    
    public init(image: UIImage?) {
        super.init(frame: CGRect.zero)
        
        self.commonInit(image: image)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit(image: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(image: UIImage?) {
        self.image = image
        
        self.addSubview(self.imageView)
        self.addSubview(self.label)
        
        self.configureLayout()
        
        self.didInitialize = true
    }
    
    private func configureLayout() {
        let isLabelPositionTop = self.labelPosition == .top
        let isLabelPositionLeft = self.labelPosition == .left
        let isLabelPositionRight = self.labelPosition == .right
        let isLabelPositionBottom = self.labelPosition == .bottom
        
        self.imageView.configureConstraints(&self.imageViewConstraints) { () -> [NSLayoutConstraint] in
            return [
                self.imageView.topAnchor.constraint(equalTo: isLabelPositionTop ? self.label.bottomAnchor : self.topAnchor,
                                                    constant: self.imageEdgeInsets.top),
                self.imageView.leftAnchor.constraint(equalTo: isLabelPositionLeft  ? self.label.rightAnchor : self.leftAnchor,
                                                     constant: self.imageEdgeInsets.left),
                self.imageView.rightAnchor.constraint(equalTo: isLabelPositionRight ? self.label.leftAnchor : self.rightAnchor,
                                                      constant: -self.imageEdgeInsets.right),
                self.imageView.bottomAnchor.constraint(equalTo: isLabelPositionBottom ? self.label.topAnchor : self.bottomAnchor,
                                                       constant: -self.imageEdgeInsets.bottom)
            ]
        }
        
        self.label.configureConstraints(&self.labelConstraints) { () -> [NSLayoutConstraint] in
            if isLabelPositionTop {
                return [
                    self.label.topAnchor.constraint(equalTo: self.topAnchor, constant: self.labelEdgeInsets.top),
                    self.label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: self.labelEdgeInsets.left),
                    self.label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -self.labelEdgeInsets.right),
                ]
            } else if isLabelPositionLeft {
                return [
                    self.label.topAnchor.constraint(equalTo: self.topAnchor, constant: self.labelEdgeInsets.top),
                    self.label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: self.labelEdgeInsets.left),
                    self.label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.labelEdgeInsets.bottom),
                ]
            } else if isLabelPositionRight {
                return [
                    self.label.topAnchor.constraint(equalTo: self.topAnchor, constant: self.labelEdgeInsets.top),
                    self.label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -self.labelEdgeInsets.right),
                    self.label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.labelEdgeInsets.bottom),
                ]
            } else {
                return [
                    self.label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: self.labelEdgeInsets.left),
                    self.label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -self.labelEdgeInsets.right),
                    self.label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.labelEdgeInsets.bottom),
                ]
            }
        }
    }
}
