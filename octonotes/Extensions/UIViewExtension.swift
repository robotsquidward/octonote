//
//  UIViewExtension.swift
//
//  Created by Dan Bellinski on 4/19/17.
//  Copyright © 2017 Base11 Studios. All rights reserved.
//

import Foundation
import UIKit

private var intendedCornerRadiusInternal: CGFloat = 0
private var editModeInternal: Bool = false
private var hasShadowInternal: Bool = false

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            if !hasShadow {
                layer.cornerRadius = newValue
                layer.masksToBounds = newValue > 0
            } else {
                layer.cornerRadius = 0
                layer.masksToBounds = false
            }
            objc_setAssociatedObject(self, &intendedCornerRadiusInternal, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var cornerRadiusInternal: CGFloat {
        get {
            let value = objc_getAssociatedObject(self, &intendedCornerRadiusInternal)
            
            guard let floatValue = value as? CGFloat else {
                return 0
            }
            
            return floatValue
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var hasShadow: Bool {
        get {
            let value = objc_getAssociatedObject(self, &hasShadowInternal)
            
            guard let boolValue = value as? Bool else {
                return false
            }
            
            return boolValue
        }
        set(newValue) {
            objc_setAssociatedObject(self, &hasShadowInternal, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            if newValue && cornerRadius != 0 {
                let oldCornerRadius = cornerRadius
                cornerRadius = 0
                objc_setAssociatedObject(self, &intendedCornerRadiusInternal, oldCornerRadius, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            } else if !newValue && cornerRadiusInternal != cornerRadius {
                cornerRadius = cornerRadiusInternal
            }
        }
    }
    
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.masksToBounds = true
        gradient.cornerRadius = cornerRadiusInternal
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyShadow() {
        self.applyShadow(color: UIColor.darkGray, size: 6)
    }
    
    func applyShadow(color: UIColor, size: Int) {
        self.backgroundColor = UIColor.clear
        self.layer.shadowOffset = CGSize(width: 0, height: size)
        self.layer.shadowRadius = CGFloat(size)
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 0.20
        self.layer.masksToBounds = false
    }
    
    func imageWithRoundedCornersSize(cornerRadius: CGFloat, usingImage original: UIImage) -> UIImage {
        let frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(original.size.width), height: CGFloat(original.size.height))
        UIGraphicsBeginImageContextWithOptions(original.size, false, original.scale)
        
        // Clip to size of corner
        UIBezierPath(roundedRect: frame, cornerRadius: cornerRadius).addClip()
        original.draw(in: frame)
        let image: UIImage! = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
