//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/10.
//

import Foundation

enum APIError: Error {
    // HTTPのエラーに関しては200かそうでないかだけで一旦置いておく
    case statusCodeIsNot200
    
    // モデルへのデコードに失敗
    case failedToDecodeModel
}

