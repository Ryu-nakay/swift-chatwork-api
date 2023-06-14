//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/11.
//

import Foundation

struct MyStatusRepository {
    private let endpointString = "https://api.chatwork.com/v2/my/status"
    
    func get(token: APIToken) async throws -> MyStatusGetResponse {
        let url = URL(string: endpointString)!
        var request = generateRequest(url: url, method: .get, token: token)
        
        // リクエスト
        let (data, response) = try await URLSession.shared.data(for: request)
        
        let responseStatusCode = (response as! HTTPURLResponse).statusCode
        // 200以外は例外
        try throwNot200StatusCode(responseStatusCode)
        
        // デコードする
        do {
            let decodeResult = try JSONDecoder().decode(MyStatusGetResponse.self, from: data)
            return decodeResult
        } catch {
            throw APIError.failedToDecodeModel
        }
    }
}
