//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/14.
//

import Foundation

struct TasksIdPath {
    private func endpointString(roomId: Int, taskId: Int) -> String {
        return "https://api.chatwork.com/v2/rooms/\(roomId)/tasks/\(taskId)"
    }
    
    func get(token: APIToken, roomId: Int, taskId: Int) async throws -> GetResponse {
        let url = URL(string: endpointString(roomId: roomId, taskId: taskId))!
        let request = generateRequest(url: url, method: .get, token: token)
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
}

extension TasksIdPath {
    struct GetResponse {
        let taskId: Int
        let account: ChatworkAPI.Account
        let assignedByAccount: ChatworkAPI.Account
        let messageId: String
        let body: String
        let limitTime: Int
        let status: TaskType.Status
        let limitType: TaskType.LimitType
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
                status: TaskType.Status(rawValue: self.status)!,
                limitType: TaskType.LimitType(rawValue: self.limitType)!
            )
        }
    }
}
