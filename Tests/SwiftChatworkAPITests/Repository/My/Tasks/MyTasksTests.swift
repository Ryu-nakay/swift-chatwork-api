//
//  MyTasksRepositoryTests.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/11.
//

import XCTest
@testable import SwiftChatworkAPI

final class MyTasksTests: XCTestCase {
    let token = try! APIToken(value: KeyManager().getAPIToken())
    
    // MyTasksGetResponse返ってくることを確認できればOKとする
    func test_ChatworkAPIへ正しいTokenでリクエストをするとMyTasksGetResponse型のモデルが返ってくること() async throws {
        let repository = MyTasks()
        let result = try await repository.get(token: token)
        
        XCTAssertTrue(result is MyTasks.GetResponse) // 常にtrueだけど、テストの意図を伝えるための記述
    }
}
