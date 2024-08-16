//
//  DogImage.swift
//  DogImageLibrary
//
//  Created by Bhawanisingh Rao on 15/08/24.
//

import Foundation

enum StringOrArray: Codable {
    case string(String)
    case array([String])
    
    // Decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else if let arrayValue = try? container.decode([String].self) {
            self = .array(arrayValue)
        } else {
            let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected String or Array of Strings")
            throw DecodingError.typeMismatch(StringOrArray.self, context)
        }
    }
    
    // Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .string(let stringValue):
            try container.encode(stringValue)
        case .array(let arrayValue):
            try container.encode(arrayValue)
        }
    }
}

extension StringOrArray {
    var asString: String? {
        if case .string(let value) = self {
            return value
        }
        return nil
    }
    
    var asArray: [String]? {
        if case .array(let value) = self {
            return value
        }
        return nil
    }
}

struct DogImage: Codable {
    let message: StringOrArray
    let status: String
}

