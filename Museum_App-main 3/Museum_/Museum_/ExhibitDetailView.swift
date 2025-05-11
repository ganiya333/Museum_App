import SwiftUI

struct ExhibitDetailView: View {
    let exhibit: Exhibit
    @StateObject private var imageLoader = ImageLoader()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color(hex: "690B22")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Основное изображение
                    exhibitImage
                    
                    // Информация об экспонате
                    VStack(alignment: .leading, spacing: 16) {
                        Text(exhibit.name)
                            .font(.title.bold())
                            .foregroundColor(.white)
                        
                        Divider()
                            .overlay(Color.white.opacity(0.3))
                        
                        InfoRow(title: "Автор", value: exhibit.author)
                        InfoRow(title: "Год создания", value: exhibit.year)
                        
                        Divider()
                            .overlay(Color.white.opacity(0.3))
                        
                        Text("Описание")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text(exhibit.description)
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.top, 4)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    private var exhibitImage: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            } else if imageLoader.isLoading {
                ProgressView()
                    .frame(height: 200)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .foregroundColor(.white)
                    .overlay(
                        Text("Изображение не загружено")
                            .foregroundColor(.white)
                    )
            }
        }
        .padding(.horizontal)
        .task {
            await imageLoader.load(from: exhibit.imageURL)
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title + ":")
                .foregroundColor(.white.opacity(0.7))
                .frame(width: 120, alignment: .leading)
            Text(value)
                .fontWeight(.medium)
                .foregroundColor(.white)
            Spacer()
        }
    }
}
