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
        public let body: [Room]
    }

    public struct Room: Decodable {
        public let roomId: Int
        public let name: String
        public let type: String
        public let role: String
        public let sticky: Bool
        public let unreadNum: Int
        public let mentionNum: Int
        public let mytaskNum: Int
        public let messageNum: Int
        public let fileNum: Int
        public let taskNum: Int
        public let iconPath: String
        public let lastUpdateTime: Int
        
        enum CodingKeys: String, CodingKey {
            case roomId = "room_id"
            case name = "name"
            case type = "type"
            case role = "role"
            case sticky = "sticky"
            case unreadNum = "unread_num"
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
        public let name: String
        // グループチャットの概要
        public let description: String
        // 招待リンクを作る場合(標準は0で作らない？)
        public let link: Int
        // 招待リンクのパス
        // 省略するとランダム
        public let linkCode: String?
        // 参加承認の必要・不要(標準1で必要？)
        public let linkNeedAcceptance: Int
        // 管理権限にしたいユーザーの一覧(アカウントIDをカンマ区切りで1名以上)
        public let membersAdminIds: String
        // メンバー権限にしたいユーザーの一覧(アカウントIDをカンマ区切りで)
        public let membersMemberIds: String
        // 閲覧のみにしたいユーザー一覧(アカウントIDをカンマ区切りで)
        public let membersReadonlyIds: String
        // グループチャットのアイコンの種類(選択)
        public let iconPreset: ChatworkAPI.IconPreset
        
        public init(name: String, description: String, link: Int = 0, linkCode: String? = nil, linkNeedAcceptance: Int = 1, membersAdminIds: String, membersMemberIds: String, membersReadonlyIds: String, iconPreset: ChatworkAPI.IconPreset) {
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
        public let roomId: Int
        
        enum CodingKeys: String, CodingKey {
            case roomId = "room_id"
        }
    }
}
