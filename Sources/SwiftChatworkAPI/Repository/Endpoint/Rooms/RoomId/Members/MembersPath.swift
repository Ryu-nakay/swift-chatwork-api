//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/14.
//

import Foundation

public struct MembersPath {
    private func endpointString(roomId: Int) -> String {
        return "https://api.chatwork.com/v2/rooms/\(roomId)/members"
    }
    
    public func get(roomId: Int) async throws -> GetResponse {
        let url = URL(string: endpointString(roomId: roomId))!
        let token = try TokenStore.shared.getToken()
        let request = generateRequest(url: url, method: .get, token: token)
        // リクエスト
        let (data, response) = try await URLSession.shared.data(for: request)
        let responseStatusCode = (response as! HTTPURLResponse).statusCode
        // 200以外は例外
        try throwNot200StatusCode(responseStatusCode)
        // デコードする
        do {
            let decodeResult = try JSONDecoder().decode([GetResponse.DecodableMember].self, from: data)
            return GetResponse(body: decodeResult.map({ decodeMember in
                decodeMember.conversionToMember()
            }))
            
        } catch {
            throw APIError.failedToDecodeModel
        }
    }
    
    public func put(roomId: Int, formData: PutFormData) async throws -> PutResponse {
        let url = URL(string: endpointString(roomId: roomId))!
        let token = try TokenStore.shared.getToken()
        var request = generateRequest(url: url, method: .put, token: token)
        let postData = NSMutableData(data: "members_admin_ids=\(formData.membersAdminIds)".data(using: .utf8)!)
        postData.append("&members_member_ids=\(formData.membersMemberIds ?? "")".data(using: .utf8)!)
        postData.append("&members_readonly_ids=\(formData.membersReadonlyIds ?? "")".data(using: .utf8)!)
        
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
}

// Types
extension MembersPath {
    public struct GetResponse {
        let body: [Member]
        
        struct Member {
            let accountId: Int
            let role: ChatworkAPI.Role
            let name: String
            let chatworkId: String
            let organizationId: Int
            let organizationName: String
            let department: String
            let avatarImageUrl: String
        }
        
        struct DecodableMember: Decodable {
            let accountId: Int
            let role: String
            let name: String
            let chatworkId: String
            let organizationId: Int
            let organizationName: String
            let department: String
            let avatarImageUrl: String
            
            enum CodingKeys: String, CodingKey {
                case accountId = "account_id"
                case role = "role"
                case name = "name"
                case chatworkId = "chatwork_id"
                case organizationId = "organization_id"
                case organizationName = "organization_name"
                case department = "department"
                case avatarImageUrl = "avatar_image_url"
            }
            
            func conversionToMember() -> Member {
                Member(
                    accountId: self.accountId,
                    role: ChatworkAPI.Role(rawValue: self.role)!,
                    name: self.name,
                    chatworkId: self.chatworkId,
                    organizationId: self.organizationId,
                    organizationName: self.organizationName,
                    department: self.department,
                    avatarImageUrl: self.avatarImageUrl
                )
            }
        }
    }
    
    public struct PutResponse: Decodable {
        let admin: [Int]
        let member: [Int]
        let readonly: [Int]
    }
    
    public struct PutFormData {
        let membersAdminIds: String
        let membersMemberIds: String?
        let membersReadonlyIds: String?
    }
}
