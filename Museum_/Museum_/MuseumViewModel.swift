import FirebaseFirestore
import Combine

@MainActor
class MuseumViewModel: ObservableObject {
    @Published var museums: [Museum] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let db = Firestore.firestore()
    
    func fetchMuseums() async {
        isLoading = true
        error = nil
        
        do {
            let snapshot = try await db.collection("museums").getDocuments()
            museums = snapshot.documents.map { document in
                Museum(id: document.documentID, data: document.data())
            }
        } catch {
            self.error = error
            print("Error fetching museums: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
}
