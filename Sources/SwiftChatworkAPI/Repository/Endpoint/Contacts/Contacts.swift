//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/11.
//

import Foundation

struct Contacts {
    private let endpointString = "https://api.chatwork.com/v2/contacts"
    
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
extension Contacts {
    struct GetResponse: Decodable {
        let body: [Contact]
        
        struct Contact: Decodable {
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
}
