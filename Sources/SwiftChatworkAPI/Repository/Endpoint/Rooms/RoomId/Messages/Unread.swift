//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/14.
//

import Foundation

extension Rooms.RoomId.Messages {
    struct Unread {
        private func endpointString(roomId: Int) -> String {
            return "https://api.chatwork.com/v2/rooms/\(roomId)/messages/unread"
        }
        
        func put(token: APIToken, roomId: Int, formData: FormData) async throws -> PutResponse {
            let url = URL(string: endpointString(roomId: roomId))!
            var request = generateRequest(url: url, method: .put, token: token)
            let postData = NSMutableData(data: "message_id=\(formData.messageId)".data(using: .utf8)!)
            
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
        
        struct PutResponse: Decodable {
            let unreadNum: Int
            let mentionNum: Int
        }
        
        struct FormData {
            let messageId: String
        }
    }
}
