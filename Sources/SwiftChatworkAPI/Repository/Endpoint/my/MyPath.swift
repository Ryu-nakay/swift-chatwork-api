//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/14.
//

import Foundation

public struct MyPath {
    public let status = Status()
    public let tasks = Tasks()
}

// Status
public extension MyPath {
    struct Status {
        private let endpointString = "https://api.chatwork.com/v2/my/status"
        
        public func get() async throws -> GetResponse {
            let url = URL(string: endpointString)!
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
        
        // Types
        public struct GetResponse: Decodable {
            public let unreadRoomNum: Int
            public let mentionRoomNum: Int
            public let mytaskRoomNum: Int
            public let unreadNum: Int
            public let mentionNum: Int
            public let mytaskNum: Int
            
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
public extension MyPath {
    struct Tasks {
        private let endpointString = "https://api.chatwork.com/v2/my/status"
        
        public func get() async throws -> GetResponse {
            let url = URL(string: endpointString)!
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
        
        // Types
        public struct GetResponse: Decodable {
            public let unreadRoomNum : Int
            public let mentionRoomNum : Int
            public let mytaskRoomNum : Int
            public let unreadNum : Int
            public let mentionNum : Int
            public let mytaskNum : Int
            
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
