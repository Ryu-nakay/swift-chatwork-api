//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/14.
//

import Foundation

extension Rooms.RoomId {
    struct Messages {
        private func endpointString(roomId: Int) -> String {
            return "https://api.chatwork.com/v2/rooms/\(roomId)/messages"
        }
        
        func get(token: APIToken, roomId: Int, force: Force = .force0) async throws -> GetResponse? {
            let url = URL(string: endpointString(roomId: roomId) + "?force=\(force.rawValue)")!
            let request = generateRequest(url: url, method: .get, token: token)
            // リクエスト
            let (data, response) = try await URLSession.shared.data(for: request)
            let responseStatusCode = (response as! HTTPURLResponse).statusCode
            // 200以外は例外
            try throwNot200Or204StatusCode(responseStatusCode)
            // デコードする
            do {
                if responseStatusCode == 204 {
                    return nil
                }
                
                let decodeResult = try JSONDecoder().decode(GetResponse.self, from: data)
                return decodeResult
                
            } catch {
                throw APIError.failedToDecodeModel
            }
        }
        
        func post(token: APIToken, roomId: Int, formData: FormData) async throws -> PostResponse {
            let url = URL(string: endpointString(roomId: roomId))!
            var request = generateRequest(url: url, method: .post, token: token)
            
            let postData = NSMutableData(data: "body=\(formData.body)".data(using: .utf8)!)
            postData.append("&self_unread=\(formData.selfUnread.rawValue)".data(using: .utf8)!)
            
            request.httpBody = postData as Data
            
            let (data, response) = try await URLSession.shared.data(for: request)
            let responseStatusCode = (response as! HTTPURLResponse).statusCode
            // 200以外は例外
            try throwNot200StatusCode(responseStatusCode)
            
            // デコードする
            do {
                let decodeResult = try JSONDecoder().decode(PostResponse.self, from: data)
                return decodeResult
            } catch {
                throw APIError.failedToDecodeModel
            }
        }
    }
}

extension Rooms.RoomId.Messages {
    enum Force: Int {
        case force0 = 0
        case force1 = 1
    }
    
    struct GetResponse: Decodable {
        let messageId: String
        let account: Account
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
    
    struct Account: Decodable {
        let accountId: Int
        let name: String
        let avatarImageUrl: String
        
        enum CodingKeys: String, CodingKey {
            case accountId = "account_id"
            case name = "name"
            case avatarImageUrl = "avatar_image_url"
        }
    }
    
    struct FormData {
        let body: Int
        let selfUnread: SelfUnread
    }
    
    enum SelfUnread: Int {
        case read = 0
        case unread = 1
    }
    
    struct PostResponse: Decodable {
        let messageId: String
        
        enum CodingKeys: String, CodingKey {
            case messageId = "message_id"
        }
    }
}