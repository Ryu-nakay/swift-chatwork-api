//
//  RoomsRoomIdRepository.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/11.
//

import XCTest
@testable import SwiftChatworkAPI

final class RoomsRoomIdRepositoryTests: XCTestCase {
    let token = try! APIToken(value: KeyManager().getAPIToken())

    func test_RoomsRoomIdGetResponseが帰ってくる() async throws {
        let roomId = try await Rooms().get(token: token).body[0].roomId
        
        let repository = RoomsRoomIdRepository()
        let result = try await repository.get(token: token, roomId: roomId)
        
        XCTAssertTrue(result is RoomsRoomIdGetResponse)
    }

}
