// The Swift Programming Language
// https://docs.swift.org/swift-book

struct ChatworkAPI {
    static let shared: ChatworkAPI = .init()
    private init() {}
    
    private var token: APIToken?
    
    // ChatworkAPIのTokenを設定するメソッド
    mutating func registerToken(token: String) throws {
        do {
            self.token = try APIToken(value: token)
        } catch {
            throw error
        }
    }
}
