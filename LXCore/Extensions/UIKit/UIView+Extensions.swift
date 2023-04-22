//
//  UIView+Extensions.swift
//  LXCore
//
//  Created by Artak Gevorgyan on 02/Jan/23.
//  Copyright © 2022 Artak Gevorgyan. All rights reserved.
//

import UIKit
// swiftlint:disable all
extension UIView {
//    func shake() {
//        self.transform = CGAffineTransform(translationX: 20, y: 0)
//        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
//            self.transform = CGAffineTransform.identity
//        }, completion: nil)
//    }
    
    func attachToParent(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        guard let superview = superview else { return }
        
        
        superview.constraints.forEach { [unowned self, superview] in
            guard $0.firstItem as? UIView == self || $0.secondItem as? UIView == self else { return }
            if [.top, .left, .bottom, .right].contains($0.firstAttribute) {
                superview.removeConstraint($0)
            }
        }
        
        topAnchor.constraint(equalTo: superview.topAnchor, constant: top).isActive = true
        leftAnchor.constraint(equalTo: superview.leftAnchor, constant: left).isActive = true
        rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -right).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottom).isActive = true
    }
}

extension UIView {
    func setGradient(from: UIColor, to: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [from, to].map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        layer.bounds = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UIView {
    
    func rotationStart() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: -Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func rotationStop() {
        self.layer.removeAnimation(forKey: "rotationAnimation")
    }
    
    func addShadow(scale: Bool = true, color: UIColor, size: CGSize, opacity: Float, radius: CGFloat) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = size
        layer.shadowRadius = radius
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

