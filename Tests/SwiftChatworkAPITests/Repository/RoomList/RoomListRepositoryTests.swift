//
//  RoomListRepositoryTests.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/10.
//

import XCTest

final class RoomListRepositoryTests: XCTestCase {
    func test_ChatworkAPIへ正しいTokenでリクエストをするとRoomList型のモデルが返ってくること() async throws {
        let repository = RoomListRepository()
        let result = try await repository.get(token: APIToken(value: "InputYourToken"))

        XCTAssertTrue(result is RoomList)
    }
}
