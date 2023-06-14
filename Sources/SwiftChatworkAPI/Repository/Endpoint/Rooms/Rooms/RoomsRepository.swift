//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/10.
//

import Foundation

struct RoomsRepository {
    let urlString = "https://api.chatwork.com/v2/rooms"
    
    func get(token: APIToken) async throws -> RoomsGetResponse {
        let url = URL(string: urlString)!
        var request = generateRequest(url: url, method: .get, token: token)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        let responseStatusCode = (response as! HTTPURLResponse).statusCode
        // 200以外は例外
        try throwNot200StatusCode(responseStatusCode)
        
        // デコードする
        do {
            let decodeResult = try JSONDecoder().decode([Room].self, from: data)
            let roomListObject = RoomsGetResponse(body: decodeResult)
            return roomListObject
        } catch {
            throw APIError.failedToDecodeModel
        }
    }
    
    func post(token: APIToken, formData: RoomsRepositoryPostFormData) async throws -> Int {
        let url = URL(string: urlString)!
        var request = generateRequest(
            url: url,
            method: .post,
            token: token
        )
        
        let postData = NSMutableData(data: "name=\(formData.name)".data(using: .utf8)!)
        
        postData.append("&description=\(formData.description)".data(using: .utf8)!)
        postData.append("&link=\(formData.link)".data(using: .utf8)!)
        if let _ = formData.linkCode {
            postData.append("&link_code=\(formData.linkCode!)".data(using: .utf8)!)
        }
        postData.append("&link_need_acceptance=\(formData.linkNeedAcceptance)".data(using: .utf8)!)
        postData.append("&members_admin_ids=\(formData.membersAdminIds)".data(using: .utf8)!)
        postData.append("&members_member_ids=\(formData.membersMemberIds)".data(using: .utf8)!)
        postData.append("&members_readonly_ids=\(formData.membersReadonlyIds)".data(using: .utf8)!)
        postData.append("&icon_preset=\(formData.iconPreset.rawValue)".data(using: .utf8)!)
        
        request.httpBody = postData as Data
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        let responseStatusCode = (response as! HTTPURLResponse).statusCode
        
        // 200以外は例外
        try throwNot200StatusCode(responseStatusCode)
        
        // デコードする
        do {
            let decodeResult = try JSONDecoder().decode(PostResponse.self, from: data).roomId
            return decodeResult
        } catch {
            throw APIError.failedToDecodeModel
        }
    }
    
    struct PostResponse: Decodable {
        let roomId: Int
        
        enum CodingKeys: String, CodingKey {
            case roomId = "room_id"
        }
    }
}
