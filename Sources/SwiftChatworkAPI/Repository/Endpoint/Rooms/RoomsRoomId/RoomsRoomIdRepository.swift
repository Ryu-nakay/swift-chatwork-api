//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/11.
//

import Foundation

struct RoomsRoomIdRepository {
    private let endpointString = "https://api.chatwork.com/v2/rooms"
    
    func get(token: APIToken, roomId: Int) async throws -> RoomsRoomIdGetResponse {
        let url = URL(string: endpointString + "/\(roomId)")!
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
            throw APIError.statusCodeIsNot200(statusCode: responseStatusCode)
        }
        
        // デコードする
        do {
            let decodeResult = try JSONDecoder().decode(RoomsRoomIdGetResponse.self, from: data)
            return decodeResult
            
        } catch {
            throw APIError.failedToDecodeModel
        }
    }
    
    func put(token: APIToken, roomId: Int, formData: RoomsRoomIdPutFormData) async throws -> Int {
        let url = URL(string: endpointString + "/\(roomId)")!
        var request = URLRequest(url: url)
        
        request.httpMethod = HTTPMethod.put.rawValue
        
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
            throw APIError.statusCodeIsNot200(statusCode: responseStatusCode)
        }
        
        // デコードする
        do {
            let decodeResult = try JSONDecoder().decode(RoomsRoomIdPutResponse.self, from: data)
            return decodeResult.roomId
            
        } catch {
            throw APIError.failedToDecodeModel
        }
    }
//
//    func delete(token: APIToken, roomId: Int, actionType: RoomsRoomIdDeleteActionType) async throws {
//
//    }
}

struct RoomsRoomIdGetResponse: Decodable {
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

struct RoomsRoomIdPutFormData {
    let name: String
    let description: String
    let iconPreset: IconPreset
}

struct RoomsRoomIdPutResponse: Decodable {
    let roomId: Int
    
    enum CodingKeys: String, CodingKey {
        case roomId = "room_id"
    }
}