//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/14.
//

import Foundation

struct MyPath {
    public let status = Status()
    public let tasks = Tasks()
}

// Status
extension MyPath {
    struct Status {
        private let endpointString = "https://api.chatwork.com/v2/my/status"
        
        func get(token: APIToken) async throws -> GetResponse {
            let url = URL(string: endpointString)!
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
        
        // Types
        struct GetResponse: Decodable {
            let unreadRoomNum: Int
            let mentionRoomNum: Int
            let mytaskRoomNum: Int
            let unreadNum: Int
            let mentionNum: Int
            let mytaskNum: Int
            
            enum CodingKeys: String, CodingKey {
                case unreadRoomNum = "unread_room_num"
                case mentionRoomNum = "mention_room_num"
                case mytaskRoomNum = "mytask_room_num"
                case unreadNum = "unread_num"
                case mentionNum = "mention_num"
                case mytaskNum = "mytask_num"
            }
        }
    }
}

// Tasks
extension MyPath {
    struct Tasks {
        private let endpointString = "https://api.chatwork.com/v2/my/status"
        
        func get(token: APIToken) async throws -> GetResponse {
            let url = URL(string: endpointString)!
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
        
        // Types
        struct GetResponse: Decodable {
            let unreadRoomNum : Int
            let mentionRoomNum : Int
            let mytaskRoomNum : Int
            let unreadNum : Int
            let mentionNum : Int
            let mytaskNum : Int
            
            enum CodingKeys: String, CodingKey {
                case unreadRoomNum = "unread_room_num"
                case mentionRoomNum = "mention_room_num"
                case mytaskRoomNum = "mytask_room_num"
                case unreadNum = "unread_num"
                case mentionNum = "mention_num"
                case mytaskNum = "mytask_num"
            }
        }
    }
}
