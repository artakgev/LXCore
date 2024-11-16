//
//  LXCodableExtension.swift
//  LXCore
//
//  Created by Rafayel Aghayan on 23.10.23.
//

import Foundation

typealias SnakeCaseCodable = Codable & SnakeCaseStrategable

extension CodingUserInfoKey {
    static let decoderRootKey = CodingUserInfoKey(rawValue: "decoderRootKey")!
    static let encoderRootKey = CodingUserInfoKey(rawValue: "encoderRootKey")!
    static let asCollection = CodingUserInfoKey(rawValue: "asCollection")!
}
