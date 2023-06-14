//
//  MyStatusRepositoryTests.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/11.
//

import XCTest
@testable import SwiftChatworkAPI

final class MyStatusTests: XCTestCase {
    let token = try! APIToken(value: KeyManager().getAPIToken())
    
    // Statusの返ってくることを確認できればOKとする
    func test_ChatworkAPIへ正しいTokenでリクエストをするとMyStatus型のモデルが返ってくること() async throws {
        let repository = MyStatus()
        let result = try await repository.get(token: token)
        
        XCTAssertTrue(result is MyStatus.GetResponse) // 常にtrueだけど、テストの意図を伝えるための記述
    }
}
