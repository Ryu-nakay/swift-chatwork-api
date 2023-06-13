//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/11.
//

import Foundation

struct MyTasksRepository {
    private let endpointString = "https://api.chatwork.com/v2/my/status"
    
    func get(token: APIToken) async throws -> MyTasksGetResponse {
        let url = URL(string: endpointString)!
        var request = URLRequest(url: url)
        
        request.httpMethod = HTTPMethod.get.rawValue
        
        // 検討: 他Repositoryでも共通な気がするから切り出し候補
        let headers = [
          "accept": "application/json",
          "x-chatworktoken": token.value
        ]
        request.allHTTPHeaderFields = headers
        
        // リクエスト
        let (data, response) = try await URLSession.shared.data(for: request)
        
        let responseStatusCode = (response as! HTTPURLResponse).statusCode
        
        // 200以外は早期リターン
        if responseStatusCode != 200 {
            throw APIError.statusCodeIsUnexpected(statusCode: responseStatusCode)
        }
        
        // デコードする
        do {
            let decodeResult = try JSONDecoder().decode(MyTasksGetResponse.self, from: data)
            return decodeResult
        } catch {
            throw APIError.failedToDecodeModel
        }
    }
}
