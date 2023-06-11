//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/11.
//

import Foundation

import Foundation

struct RoomsRepositoryPostFormData {
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
    let iconPreset: IconPreset
    
    init(name: String, description: String, link: Int = 0, linkCode: String?, linkNeedAcceptance: Int = 1, membersAdminIds: String, membersMemberIds: String, membersReadonlyIds: String, iconPreset: IconPreset) {
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

enum IconPreset: String {
    case group = "group"
    case check = "check"
    case document = "document"
    case meeting = "meeting"
    case event = "event"
    case project = "project"
    case business = "business"
    case study = "study"
    case security = "security"
    case star = "star"
    case idea = "idea"
    case heart = "heart"
    case magcup = "magcup"
    case beer = "beer"
    case music = "music"
    case sports = "sports"
    case travel = "travel"
}
