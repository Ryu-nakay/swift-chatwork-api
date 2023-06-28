//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/11.
//

import Foundation

struct IncomingRequestsPath {
    private let endpointString = "https://api.chatwork.com/v2/incoming_requests"
    
    func get(token: APIToken) async throws -> GetResponse? {
        let url = URL(string: endpointString)!
        let request = generateRequest(url: url, method: .get, token: token)
        // リクエスト
        let (data, response) = try await URLSession.shared.data(for: request)
        let responseStatusCode = (response as! HTTPURLResponse).statusCode
        // 200か204以外は例外
        try throwNot200Or204StatusCode(responseStatusCode)
        
        // デコードする
        do {
            if responseStatusCode == 200 {
                let decodeResult = try JSONDecoder().decode([IncomingRequest].self, from: data)
                return GetResponse(body: decodeResult)
            }
            
            return nil
            
        } catch {
            throw APIError.failedToDecodeModel
        }
    }
}

// PUTとDELETE
extension IncomingRequestsPath {
    func put(token: APIToken, requestId: Int) async throws -> PutResponse {
        let url = URL(string: endpointString + "/\(requestId)")!
        let request = generateRequest(
            url: url,
            method: .put,
            token: token
        )
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
    
    func delete(token: APIToken, requestId: Int) async throws {
        let url = URL(string: endpointString + "\(requestId)")!
        let request = generateRequest(url: url, method: .delete, token: token)
        // リクエスト
        let (_, response) = try await URLSession.shared.data(for: request)
        let responseStatusCode = (response as! HTTPURLResponse).statusCode
        // 200以外は例外
        try throwNot200StatusCode(responseStatusCode)
    }
}
// Types
extension IncomingRequestsPath {
    struct GetResponse {
        let body: [IncomingRequest]
    }

    struct IncomingRequest: Decodable {
        let requestId: Int
        let accountId: Int
        let message: String
        let name: String
        let chatworkId: String
        let organizationId: Int
        let organizationName: String
        let department: String
        let avatarImageUrl: String
        
        enum CodingKeys: String, CodingKey {
            case requestId = "request_id"
            case accountId = "account_id"
            case message = "message"
            case name = "name"
            case chatworkId = "chatwork_id"
            case organizationId = "organization_id"
            case organizationName = "organization_name"
            case department = "department"
            case avatarImageUrl = "avatar_image_url"
        }
    }
    
    struct PutResponse: Decodable {
        let accountId: Int
        let roomId: Int
        let name: String
        let chatworkId: String
        let organizationId: Int
        let organizationName: String
        let department: String
        let avatarImageUrl: String
        
        enum CodingKeys: String, CodingKey {
            case accountId = "account_id"
            case roomId = "room_id"
            case name = "name"
            case chatworkId = "chatwork_id"
            case organizationId = "organization_id"
            case organizationName = "organization_name"
            case department = "department"
            case avatarImageUrl = "avatar_image_url"
        }
    }
}
