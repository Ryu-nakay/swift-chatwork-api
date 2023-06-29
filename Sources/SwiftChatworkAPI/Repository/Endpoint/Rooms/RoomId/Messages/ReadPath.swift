//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/14.
//

import Foundation

public struct ReadPath {
    private func endpointString(roomId: Int) -> String {
        return "https://api.chatwork.com/v2/rooms/\(roomId)/messages"
    }
    
    public func put(roomId: Int, formData: FormData) async throws -> PutResponse {
        let url = URL(string: endpointString(roomId: roomId))!
        let token = try TokenStore.shared.getToken()
        var request = generateRequest(url: url, method: .put, token: token)
        
        let postData = NSMutableData(data: "&body=\(formData.body)".data(using: .utf8)!)
        postData.append("&self_unread=\(formData.selfUnread.rawValue)".data(using: .utf8)!)
        
        request.httpBody = postData as Data
        
        // リクエスト
        let (data, response) = try await URLSession.shared.data(for: request)
        let responseStatusCode = (response as! HTTPURLResponse).statusCode
        // 200以外は例外
        try throwNot200StatusCode(responseStatusCode)
        // デコードする
        do {
            let decodeResult = try JSONDecoder().decode(PutResponse.self, from: data)
            return decodeResult
        } catch {
            throw APIError.failedToDecodeModel
        }
    }
    
    public struct FormData {
        let body: String
        let selfUnread: SelfUnread
    }
    
    public struct PutResponse: Decodable {
        let messageId: String
        
        enum CodingKeys: String, CodingKey {
            case messageId = "message_id"
        }
    }
}
