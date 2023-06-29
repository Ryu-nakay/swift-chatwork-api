//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/11.
//

import Foundation

public struct RoomIdPath {
    public let members = MembersPath()
    public let messages = MessagesPath()
    public let tasks = TasksPath()
    
    private let endpointString = "https://api.chatwork.com/v2/rooms"
    
    public func get(roomId: Int) async throws -> GetResponse {
        let url = URL(string: endpointString + "/\(roomId)")!
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
    
    public func put(roomId: Int, formData: PutFormData) async throws -> Int {
        let url = URL(string: endpointString + "/\(roomId)")!
        let token = try TokenStore.shared.getToken()
        let request = generateRequest(url: url, method: .put, token: token)
        // リクエスト
        let (data, response) = try await URLSession.shared.data(for: request)
        let responseStatusCode = (response as! HTTPURLResponse).statusCode
        // 200以外は例外
        try throwNot200StatusCode(responseStatusCode)
        // デコードする
        do {
            let decodeResult = try JSONDecoder().decode(PutResponse.self, from: data)
            return decodeResult.roomId
            
        } catch {
            throw APIError.failedToDecodeModel
        }
    }

    public func delete(roomId: Int, actionType: DeleteActionType) async throws {
        let url = URL(string: endpointString + "/\(roomId)")!
        let token = try TokenStore.shared.getToken()
        let request = generateRequest(url: url, method: .delete, token: token)
        // リクエスト
        let (_, response) = try await URLSession.shared.data(for: request)
        let responseStatusCode = (response as! HTTPURLResponse).statusCode
        // 204以外は例外
        try throwNot204StatusCode(responseStatusCode)
    }
}

// Types
extension RoomIdPath {
    public struct GetResponse: Decodable {
        let roomId: Int
        let name: String
        let type: String
        let role: String
        let sticky: Bool
        let unreadNum: Int
        let mentionNum: Int
        let mytaskNum: Int
        let messageNum: Int
        let fileNum: Int
        let taskNum: Int
        let iconPath: String
        let lastUpdateTime: Int
        let description: String
        
        enum CodingKeys: String, CodingKey {
            case roomId = "room_id"
            case name = "name"
            case type = "type"
            case role = "role"
            case sticky = "sticky"
            case unreadNum = "unread_num"
            case mentionNum = "mention_num"
            case mytaskNum = "mytask_num"
            case messageNum = "message_num"
            case fileNum = "file_num"
            case taskNum = "task_num"
            case iconPath = "icon_path"
            case lastUpdateTime = "last_update_time"
            case description = "description"
        }
    }

    public struct PutFormData {
        let name: String
        let description: String
        let iconPreset: ChatworkAPI.IconPreset
    }

    public struct PutResponse: Decodable {
        let roomId: Int
        
        enum CodingKeys: String, CodingKey {
            case roomId = "room_id"
        }
    }

    public enum DeleteActionType: String {
        case leave = "leave"
        case delete = "delete"
    }
}
