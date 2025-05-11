import FirebaseAuth


class AuthService: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    
    init() {
        // Принудительный сброс авторизации при инициализации
        try? Auth.auth().signOut()
        isAuthenticated = false
    }
    
    func manualLogin(email: String, password: String) async throws {
        isLoading = true
        defer { isLoading = false }
        
        try await Auth.auth().signIn(withEmail: email, password: password)
        isAuthenticated = true
    }
}
