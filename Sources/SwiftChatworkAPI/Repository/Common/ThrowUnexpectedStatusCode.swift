//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/13.
//

import Foundation

func throwUnexpectedStatusCode(expected: [Int]) -> (Int) throws -> () {
    return { statusCode in
        if expected.contains(statusCode) {
           return
        }
        
        throw APIError.statusCodeIsUnexpected(statusCode: statusCode)
    }
}

// カリー化(200番)
let throwNot200StatusCode = throwUnexpectedStatusCode(expected: [200])

// カリー化(204番)
let throwNot204StatusCode = throwUnexpectedStatusCode(expected: [204])

// カリー化(200番と204番)
let throwNot200Or204StatusCode = throwUnexpectedStatusCode(expected: [200, 204])
