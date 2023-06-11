//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/11.
//

import Foundation

struct IncomingRequestsGetResponse {
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
