//
//  PaddingUILabel.swift
//  RandomChat
//
//  Created by Se Wang Oh on 8/18/18.
//  Copyright © 2018 Se Wang Oh. All rights reserved.
//

import UIKit

@IBDesignable
class PaddingUILabel: UILabel {
    
    @IBInspectable var topPadding: CGFloat = 5
    @IBInspectable var leftPadding: CGFloat = 5
    @IBInspectable var rightPadding: CGFloat = 5
    @IBInspectable var bottomPadding: CGFloat = 5
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topPadding, left: leftPadding, bottom: bottomPadding, right: rightPadding)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topPadding + bottomPadding
            contentSize.width += leftPadding + rightPadding
            return contentSize
        }
    }
    
}
