//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/14.
//

import Foundation

extension Rooms.RoomId {
    struct Tasks {
        private func endpointString(roomId: Int) -> String {
            return "https://api.chatwork.com/v2/rooms/\(roomId)/tasks"
        }
        
        func get(token: APIToken, roomId: Int, queryParams: QueryParams) async throws -> GetResponse {
            let url = URL(string: endpointString(roomId: roomId))!
            let request = generateRequest(url: url, method: .get, token: token)
            
            let postData = NSMutableData(data: "account_id=\(queryParams.accountId)".data(using: .utf8)!)
            postData.append("&assigned_by_account_id=\(queryParams.assignedByAccountId)".data(using: .utf8)!)
            postData.append("&status=\(queryParams.status.rawValue)".data(using: .utf8)!)
            // リクエスト
            let (data, response) = try await URLSession.shared.data(for: request)
            let responseStatusCode = (response as! HTTPURLResponse).statusCode
            // 200以外は例外
            try throwNot200Or204StatusCode(responseStatusCode)
            // デコードする
            do {
                let decodeResult = try JSONDecoder().decode(DecodableGetResponse.self, from: data)
                return decodeResult.conversionToGetResponse()
            } catch {
                throw APIError.failedToDecodeModel
            }
        }
        
        func post(token: APIToken, roomId: Int, formData: FormData) async throws -> PostResponse {
            let url = URL(string: endpointString(roomId: roomId))!
            var request = generateRequest(url: url, method: .post, token: token)
            
            let postData = NSMutableData(data: "body=\(formData.body)".data(using: .utf8)!)
            postData.append("&to_ids=\(formData.toIds)".data(using: .utf8)!)
            postData.append("&limit=\(formData.limit)".data(using: .utf8)!)
            postData.append("&limit_type=\(formData.limitType.rawValue)".data(using: .utf8)!)
            
            request.httpBody = postData as Data
            
            // リクエスト
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

extension Rooms.RoomId.Tasks {
    struct GetResponse {
        let taskId: Int
        let account: ChatworkAPI.Account
        let assignedByAccount: ChatworkAPI.Account
        let messageId: String
        let body: String
        let limitTime: Int
        let status: Status
        let limitType: LimitType
    }
    
    enum Status: String {
        case open = "open"
        case done = "done"
    }
    
    enum LimitType: String {
        case none = "none"
        case date = "date"
        case time = "time"
    }
    
    struct DecodableGetResponse: Decodable {
        let taskId: Int
        let account: ChatworkAPI.Account
        let assignedByAccount: ChatworkAPI.Account
        let messageId: String
        let body: String
        let limitTime: Int
        let status: String
        let limitType: String
        
        enum CodingKeys: String, CodingKey {
            case taskId = "task_id"
            case account = "account"
            case assignedByAccount = "assigned_by_account"
            case messageId = "message_id"
            case body = "body"
            case limitTime = "limit_time"
            case status = "status"
            case limitType = "limit_type"
        }
        
        func conversionToGetResponse() -> GetResponse {
            return GetResponse(
                taskId: self.taskId,
                account: self.account,
                assignedByAccount: self.assignedByAccount,
                messageId: self.messageId,
                body: self.body,
                limitTime: self.limitTime,
                status: Rooms.RoomId.Tasks.Status(rawValue: self.status)!,
                limitType: Rooms.RoomId.Tasks.LimitType(rawValue: self.limitType)!
            )
        }
    }
    
    struct QueryParams {
        let accountId: Int
        let assignedByAccountId: Int
        let status: Status
    }
    
    struct FormData {
        let body: String
        let toIds: String
        // Unix時間
        let limit: Int
        let limitType: LimitType
    }
    
    struct PostResponse: Decodable {
        let taskIds: [Int]
        
        enum CodingKeys: String, CodingKey {
            case taskIds = "task_ids"
        }
    }
}
