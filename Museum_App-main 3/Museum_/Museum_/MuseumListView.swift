//import SwiftUI
//import FirebaseFirestore
//import FirebaseAuth
//
//struct MuseumListView: View {
//    @StateObject var viewModel = MuseumViewModel()
//    @EnvironmentObject var authService: AuthService
//    @State private var showLogoutAlert = false
//    
//    // Выносим основное содержимое в отдельное вычисляемое свойство
//    private var museumGrid: some View {
//        ScrollView {
//            LazyVGrid(
//                columns: [GridItem(.adaptive(minimum: 180), spacing: 15)],
//                spacing: 15
//            ) {
//                ForEach(viewModel.museums) { museum in
//                    NavigationLink(destination: ExhibitListView(museumID: museum.id)) {
//                        MuseumCard(museum: museum)
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                }
//            }
//            .padding()
//        }
//    }
//    
//    // Выносим кнопку выхода в отдельное вычисляемое свойство
//    private var logoutButton: some View {
//        Button(action: { showLogoutAlert = true }) {
//            Image(systemName: "rectangle.portrait.and.arrow.right")
//                .foregroundColor(Color(hex: "690B22"))
//        }
//    }
//    
//    // Выносим alert в отдельное вычисляемое свойство
////    private var logoutAlert: Alert {
////        Alert(
////            title: Text("Выход"),
////            message: Text("Вы уверены, что хотите выйти?"),
////            primaryButton: .destructive(Text("Выйти")) {
////                try? $authService.logout
////            },
////            secondaryButton: .cancel()
////        )
////    }
//    
//    var body: some View {
//        NavigationView {
//            ZStack {
//                // Фон
//                Color(hex: "E5D0AC").ignoresSafeArea()
//                
//                // Основное содержимое
//                Group {
//                    if viewModel.museums.isEmpty && !viewModel.isLoading {
//                        emptyStateView
//                    } else {
//                        museumGrid
//                    }
//                }
//                .navigationTitle("Музеи")
//                .toolbar { ToolbarItem(placement: .navigationBarTrailing) { logoutButton } }
//                .alert(isPresented: $showLogoutAlert) { logoutAlert }
//                
//                // Индикатор загрузки
//                if viewModel.isLoading {
//                    loadingIndicator
//                }
//            }
//        }
//        .navigationViewStyle(.stack)
//        .onAppear(perform: loadMuseumsIfNeeded)
//    }
//    
//    // MARK: - Подкомпоненты
//    
//    private var emptyStateView: some View {
//        Text("Музеи не найдены")
//            .foregroundColor(Color(hex: "690B22"))
//    }
//    
//    private var loadingIndicator: some View {
//        ProgressView()
//            .scaleEffect(2)
//            .tint(Color(hex: "690B22"))
//    }
//    
//    // MARK: - Методы
//    
//    private func loadMuseumsIfNeeded() {
//        if authService.isAuthenticated {
//            Task {
//                await viewModel.fetchMuseums()
//            }
//        }
//    }
//}


import SwiftUI
import FirebaseFirestore

struct MuseumListView: View {
    @StateObject var viewModel = MuseumViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Фон
                Color(hex: "E5D0AC").ignoresSafeArea()
                
                // Основное содержимое
                Group {
                    if viewModel.museums.isEmpty && !viewModel.isLoading {
                        emptyStateView
                    } else {
                        museumGrid
                    }
                }
                .navigationTitle("Музеи")
                
                // Индикатор загрузки
                if viewModel.isLoading {
                    loadingIndicator
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchMuseums()
            }
        }
    }
    
    // MARK: - Подкомпоненты
    
    private var museumGrid: some View {
        ScrollView {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 180), spacing: 15)],
                spacing: 15
            ) {
                ForEach(viewModel.museums) { museum in
                    NavigationLink(value: museum) {
                        MuseumCard(museum: museum)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
        .navigationDestination(for: Museum.self) { museum in
            ExhibitListView(museumID: museum.id)
        }
    }
    
    private var emptyStateView: some View {
        Text("Музеи не найдены")
            .foregroundColor(Color(hex: "690B22"))
    }
    
    private var loadingIndicator: some View {
        ProgressView()
            .scaleEffect(2)
            .tint(Color(hex: "690B22"))
    }
}
