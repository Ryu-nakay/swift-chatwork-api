//
//  RoomListRepositoryTests.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/10.
//

import XCTest
@testable import SwiftChatworkAPI

final class RoomsTests: XCTestCase {
    let token = try! APIToken(value: KeyManager().getAPIToken())
    
    func test_ChatworkAPIへ正しいTokenでGETリクエストをするとGetResponse型のモデルが返ってくること() async throws {
        let repository = RoomsPath()
        let result = try await repository.get(token: token)

        XCTAssertTrue(result is RoomsPath.GetResponse)
    }
    
    func test_ChatworkAPIへ正しいTokenでPOSTリクエストをするとroom_idがInt型のモデルが返ってくること() async throws {
        let repository = RoomsPath()
        let acountId = try await MePath().get(token: token).accountId
        
        let formData = RoomsPath.PostFormData(
            name: "テスト作成 \(Date.now)",
            description: "APIライブラリからのテスト生成です",
            linkCode: "testroom\(Date.now)",
            membersAdminIds: "\(acountId)",
            membersMemberIds: "",
            membersReadonlyIds: "",
            iconPreset: .beer
        )
        let result = try await repository.post(token: token, formData: formData)

        XCTAssertTrue(result is Int)
    }
}
