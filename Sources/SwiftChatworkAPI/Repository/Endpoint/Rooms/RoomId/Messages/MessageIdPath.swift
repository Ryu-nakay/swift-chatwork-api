//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/14.
//

import Foundation

public struct MessageIdPath {
    private func endpointString(roomId: Int, messageId: String) -> String {
        return "https://api.chatwork.com/v2/rooms/\(roomId)/messages/\(messageId)"
    }
    
    public func get(roomId: Int, messageId: String) async throws -> GetResponse {
        let url = URL(string: endpointString(roomId: roomId, messageId: messageId))!
        let token = try TokenStore.shared.getToken()
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
    
    public func put(roomId: Int, messageId: String, formData: FormData) async throws -> PutResponse {
        let url = URL(string: endpointString(roomId: roomId, messageId: messageId))!
        let token = try TokenStore.shared.getToken()
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
    
    public func delete(roomId: Int, messageId: String) async throws -> DeleteResponse {
        let url = URL(string: endpointString(roomId: roomId, messageId: messageId))!
        let token = try TokenStore.shared.getToken()
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
    public struct GetResponse: Decodable {
        public let messageId: String
        public let account: ChatworkAPI.Account
        public let body: String
        public let sendTime: Int
        public let updateTime: Int
        
        enum CodingKeys: String, CodingKey {
            case messageId = "message_id"
            case account = "account"
            case body = "body"
            case sendTime = "send_time"
            case updateTime = "update_time"
        }
    }
    
    public struct PutResponse: Decodable {
        public let messageId: String
        
        enum CodingKeys: String, CodingKey {
            case messageId = "message_id"
        }
    }
    
    public struct FormData {
        public let body: String
    }
    
    public struct DeleteResponse: Decodable {
        public let messageId: String
        
        enum CodingKeys: String, CodingKey {
            case messageId = "message_id"
        }
    }
}
