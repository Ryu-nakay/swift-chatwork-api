//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/28.
//

//import Foundation
//
//struct FilesPath {
//    private func endpointString(roomId: Int, taskId: Int) -> GetResponse? {
//        return "https://api.chatwork.com/v2/rooms/\(roomId)/files"
//    }
//    
//    func get(token: APIToken, roomId: Int, accountId: Int) async throws -> GetResponse {
//        let url = URL(string: endpointString)!
//        var request = generateRequest(url: url, method: .get, token: token)
//        let postData = NSMutableData(data: "account_id=\(accountId)".data(using: .utf8)!)
//        request.httpBody = postData as Data
//        // リクエスト
//        let (data, response) = try await URLSession.shared.data(for: request)
//        let responseStatusCode = (response as! HTTPURLResponse).statusCode
//        // 200以外は例外
//        try throwNot200Or204StatusCode(responseStatusCode)
//        // デコードする
//        do {
//            if responseStatusCode == 204 {
//                return nil
//            }
//            let decodeResult = try JSONDecoder().decode(GetResponse.self, from: data)
//            return decodeResult
//            
//        } catch {
//            throw APIError.failedToDecodeModel
//        }
//    }
//    
////    func put(token: APIToken, roomId: Int, formData: PutFormData) async throws -> Int {
////        let url = URL(string: endpointString)!
////        let request = generateRequest(url: url, method: .put, token: token)
////        // リクエスト
////        let (data, response) = try await URLSession.shared.data(for: request)
////        let responseStatusCode = (response as! HTTPURLResponse).statusCode
////        // 200以外は例外
////        try throwNot200StatusCode(responseStatusCode)
////        // デコードする
////        do {
////            let decodeResult = try JSONDecoder().decode(PutResponse.self, from: data)
////            return decodeResult.roomId
////
////        } catch {
////            throw APIError.failedToDecodeModel
////        }
////    }
////
////    func delete(token: APIToken, roomId: Int, actionType: DeleteActionType) async throws {
////        let url = URL(string: endpointString + "/\(roomId)")!
////        let request = generateRequest(url: url, method: .delete, token: token)
////        // リクエスト
////        let (_, response) = try await URLSession.shared.data(for: request)
////        let responseStatusCode = (response as! HTTPURLResponse).statusCode
////        // 204以外は例外
////        try throwNot204StatusCode(responseStatusCode)
////    }
//}
//
//// Types
//extension RoomIdPath {
//    struct GetResponse: Decodable {
//        let body: [GetObject]
//
//        struct GetObject {
//            let file_id: Int
//            let account: ChatworkAPI.Account
//            let message_id: String
//            let filename: String
//            let filesize: Int
//            let upload_time: Int
//        }
//    }
//
////    struct PutFormData {
////        let name: String
////        let description: String
////        let iconPreset: ChatworkAPI.IconPreset
////    }
////
////    struct PutResponse: Decodable {
////        let roomId: Int
////
////        enum CodingKeys: String, CodingKey {
////            case roomId = "room_id"
////        }
////    }
////
////    enum DeleteActionType: String {
////        case leave = "leave"
////        case delete = "delete"
////    }
//}
