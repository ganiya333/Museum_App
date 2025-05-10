import SwiftUI
import FirebaseFirestore


struct MuseumListView: View {
    @StateObject private var viewModel = MuseumViewModel()
    
    var body: some View {
        NavigationStack {
            Color(hex: "690B22")
                .ignoresSafeArea()
                .overlay(
                    Group {
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else if let error = viewModel.error {
                            ErrorView(error: error) {
                                Task { await viewModel.fetchMuseums() }
                            }
                        } else {
                            museumsGrid
                        }
                    }
                )
            .navigationTitle("Museums")
            .navigationDestination(for: Museum.self) { museum in
                ExhibitListView(museumID: museum.id)
            }
            .task {
                await viewModel.fetchMuseums()
            }
            // Настройки для navigation bar
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color(hex: "690B22"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
    
    private var museumsGrid: some View {
        ScrollView {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 180), spacing: 20)],
                spacing: 20
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
    }
}
