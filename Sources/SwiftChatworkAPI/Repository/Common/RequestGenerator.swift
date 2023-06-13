//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/13.
//

import Foundation

// 基本的なリクエストを作成する
func generateRequest(url: URL, method: HTTPMethod, token: APIToken) -> URLRequest {
    var request = URLRequest(url: url)
    
    request.httpMethod = method.rawValue
    
    let headers = [
      "accept": "application/json",
      "x-chatworktoken": token.value
    ]
    request.allHTTPHeaderFields = headers
    
    return request
}
