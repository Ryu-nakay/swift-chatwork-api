//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/10.
//

import Foundation

public struct RoomsPath {
    public let roomId = RoomIdPath()
}

extension RoomsPath {
    var urlString: String {
        "https://api.chatwork.com/v2/rooms"
    }
    
    public func get() async throws -> GetResponse {
        let url = URL(string: urlString)!
        let token = try TokenStore.shared.getToken()
        let request = generateRequest(url: url, method: .get, token: token)
        let (data, response) = try await URLSession.shared.data(for: request)
        let responseStatusCode = (response as! HTTPURLResponse).statusCode
        // 200以外は例外
        try throwNot200StatusCode(responseStatusCode)
        // デコードする
        do {
            let decodeResult = try JSONDecoder().decode([Room].self, from: data)
            let roomListObject = GetResponse(body: decodeResult)
            return roomListObject
        } catch {
            throw APIError.failedToDecodeModel
        }
    }
    
    public func post(formData: PostFormData) async throws -> Int {
        let url = URL(string: urlString)!
        let token = try TokenStore.shared.getToken()
        var request = generateRequest(url: url, method: .post, token: token)
        
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
    
    
}

extension RoomsPath {
    public struct GetResponse  {
        let body: [Room]
    }

    struct Room: Decodable {
        let roomId: Int
        let name: String
        let type: String
        let role: String
        let sticky: Bool
        let mentionNum: Int
        let mytaskNum: Int
        let messageNum: Int
        let fileNum: Int
        let taskNum: Int
        let iconPath: String
        let lastUpdateTime: Int
        
        enum CodingKeys: String, CodingKey {
            case roomId = "room_id"
            case name = "name"
            case type = "type"
            case role = "role"
            case sticky = "sticky"
            case mentionNum = "mention_num"
            case mytaskNum = "mytask_num"
            case messageNum = "message_num"
            case fileNum = "file_num"
            case taskNum = "task_num"
            case iconPath = "icon_path"
            case lastUpdateTime = "last_update_time"
        }
    }
    
    public struct PostFormData {
        // グループチャットの名前
        let name: String
        // グループチャットの概要
        let description: String
        // 招待リンクを作る場合(標準は0で作らない？)
        let link: Int
        // 招待リンクのパス
        // 省略するとランダム
        let linkCode: String?
        // 参加承認の必要・不要(標準1で必要？)
        let linkNeedAcceptance: Int
        // 管理権限にしたいユーザーの一覧(アカウントIDをカンマ区切りで1名以上)
        let membersAdminIds: String
        // メンバー権限にしたいユーザーの一覧(アカウントIDをカンマ区切りで)
        let membersMemberIds: String
        // 閲覧のみにしたいユーザー一覧(アカウントIDをカンマ区切りで)
        let membersReadonlyIds: String
        // グループチャットのアイコンの種類(選択)
        let iconPreset: ChatworkAPI.IconPreset
        
        init(name: String, description: String, link: Int = 0, linkCode: String?, linkNeedAcceptance: Int = 1, membersAdminIds: String, membersMemberIds: String, membersReadonlyIds: String, iconPreset: ChatworkAPI.IconPreset) {
            self.name = name
            self.description = description
            self.link = link
            self.linkCode = linkCode
            self.linkNeedAcceptance = linkNeedAcceptance
            self.membersAdminIds = membersAdminIds
            self.membersMemberIds = membersMemberIds
            self.membersReadonlyIds = membersReadonlyIds
            self.iconPreset = iconPreset
        }
    }
    
    public struct PostResponse: Decodable {
        let roomId: Int
        
        enum CodingKeys: String, CodingKey {
            case roomId = "room_id"
        }
    }
}
