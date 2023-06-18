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

// Type
extension ChatworkAPI {
    enum IconPreset: String {
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
    
    enum Role: String {
        case admin = "admin"
        case member = "member"
        case readonly = "readonly"
    }
    
    struct Account: Decodable {
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
