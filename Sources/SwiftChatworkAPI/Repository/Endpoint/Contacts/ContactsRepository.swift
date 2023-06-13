//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/11.
//

import Foundation

struct ContactsRepository {
    private let endpointString = "https://api.chatwork.com/v2/contacts"
    
    func get(token: APIToken) async throws -> ContactsGetResponse? {
        let url = URL(string: endpointString)!
        var request = generateRequest(
            url: url,
            method: .get,
            token: token
        )
        
        // リクエスト
        let (data, response) = try await URLSession.shared.data(for: request)
        
        let responseStatusCode = (response as! HTTPURLResponse).statusCode
        
        // 200と204以外は早期リターン
        if responseStatusCode != 200 && responseStatusCode != 204 {
            throw APIError.statusCodeIsUnexpected(statusCode: responseStatusCode)
        }
        
        // デコードする
        do {
            if responseStatusCode == 200 {
                let decodeResult = try JSONDecoder().decode([Contact].self, from: data)
                return ContactsGetResponse(body: decodeResult)
            }
            
            return nil
            
        } catch {
            throw APIError.failedToDecodeModel
        }
    }
}
