//
//  LXCoreInputViewStyle.swift
//  LXCore
//
//  Created by Artak Gevorgyan on 22.10.23.
//  Copyright © 2023 Artak Gevorgyan LLC. All rights reserved.
//

import Foundation
import UIKit

class LXCoreInputViewUserSpecifications {

    static let shared = LXCoreInputViewUserSpecifications()

//    var hostName: String = ""
//    var version: String = ""
//
//    var textFieldTextColor
    var textFieldTextColorByInputViewState = [LXCoreInputView.InputViewState: UIColor]()
    var mainInputViewBorderColorByInputViewState = [LXCoreInputView.InputViewState: UIColor]()
    var hintLabelTextColorByInputViewState = [LXCoreInputView.InputViewState: UIColor]()
    var textFieldPlaceholderColor: UIColor?
    
    var mainViewStyle: LXCoreViewStyle?
    var titleLabelStyle: LXCoreLabelStyle?
    var mainInputViewContainerStyle: LXCoreViewStyle?
    var areaCodeLabelStyle: LXCoreLabelStyle?
    var textFieldStyle: LXCoreTextFieldStyle?
    var hintLabelStyle: LXCoreLabelStyle?

//
    func setTextFieldTextColor(_ textColor: UIColor, forState: LXCoreInputView.InputViewState) {
        textFieldTextColorByInputViewState[forState] = textColor
    }

    func setMainInputViewBorderColor(_ borderColor: UIColor, forState: LXCoreInputView.InputViewState) {
        mainInputViewBorderColorByInputViewState[forState] = borderColor
    }

    func setHintLabelTextColor(_ textColor: UIColor, forState: LXCoreInputView.InputViewState) {
        hintLabelTextColorByInputViewState[forState] = textColor
    }

    var titleConstraints: LXCoreConstraints?
    var mainInputConstraints: LXCoreConstraints?
    var areaCodeConstraints: LXCoreConstraints?
    var textFieldConstraints: LXCoreConstraints?
    var hintConstraints: LXCoreConstraints?


}

public extension LXCoreInputView.InputViewState {

    var textFieldTextColorUserSpecifiedValue: UIColor? {
        get {
            let userSpecifiedStyles = LXCoreInputViewUserSpecifications.shared
            let color = userSpecifiedStyles.textFieldTextColorByInputViewState[self]
            return color
        }
    }

    var mainInputViewBorderColorUserSpecifiedValue: UIColor? {
        get {
            let userSpecifiedStyles = LXCoreInputViewUserSpecifications.shared
            let color = userSpecifiedStyles.mainInputViewBorderColorByInputViewState[self]
            return color
        }
    }

    var hintLabelTextColorUserSpecifiedValue: UIColor? {
        get {
            let userSpecifiedStyles = LXCoreInputViewUserSpecifications.shared
            let color = userSpecifiedStyles.hintLabelTextColorByInputViewState[self]
            return color
        }
    }
}
