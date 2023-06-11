//
//  ContactsRepositoryTests.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/11.
//

import XCTest
@testable import SwiftChatworkAPI

final class ContactsRepositoryTests: XCTestCase {
    let token = try! APIToken(value: KeyManager().getAPIToken())
    
    // ContactsGetResponse?が返ってくることを確認できればOKとする
    func test_ChatworkAPIへ正しいTokenでリクエストをするとContactsGetResponse型のモデルが返ってくること() async throws {
        let repository = ContactsRepository()
        let result = try await repository.get(token: token)
        
        XCTAssertTrue(result is ContactsGetResponse?) // 常にtrueだけど、テストの意図を伝えるための記述
    }
}
