//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/10.
//

import Foundation

struct RoomsRepository {
    let urlString = "https://api.chatwork.com/v2/rooms"
    
    func get(token: APIToken) async throws -> RoomsGetResponse {
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        request.httpMethod = HTTPMethod.get.rawValue
        
        let headers = [
            "accept": "application/json",
            "x-chatworktoken": token.value
        ]
        request.allHTTPHeaderFields = headers
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        let responseStatusCode = (response as! HTTPURLResponse).statusCode
        
        // 200以外は早期リターン
        if responseStatusCode != 200 {
            throw APIError.statusCodeIsNot200(statusCode: responseStatusCode)
        }
        
        // デコードする
        do {
            let decodeResult = try JSONDecoder().decode([Room].self, from: data)
            let roomListObject = RoomsGetResponse(body: decodeResult)
            return roomListObject
        } catch {
            throw APIError.failedToDecodeModel
        }
    }
}
