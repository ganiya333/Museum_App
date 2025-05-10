import Foundation

struct Museum: Identifiable, Hashable {
    let id: String
    let name: String
    let imageURL: String
    let city: String?
    let description: String?
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.name = data["name"] as? String ?? ""
        self.imageURL = data["imageURL"] as? String ?? ""
        self.city = data["city"] as? String
        self.description = data["description"] as? String
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Реализация Equatable который наследуется от хэшбл
    static func == (lhs: Museum, rhs: Museum) -> Bool {
        lhs.id == rhs.id
    }
}
