//
//  Codable+Extended.swift
//  LXCore
//
//  Created by Artak Gevorgyan on 02/Jan/23.
//  Copyright © 2022 Artak Gevorgyan. All rights reserved.
//

import Foundation
// swiftlint:disable all
public protocol Strategable {
    static var decodingStrategy: JSONDecoder.KeyDecodingStrategy { get }
    static var encodingStrategy: JSONEncoder.KeyEncodingStrategy { get }
}

public protocol SnakeCaseStrategable: Strategable {}
public extension SnakeCaseStrategable {
    static var decodingStrategy: JSONDecoder.KeyDecodingStrategy {
        return .convertFromSnakeCase
    }

    static var encodingStrategy: JSONEncoder.KeyEncodingStrategy {
        return .convertToSnakeCase
    }
}

public extension Strategable where Self: Decodable {
    static var decodingStrategy: JSONDecoder.KeyDecodingStrategy {
        return .useDefaultKeys
    }
}

public extension Strategable where Self: Encodable {
    static var encodingStrategy: JSONEncoder.KeyEncodingStrategy {
        return .useDefaultKeys
    }
}

extension Array: Strategable where Element: Strategable {
    public static var decodingStrategy: JSONDecoder.KeyDecodingStrategy {
        return Element.decodingStrategy
    }

    public static var encodingStrategy: JSONEncoder.KeyEncodingStrategy {
        return Element.encodingStrategy
    }
}
