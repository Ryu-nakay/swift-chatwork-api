//
//  RoomListRepositoryTests.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/10.
//

import XCTest
@testable import SwiftChatworkAPI

final class RoomsRepositoryTests: XCTestCase {
    func test_ChatworkAPIへ正しいTokenでリクエストをするとRoomsGetResponse型のモデルが返ってくること() async throws {
        let repository = RoomsRepository()
        let result = try await repository.get(token: APIToken(value: "InputYourToken"))

        XCTAssertTrue(result is RoomsGetResponse)
    }
}
