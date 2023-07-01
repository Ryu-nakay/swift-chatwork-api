import XCTest
@testable import SwiftChatworkAPI

final class SwiftChatworkAPITests: XCTestCase {
    let api = ChatworkAPI.shared
    
    override func setUp() async throws {
        let token = try! APIToken(value: KeyManager().getAPIToken())
        try! ChatworkAPI.shared.registerToken(token: token.value)
    }
    
    func test_ChatworkAPIのmeのget() async throws {
        let meGetResult = try await api.me.get()
    }
    
    func test_ChatworkAPIのmy_statusのget() async throws {
        let myStatusGetResult = try await api.my.status.get()
    }
    
    func test_ChatworkAPIのmy_tasksのget() async throws {
        let myTasksGetResult = try await api.my.tasks.get()
    }
    
    func test_ChatworkAPIのcontactsのget() async throws {
        let contactsGetResult = try await api.contacts.get()
    }
        
    func test_ChatworkAPIのroomsのget() async throws {
        let roomsGetResult = try await api.rooms.get()
    }
        
    func test_ChatworkAPIのrooms_roomIdのput() async throws {
        let meGetResult = try await api.me.get()
        
        let roomsPostResult = try await api.rooms.post(formData: RoomsPath.PostFormData(
            name: "テストルーム\(Date.now)",
            description: "description",
            membersAdminIds: "\(meGetResult.accountId)",
            membersMemberIds: "",
            membersReadonlyIds: "",
            iconPreset: .idea)
        )
        
        let roomsRoomIdPutResult = try await api.rooms.roomId.put(
            roomId: roomsPostResult,
            formData: RoomIdPath.PutFormData(
                name: "変更された名前",
                description: "変更された詳細",
                iconPreset: .beer
            )
        )
    }
    
    func test_ChatworkAPIのrooms_roomIdのpostとgetとdelete() async throws {
        let meGetResult = try await api.me.get()
        
        let roomsPostResult = try await api.rooms.post(formData: RoomsPath.PostFormData(
            name: "テストルーム\(Date.now)",
            description: "description",
            membersAdminIds: "\(meGetResult.accountId)",
            membersMemberIds: "",
            membersReadonlyIds: "",
            iconPreset: .idea)
        )
        
        let roomsRoomIdGetResult = try await api.rooms.roomId.get(roomId: roomsPostResult)
        
        try await api.rooms.roomId.delete(roomId: roomsPostResult, actionType: .delete)
    }
        
        
    func test_ChatworkAPIのrooms_roomId_tasksのpostとget() async throws {
        let meGetResult = try await api.me.get()
        
        let roomsPostResult = try await api.rooms.post(formData: RoomsPath.PostFormData(
            name: "テストルーム\(Date.now)",
            description: "description",
            membersAdminIds: "\(meGetResult.accountId)",
            membersMemberIds: "",
            membersReadonlyIds: "",
            iconPreset: .idea)
        )
        
        let roomsRoomIdTasksPostResult = try await api.rooms.roomId.tasks.post(
            roomId: roomsPostResult,
            formData: TasksPath.FormData(
                body: "タスク内容",
                toIds: "\(meGetResult.accountId)",
                limit: 0,
                limitType: .none
            )
        )
        
        let roomsRoomIdTasksGetResult = try await api.rooms.roomId.tasks.get(
            roomId: roomsPostResult,
            queryParams: TasksPath.QueryParams(
                accountId: meGetResult.accountId,
                assignedByAccountId: meGetResult.accountId,
                status: .open
            )
        )
        
        let roomsRoomIdTasksTaskIdGetResult = try await api.rooms.roomId.tasks.taskId.get(
            roomId: roomsPostResult,
            taskId: roomsRoomIdTasksPostResult.taskIds[0]
        )
        
        let roomsRoomIdTasksTaskIdStatusPutResult = try await api.rooms.roomId.tasks.taskId.status.put(
            roomId: roomsPostResult,
            taskId: roomsRoomIdTasksPostResult.taskIds[0],
            status: .done
        )
    }
}
