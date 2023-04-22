//
//  UILabel+Extensions.swift
//  LXCore
//
//  Created by Artak Gevorgyan on 02/Jan/23.
//  Copyright © 2022 Artak Gevorgyan. All rights reserved.
//

import Foundation
import UIKit
// swiftlint:disable all
extension UILabel {
        
    func setLineHeightMultiple(_ multiple: CGFloat = 1.23) {
        guard let text = self.text else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = multiple
        let attributeString = NSMutableAttributedString(string: text,
                                                        attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        self.attributedText = attributeString        
    }
	
    func setLineSpacing(_ spacing: CGFloat) {
		let text = self.text
		if let text = text {
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.lineSpacing = spacing
			let attributeString = NSMutableAttributedString(string: text,
																  attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
			self.attributedText = attributeString
		}
	}

}
