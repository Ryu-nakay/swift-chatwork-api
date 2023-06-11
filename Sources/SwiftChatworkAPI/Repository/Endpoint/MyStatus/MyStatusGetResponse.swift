//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/11.
//

import Foundation

struct MyStatusGetResponse: Decodable {
    let unreadRoomNum: Int
    let mentionRoomNum: Int
    let mytaskRoomNum: Int
    let unreadNum: Int
    let mentionNum: Int
    let mytaskNum: Int
    
    enum CodingKeys: String, CodingKey {
        case unreadRoomNum = "unread_room_num"
        case mentionRoomNum = "mention_room_num"
        case mytaskRoomNum = "mytask_room_num"
        case unreadNum = "unread_num"
        case mentionNum = "mention_num"
        case mytaskNum = "mytask_num"
    }
}
