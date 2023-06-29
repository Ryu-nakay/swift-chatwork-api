//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/10.
//

import Foundation

public struct APIToken {
    public let value: String
    
    public init(value: String) throws {
        if isSingleByteAlphanumericCharacters(value: value) == false {
            throw APITokenError.invalidValue
        }
        
        self.value = value
        
        func isSingleByteAlphanumericCharacters(value: String) -> Bool {
            value.range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil && !value.isEmpty
        }
    }
}

public enum APITokenError: Error {
    case invalidValue
}
