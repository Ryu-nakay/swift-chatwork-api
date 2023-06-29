//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/28.
//

import Foundation

public enum TaskType {
    public enum Status: String {
        case open = "open"
        case done = "done"
    }
    
    public enum LimitType: String {
        case none = "none"
        case date = "date"
        case time = "time"
    }
}
