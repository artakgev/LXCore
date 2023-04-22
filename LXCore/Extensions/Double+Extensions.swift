//
//  Double+Extensions.swift
//  LXCore
//
//  Created by Artak Gevorgyan on 02/Jan/23.
//  Copyright © 2022 Artak Gevorgyan. All rights reserved.
//

import Foundation
// swiftlint:disable all

extension Double {
    func toIntegralString() -> String {
        return String(format: "%.10f", self).components(separatedBy: ".").first ?? "0"
    }

    func toIntegralString2() -> String {
        return String(format: "%.10f", self).components(separatedBy: ".").first ?? "0"
    }

}
