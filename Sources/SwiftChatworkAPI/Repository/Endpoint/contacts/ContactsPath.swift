//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/11.
//

import Foundation

public struct ContactsPath {
    private let endpointString = "https://api.chatwork.com/v2/contacts"
    
    public func get() async throws -> GetResponse? {
        let url = URL(string: endpointString)!
        let token = try TokenStore.shared.getToken()
        let request = generateRequest(url: url, method: .get, token: token)
        // リクエスト
        let (data, response) = try await URLSession.shared.data(for: request)
        let responseStatusCode = (response as! HTTPURLResponse).statusCode
        // 200か204以外は例外
        try throwNot200Or204StatusCode(responseStatusCode)
        
        // デコードする
        return try getDecode(statusCode: responseStatusCode, data: data)
    }
}

// Private Methods
extension ContactsPath {
    private func getDecode(statusCode: Int, data: Data) throws -> GetResponse? {
        do {
            if statusCode == 200 {
                let decodeResult = try JSONDecoder().decode([GetResponse.Contact].self, from: data)
                return GetResponse(body: decodeResult)
            }
            return nil
            
        } catch {
            throw APIError.failedToDecodeModel
        }
    }
}

// Types
extension ContactsPath {
    public struct GetResponse: Decodable {
        public let body: [Contact]
        
        public struct Contact: Decodable {
            public let accountId: Int
            public let roomId: Int
            public let name: String
            public let chatworkId: String
            public let organizationId: Int
            public let organizationName: String
            public let department: String
            public let avatarImageUrl: String
            
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
}
