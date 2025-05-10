import SwiftUI

struct MuseumCard: View {
    let museum: Museum
    @StateObject private var loader = ImageLoader()
    
    var body: some View {
        
        VStack(spacing: 8) {
        
            Group {
                if let image = loader.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else if loader.isLoading {
                    ProgressView()
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                }
            }
            .frame(height: 180)
            .cornerRadius(12)
            .clipped()
            
            Text(museum.name)
                .font(.headline)
                .lineLimit(1)
        }
        .task {
            await loader.load(from: museum.imageURL)
        }
    }
}
