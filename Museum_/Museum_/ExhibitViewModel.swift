import FirebaseFirestore
import Combine

@MainActor
class ExhibitViewModel: ObservableObject {
    @Published var exhibits: [Exhibit] = []
    @Published var isLoading = false
    @Published var error: Error?
    private let db = Firestore.firestore()
    
    func fetchExhibits(museumID: String) async {
        isLoading = true
        error = nil
        
        do {
            let snapshot = try await db.collection("museums")
                .document(museumID)
                .collection("exhibits")
                .getDocuments()
            
            self.exhibits = snapshot.documents.map { doc in
                let data = doc.data()
                return Exhibit(
                    id: doc.documentID,
                    name: data["name"] as? String ?? "",
                    imageURL: data["imageURL"] as? String ?? "",
                    author: data["author"] as? String ?? "Неизвестен",
                    year: data["year"] as? String ?? "",
                    description: data["description"] as? String ?? "Описание отсутствует",
                    museumId: museumID
                )
            }
        } catch {
            self.error = error
            print("Error fetching exhibits: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
}
