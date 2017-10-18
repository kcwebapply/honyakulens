//
//  TJViewExtensions.swift
//  TJExtension
//
//  Created by tajika on 2015/12/08.
//  Copyright © 2015年 Tajika. All rights reserved.
//

import UIKit

extension UIView {
    
    enum BorderPosition {
        case top
        case right
        case bottom
        case left
    }
    
    func border(borderWidth: CGFloat, borderColor: UIColor?, borderRadius: CGFloat?) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor?.cgColor
        if let _ = borderRadius {
            self.layer.cornerRadius = borderRadius!
        }
        self.layer.masksToBounds = true
    }

    func border(_ positions: [BorderPosition], borderWidth: CGFloat, borderColor: UIColor?) {

        let topLine = CALayer()
        let leftLine = CALayer()
        let bottomLine = CALayer()
        let rightLine = CALayer()
        
        self.layer.sublayers = nil
        self.layer.masksToBounds = true
        
        if let _ = borderColor {
            topLine.backgroundColor = borderColor!.cgColor
            leftLine.backgroundColor = borderColor!.cgColor
            bottomLine.backgroundColor = borderColor!.cgColor
            rightLine.backgroundColor = borderColor!.cgColor
        } else {
            topLine.backgroundColor = UIColor.white.cgColor
            leftLine.backgroundColor = UIColor.white.cgColor
            bottomLine.backgroundColor = UIColor.white.cgColor
            rightLine.backgroundColor = UIColor.white.cgColor
        }
        
        if positions.contains(.top) {
            topLine.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: borderWidth)
            self.layer.addSublayer(topLine)
        }
        if positions.contains(.left) {
            leftLine.frame = CGRect(x: 0.0, y: 0.0, width: borderWidth, height: self.frame.height)
            self.layer.addSublayer(leftLine)
        }
        if positions.contains(.bottom) {
            bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - borderWidth, width: self.frame.width, height: borderWidth)
            self.layer.addSublayer(bottomLine)
        }
        if positions.contains(.right) {
            rightLine.frame = CGRect(x: self.frame.width - borderWidth, y: 0.0, width: borderWidth, height: self.frame.height)
            self.layer.addSublayer(rightLine)
        }

    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let _ = self.layer.borderColor {
                return UIColor(cgColor: self.layer.borderColor!)
            }
            return nil
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
}
