//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/14.
//

import Foundation

struct StatusPath {
    private func endpointString(roomId: Int, taskId: Int) -> String {
        return "https://api.chatwork.com/v2/rooms/\(roomId)/tasks/\(taskId)/status"
    }
    
    func put(token: APIToken, roomId: Int, taskId: Int, status: TaskType.Status) async throws -> PutResponse {
        let url = URL(string: endpointString(roomId: roomId, taskId: taskId))!
        var request = generateRequest(url: url, method: .put, token: token)
        
        let postData = NSMutableData(data: "body=\(status.rawValue)".data(using: .utf8)!)
        request.httpBody = postData as Data
        // リクエスト
        let (data, response) = try await URLSession.shared.data(for: request)
        let responseStatusCode = (response as! HTTPURLResponse).statusCode
        // 200以外は例外
        try throwNot200Or204StatusCode(responseStatusCode)
        // デコードする
        do {
            let decodeResult = try JSONDecoder().decode(PutResponse.self, from: data)
            return decodeResult
        } catch {
            throw APIError.failedToDecodeModel
        }
    }
}

extension StatusPath {
    struct PutResponse: Decodable {
        let taskId: String
        
        enum CodingKeys: String, CodingKey {
            case taskId = "task_id"
        }
    }
}
