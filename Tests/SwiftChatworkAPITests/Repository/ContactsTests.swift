//
//  ContactsRepositoryTests.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/11.
//

import XCTest
@testable import SwiftChatworkAPI

final class ContactsTests: XCTestCase {
    let token = try! APIToken(value: KeyManager().getAPIToken())
    
    // Response?が返ってくることを確認できればOKとする
    func test_ChatworkAPIへ正しいTokenでリクエストをするとResponse型のモデルが返ってくること() async throws {
        let repository = Contacts()
        let result = try await repository.get(token: token)
        
        XCTAssertTrue(result is Contacts.GetResponse?) // 常にtrueだけど、テストの意図を伝えるための記述
    }
}
