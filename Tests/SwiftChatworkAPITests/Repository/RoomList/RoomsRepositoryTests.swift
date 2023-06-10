//
//  RoomListRepositoryTests.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/10.
//

import XCTest
@testable import SwiftChatworkAPI

final class RoomsRepositoryTests: XCTestCase {
    let token = try! APIToken(value: "InputYourToken")
    
    func test_ChatworkAPIへ正しいTokenでGETリクエストをするとRoomsGetResponse型のモデルが返ってくること() async throws {
        let repository = RoomsRepository()
        let result = try await repository.get(token: token)

        XCTAssertTrue(result is RoomsGetResponse)
    }
    
    func test_ChatworkAPIへ正しいTokenでPOSTリクエストをするとroom_idがInt型のモデルが返ってくること() async throws {
        let repository = RoomsRepository()
        let result = try await repository.post(token: token, formData: RoomsRepositoryPostFormData)

        XCTAssertTrue(result is Int)
    }
}
