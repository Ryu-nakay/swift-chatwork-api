// The Swift Programming Language
// https://docs.swift.org/swift-book

public struct ChatworkAPI {
    public static let shared: ChatworkAPI = .init()
    private init() {}
    
    // ChatworkAPIのTokenを設定するメソッド
    public func registerToken(token: String) throws {
        do {
            let apiToken = try APIToken(value: token)
            TokenStore.shared.setToken(token: apiToken)
        } catch {
            throw error
        }
    }
    
    public let me = MePath()
    public let my = MyPath()
    public let contacts = ContactsPath()
    public let rooms = RoomsPath()
    public let incomingRequests = IncomingRequestsPath()
}

struct TokenStore {
    public static var shared: TokenStore = .init()
    private init() {}
    
    private var token: APIToken?
    
    mutating func setToken(token: APIToken) {
        self.token = token
    }
    
    func getToken() throws -> APIToken {
        if token == nil {
            throw TokenError.tokenDoesNotExist
        }
        
        return token!
    }
}

// Type
extension ChatworkAPI {
    public enum IconPreset: String {
        case group = "group"
        case check = "check"
        case document = "document"
        case meeting = "meeting"
        case event = "event"
        case project = "project"
        case business = "business"
        case study = "study"
        case security = "security"
        case star = "star"
        case idea = "idea"
        case heart = "heart"
        case magcup = "magcup"
        case beer = "beer"
        case music = "music"
        case sports = "sports"
        case travel = "travel"
    }
    
    public enum Role: String {
        case admin = "admin"
        case member = "member"
        case readonly = "readonly"
    }
    
    public struct Account: Decodable {
        let accountId: Int
        let name: String
        let avatarImageUrl: String
        
        enum CodingKeys: String, CodingKey {
            case accountId = "account_id"
            case name = "name"
            case avatarImageUrl = "avatar_image_url"
        }
    }
}
