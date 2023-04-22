//
//  UIDevice+Extensions.swift
//  LXCore
//
//  Created by Artak Gevorgyan on 02/Jan/23.
//  Copyright © 2022 Artak Gevorgyan. All rights reserved.
//

import Foundation
import UIKit
// swiftlint:disable all
extension UIDevice {
    var hasNotch: Bool {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let bottom = keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
    
    var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var isIPhone4Or5: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.bounds.size.width == 320
    }
    
    var udid: String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }

}

