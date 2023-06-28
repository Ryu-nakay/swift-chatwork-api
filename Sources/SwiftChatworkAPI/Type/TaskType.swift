//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/28.
//

import Foundation

enum TaskType {
    enum Status: String {
        case open = "open"
        case done = "done"
    }
    
    enum LimitType: String {
        case none = "none"
        case date = "date"
        case time = "time"
    }
}
