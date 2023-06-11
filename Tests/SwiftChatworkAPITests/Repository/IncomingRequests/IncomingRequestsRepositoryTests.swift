//
//  IncomingRequestsRepositoryTests.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/11.
//

import XCTest
@testable import SwiftChatworkAPI

final class IncomingRequestsRepositoryTests: XCTestCase {
    let token = try! APIToken(value: KeyManager().getAPIToken())
    
    // IncomingRequestsGetResponse?が返ってくることを確認できればOKとする
    func test_ChatworkAPIへ正しいTokenでリクエストをするとIncomingRequestsGetResponse型のモデルが返ってくること() async throws {
        let repository = IncomingRequestsRepository()
        let result = try await repository.get(token: token)
        
        XCTAssertTrue(result is IncomingRequestsGetResponse?) // 常にtrueだけど、テストの意図を伝えるための記述
    }
}

