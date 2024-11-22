//
//  LXCodableService.swift
//  LXCore
//
//  Created by Artak Gevorgyan on 23.10.23.
//

import Foundation

class LXCodableService {

    func decodeObjects<T>(of type: T.Type, data: Data, key: String? = nil) throws -> Array<T> where T: Decodable {
        let decoder = JSONDecoder()
        if let strategable = T.self as? Strategable.Type {
            decoder.keyDecodingStrategy = strategable.decodingStrategy
        }
        guard let key = key else {
            return try decoder.decode(Array<T>.self, from: data)
        }
        decoder.userInfo[.decoderRootKey] = key
        decoder.userInfo[.asCollection] = true
        
        return try decoder.decode(DecodableRoot<T>.self, from: data).values
    }
    
    func decodeObject<T>(of type: T.Type, data: Data, key: String? = nil) throws -> T? where T: Decodable {
        let decoder = JSONDecoder()
        if let strategable = T.self as? Strategable.Type {
            decoder.keyDecodingStrategy = strategable.decodingStrategy
        }
        guard let key = key else {
            return try decoder.decode(T.self, from: data)
        }
        decoder.userInfo[.decoderRootKey] = key
        return try decoder.decode(DecodableRoot<T>.self, from: data).value
    }
    
    func encode<T>(_ objects: [T], key: String? = nil) throws -> Data where T: Encodable {
        let encoder = JSONEncoder()
        guard let key = key else {
            return try encoder.encode(objects)
        }
        encoder.userInfo[.encoderRootKey] = key
        encoder.userInfo[.asCollection] = true
        return try encoder.encode(EncodableRoot(objects))
    }
    
    private class DecodableRoot<T>: Decodable where T: Decodable {
        
        var value: T?
        var values = [T]()
        
        private struct CodingKeys: CodingKey {
            var stringValue: String
            var intValue: Int?
            init?(stringValue: String) {
                self.stringValue = stringValue
            }
            init?(intValue: Int) {
                self.intValue = intValue
                stringValue = "\(intValue)"
            }
            static func key(named name: String) -> CodingKeys? {
                return CodingKeys(stringValue: name)
            }
        }
        
        init() {}
        
        required convenience init(from decoder: Decoder) throws {
            self.init()
            let container = try decoder.container(keyedBy: CodingKeys.self)
            guard let keyName = decoder.userInfo[.decoderRootKey] as? String, 
                    let key = CodingKeys.key(named: keyName) else {
                throw DecodingError.valueNotFound(T.self,
                                                  DecodingError.Context(codingPath: [],
                                                                        debugDescription: "Cannot find value/key at root level."))
            }
            if let _ = decoder.userInfo[.asCollection] {
                values = try container.decode(Array<T>.self, forKey: key)
                return
            }
            value = try container.decode(T.self, forKey: key)
        }
    }
    
    private class EncodableRoot<T>: Encodable where T: Encodable {
        
        let values: [T]
        
        private struct CodingKeys: CodingKey {
            var stringValue: String
            var intValue: Int?
            init?(stringValue: String) {
                self.stringValue = stringValue
            }
            init?(intValue: Int) {
                self.intValue = intValue
                stringValue = "\(intValue)"
            }
            static func key(named name: String) -> CodingKeys? {
                return CodingKeys(stringValue: name)
            }
        }
        
        init(_ objects: [T]) {
            values = objects
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            guard let keyName = encoder.userInfo[.encoderRootKey] as? String, let key = CodingKeys.key(named: keyName) else {
                throw DecodingError.valueNotFound(T.self, 
                                                  DecodingError.Context(codingPath: [],
                                                                        debugDescription: "Cannot find value/key at root level."))
            }
            if let _ = encoder.userInfo[.asCollection] {
                try container.encode(values, forKey: key)
                return
            }
            try container.encode(values.first!, forKey: key)
        }
    }
}
