//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/10.
//

import Foundation

// /meへ問い合わせるリポジトリ
public struct MePath {
    private let endpointString = "https://api.chatwork.com/v2/me"
    
    public func get() async throws -> GetResponse {
        let url = URL(string: endpointString)!
        let token = try TokenStore.shared.getToken()
        let request = generateRequest(url: url, method: .get, token: token)
        // リクエスト
        let (data, response) = try await URLSession.shared.data(for: request)
        let responseStatusCode = (response as! HTTPURLResponse).statusCode
        // 200以外は例外
        try throwNot200StatusCode(responseStatusCode)
        // デコードする
        do {
            let decodeResult = try JSONDecoder().decode(GetResponse.self, from: data)
            return decodeResult
        } catch {
            throw APIError.failedToDecodeModel
        }
    }
}

// Types
public extension MePath {
    struct GetResponse: Decodable {
        public let accountId: Int
        public let roomId: Int
        public let name: String
        public let chatworkId: String
        public let organizationId: Int
        public let organizationName: String
        public let department: String
        public let title: String
        public let url: String
        public let introduction: String
        public let mail: String
        public let telOrganization: String
        public let telExtension: String
        public let telMobile: String
        public let skype: String
        public let facebook: String
        public let twitter: String
        public let avatarImageUrl: String
        public let loginMail: String
        
        enum CodingKeys: String, CodingKey {
            case accountId = "account_id"
            case roomId = "room_id"
            case name = "name"
            case chatworkId = "chatwork_id"
            case organizationId = "organization_id"
            case organizationName = "organization_name"
            case department = "department"
            case title = "title"
            case url = "url"
            case introduction = "introduction"
            case mail = "mail"
            case telOrganization = "tel_organization"
            case telExtension = "tel_extension"
            case telMobile = "tel_mobile"
            case skype = "skype"
            case facebook = "facebook"
            case twitter = "twitter"
            case avatarImageUrl = "avatar_image_url"
            case loginMail = "login_mail"
        }
    }
}

