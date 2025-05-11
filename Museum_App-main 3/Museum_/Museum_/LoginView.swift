import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var showError = false
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        ZStack {
            Color(hex: "E5D0AC") // фон
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                // Логотип (можно заменить)
                Image(systemName: "building.columns.fill")
                    .font(.system(size: 50))
                    .foregroundColor(Color(hex: "690B22"))
                    .padding(.bottom, 20)
                
                // Поля ввода
                CustomInputField(placeholder: "Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                CustomInputField(placeholder: "Password", text: $password, isSecure: true)
                
                // Сообщение об ошибке
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .transition(.opacity)
                }
                
                // Кнопка входа
                Button(action: handleLogin) {
                    if authService.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Войти")
                            .foregroundColor(.white)
                    }
                }
                .disabled(authService.isLoading)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(hex: "690B22"))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(hex: "690B22"), lineWidth: 2)
                )
            }
            .padding(.horizontal, 30)
            .animation(.easeInOut, value: showError)
        }
    }
    
    private func handleLogin() {
        guard !email.isEmpty, !password.isEmpty else {
            showErrorMessage("Заполните все поля")
            return
        }
        
        guard email.contains("@") && email.contains(".") else {
            showErrorMessage("Введите корректный email")
            return
        }
        
        Task {
            do {
                try await authService.manualLogin(email: email, password: password)
            } catch {
                showErrorMessage(getReadableError(error))
            }
        }
    }
    
    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                showError = false
            }
        }
    }
    
    private func getReadableError(_ error: Error) -> String {
        if let authError = error as NSError? {
            switch authError.code {
            case AuthErrorCode.wrongPassword.rawValue:
                return "Неверный пароль"
            case AuthErrorCode.userNotFound.rawValue:
                return "Пользователь не найден"
            default:
                return "Ошибка входа: \(error.localizedDescription)"
            }
        }
        return "Неизвестная ошибка"
    }
}

struct CustomInputField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .padding()
        .background(Color(hex: "F3E1DE"))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(hex: "690B22"), lineWidth: 1)
        )
        .foregroundColor(.black)
    }
}
