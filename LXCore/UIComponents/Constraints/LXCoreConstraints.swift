//
//  LXIOSCoreBaseRepository.swift
//  LXCore
//
//  Created by Artak Gevorgyan on 25.06.23.
//

import Foundation
import UIKit

struct LXCoreConstraints {
    var top: CGFloat?
    var left: CGFloat?
    var right: CGFloat?
    var bottom: CGFloat?
    var width: CGFloat?
    var height: CGFloat?

    init(top: CGFloat? = nil,
         left: CGFloat? = nil,
         right: CGFloat? = nil,
         bottom: CGFloat? = nil,
         width: CGFloat? = nil,
         height: CGFloat? = nil) {
        self.top = top
        self.left = left
        self.right = right
        self.bottom = bottom
        self.width = width
        self.height = height
    }
}
