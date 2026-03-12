import Foundation

public struct CreditsResponseModel: Decodable, Identifiable, Hashable, Sendable {
    public let id: Int
    public let cast: [CastCrewModel]
    public let crew: [CastCrewModel]
}

public struct CastCrewModel: Decodable, Identifiable, Hashable, Sendable {
    public let id: Int
    public let known_for_department: String?
    public let name: String
    public let order: Int?
    public let profilePath: String?
    public let occupancy: String
    
    public enum CodingKeys: String, CodingKey, Sendable {
        case id, known_for_department, name, order
        case profilePath = "profile_path"
        case job
        case character
    }
    
    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        known_for_department = try values.decodeIfPresent(String.self, forKey: .known_for_department)
        name = try values.decode(String.self, forKey: .name)
        order = try values.decodeIfPresent(Int.self, forKey: .order)
        profilePath = try values.decodeIfPresent(String.self, forKey: .profilePath)
        
        if let character = try? values.decode(String.self, forKey: .character) {
            occupancy = character
        } else {
            occupancy = try values.decode(String.self, forKey: .job)
        }
    }
    
    public init(id: Int, known_for_department: String? = nil, name: String, order: Int, profilePath: String? = nil, occupancy: String) {
        self.id = id
        self.known_for_department = known_for_department
        self.name = name
        self.order = order
        self.profilePath = profilePath
        self.occupancy = occupancy
    }
    
    
}

public extension CastCrewModel {
    static let sample: Self = .init(id: 17419, known_for_department: "Acting", name: "Bryan Cranston", order: 0, profilePath: "/7Jahy5LZX2Fo8fGJltMreAI49hC.jpg", occupancy: "Walter White")
}
