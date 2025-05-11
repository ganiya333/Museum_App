import FirebaseFirestore

struct MuseumService {
    
    private let db = Firestore.firestore()
    
    func fetchMuseums() async throws -> [Museum] {
        let snapshot = try await db.collection("museums").getDocuments()
        return snapshot.documents.map { document in
            Museum(id: document.documentID, data: document.data())
        }
    }
    
    func fetchExhibits(for museumId: String) async throws -> [Exhibit] {
        let snapshot = try await db.collection("exhibits")
            .whereField("museumId", isEqualTo: museumId)
            .getDocuments()
        
        return snapshot.documents.map { document in
            Exhibit(
                id: document.documentID,
                name: document["name"] as? String ?? "",
                imageURL: document["imageURL"] as? String ?? "",
                author: document["author"] as? String ?? "Unknown",
                year: document["year"] as? String ?? "",
                description: document["description"] as? String ?? "",
                museumId: museumId
            )
        }
    }
}
