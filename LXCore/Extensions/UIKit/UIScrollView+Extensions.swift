//
//  UIScrollView+Extensions.swift
//  LXCore
//
//  Created by Artak Gevorgyan on 02/Jan/23.
//  Copyright © 2022 Artak Gevorgyan. All rights reserved.
//

import UIKit
// swiftlint:disable all
extension UIScrollView {
    func scrollToBottom(animated:Bool = true, completion: (() -> Void)? = nil) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        guard bottomOffset.y >= 0, bottomOffset.y != contentOffset.y else {
            completion?()
            return
        }
        UIView.animate(withDuration: animated ? 0.25 : 0, animations: {
            print("_______ scrolling to : ", bottomOffset)
            self.setContentOffset(bottomOffset, animated: animated)
        }) { (_) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                completion?()
            })
        }
    }
}

