//
//  MeRepositoryTests.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/10.
//

import XCTest
@testable import SwiftChatworkAPI

final class MeTests: XCTestCase {
    let token = try! APIToken(value: KeyManager().getAPIToken())
    
    // Meが返ってくることを確認できればOKとする
    func test_ChatworkAPIへ正しいTokenでリクエストをするとMeGetResponse型のモデルが返ってくること() async throws {
        let repository = MePath()
        let result = try await repository.get(token: token)
        
        XCTAssertTrue(result is MePath.GetResponse) // 常にtrueだけど、テストの意図を伝えるための記述
    }
    
    func test_ChatworkAPIへ間違ったTokenでリクエストをすると例外が返ってくること() async throws {
        let repository = MePath()
        do {
            _ = try await repository.get(token: APIToken(value: "invalidTokenです"))
            XCTFail("期待した例外が起きませんでした")
        } catch {
            // catchに入れば成功のためPass
        }
    }
}
