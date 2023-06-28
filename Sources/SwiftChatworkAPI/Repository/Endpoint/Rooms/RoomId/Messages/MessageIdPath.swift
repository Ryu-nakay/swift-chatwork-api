//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/14.
//

import Foundation

struct MessageIdPath {
    private func endpointString(roomId: Int, messageId: String) -> String {
        return "https://api.chatwork.com/v2/rooms/\(roomId)/messages/\(messageId)"
    }
    
    func get(token: APIToken, roomId: Int, messageId: String) async throws -> GetResponse {
        let url = URL(string: endpointString(roomId: roomId, messageId: messageId))!
        let request = generateRequest(url: url, method: .get, token: token)
        // リクエスト
        let (data, response) = try await URLSession.shared.data(for: request)
        let responseStatusCode = (response as! HTTPURLResponse).statusCode
        // 200以外は例外
        try throwNot200StatusCode(responseStatusCode)
        // デコードする
        do {
            let decodeResult = try JSONDecoder().decode(GetResponse.self, from: data)
            return decodeResult
        } catch {
            throw APIError.failedToDecodeModel
        }
    }
    
    func put(token: APIToken, roomId: Int, messageId: String, formData: FormData) async throws -> PutResponse {
        let url = URL(string: endpointString(roomId: roomId, messageId: messageId))!
        var request = generateRequest(url: url, method: .put, token: token)
        let postData = NSMutableData(data: "body=\(formData.body)".data(using: .utf8)!)
        
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
    
    func delete(token: APIToken, roomId: Int, messageId: String) async throws -> DeleteResponse {
        let url = URL(string: endpointString(roomId: roomId, messageId: messageId))!
        let request = generateRequest(url: url, method: .delete, token: token)
        // リクエスト
        let (data, response) = try await URLSession.shared.data(for: request)
        let responseStatusCode = (response as! HTTPURLResponse).statusCode
        // 200以外は例外
        try throwNot200StatusCode(responseStatusCode)
        // デコードする
        do {
            let decodeResult = try JSONDecoder().decode(DeleteResponse.self, from: data)
            return decodeResult
        } catch {
            throw APIError.failedToDecodeModel
        }
    }
}


// Types
extension MessageIdPath {
    struct GetResponse: Decodable {
        let messageId: String
        let account: ChatworkAPI.Account
        let body: String
        let sendTime: Int
        let updateTime: Int
        
        enum CodingKeys: String, CodingKey {
            case messageId = "message_id"
            case account = "account"
            case body = "body"
            case sendTime = "send_time"
            case updateTime = "update_time"
        }
    }
    
    struct PutResponse: Decodable {
        let messageId: String
        
        enum CodingKeys: String, CodingKey {
            case messageId = "message_id"
        }
    }
    
    struct FormData {
        let body: String
    }
    
    struct DeleteResponse: Decodable {
        let messageId: String
        
        enum CodingKeys: String, CodingKey {
            case messageId = "message_id"
        }
    }
}
