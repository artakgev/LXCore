//
//  LXCoreActivityIndicatorUserSpecifications.swift
//  Tiptop
//
//  Created by Artak Gevorgyan on 07.11.23.
//  Copyright © 2023 Artak Gevorgyan LLC. All rights reserved.
//
import UIKit

class LXCoreActivityIndicatorUserSpecifications {
    
    fileprivate struct DefaultStyles {
        fileprivate static var startColor = UIColor.red.withAlphaComponent(1)
        fileprivate static var endColor = UIColor.yellow.withAlphaComponent(0)
        fileprivate static var backgroundColor = UIColor.yellow.withAlphaComponent(0)
    }

    static let shared = LXCoreActivityIndicatorUserSpecifications()
    
    var startColor: UIColor = DefaultStyles.startColor
    var endColor: UIColor = DefaultStyles.endColor
    var backgroundColor: UIColor = DefaultStyles.backgroundColor
    var isNeedBlurredBackground: Bool = false

}
