//
//  LXIOSCoreBaseRepository.swift
//  LXCore
//
//  Created by Artak Gevorgyan on 25.06.23.
//

import Foundation
import UIKit

struct LXCoreLabelStyle {
    var bgColor: UIColor?
    var textColor: UIColor?
    var textFont: UIFont?


    init(bgColor: UIColor? = nil,
         textColor: UIColor? = nil,
         textFont: UIFont? = nil) {
        self.bgColor = bgColor
        self.textColor = textColor
        self.textFont = textFont
    }
}

struct LXCoreViewStyle {
    var bgColor: UIColor?
    var cornerRadius: CGFloat?
    var borderColor: UIColor?
    var borderWidth: CGFloat?

    init(bgColor: UIColor? = nil,
         cornerRadius: CGFloat? = nil,
         borderColor: UIColor? = nil,
         borderWidth: CGFloat? = nil) {
        self.bgColor = bgColor
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor
        self.borderWidth = borderWidth
    }
}

struct LXCoreTextFieldStyle {
    var bgColor: UIColor?
    var textColor: UIColor?
    var textFont: UIFont?

    init(bgColor: UIColor? = nil,
         textColor: UIColor? = nil,
         textFont: UIFont? = nil) {
        self.bgColor = bgColor
        self.textColor = textColor
        self.textFont = textFont
    }
}


extension UILabel {

    func setStyleLXCore(_ style: LXCoreLabelStyle) {
        self.font = style.textFont
        self.textColor = style.textColor
        self.backgroundColor = style.bgColor
    }
}

extension UITextField {

    func setStyleLXCore(_ style: LXCoreTextFieldStyle) {
        self.font = style.textFont
        self.textColor = style.textColor
        self.backgroundColor = style.bgColor
    }
}

extension UIView {

    func setStyleLXCore(_ style: LXCoreViewStyle) {
        self.backgroundColor = style.bgColor
        self.layer.cornerRadius = style.cornerRadius ?? 0
        self.layer.borderColor = style.borderColor?.cgColor
        self.layer.borderWidth = style.borderWidth ?? 0
    }
}
