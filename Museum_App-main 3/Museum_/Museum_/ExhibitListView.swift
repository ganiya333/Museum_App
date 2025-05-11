import SwiftUI

struct ExhibitListView: View {
    @StateObject var viewModel = ExhibitViewModel()
    let museumID: String
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ZStack {
            Color(hex: "690B22")
                .ignoresSafeArea()
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.exhibits) { exhibit in
                        NavigationLink(value: exhibit) {
                            ExhibitCard(exhibit: exhibit)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(16)
            }
            .navigationDestination(for: Exhibit.self) { exhibit in
                ExhibitDetailView(exhibit: exhibit)
            }
        }
        .task {
            await viewModel.fetchExhibits(museumID: museumID)
        }
        .navigationTitle("Экспонаты")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Color(hex: "690B22"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

struct ExhibitCard: View {
    let exhibit: Exhibit
    @StateObject private var imageLoader = ImageLoader()
    
    private let imageHeight: CGFloat = 150
    private let imageWidth: CGFloat = 160
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Group {
                    if let image = imageLoader.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                    } else if imageLoader.isLoading {
                        ProgressView()
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .padding(30)
                            .foregroundColor(.white)
                    }
                }
                .frame(width: imageWidth, height: imageHeight)
                .clipped()
            }
            .frame(width: imageWidth, height: imageHeight)
            .background(Color(hex: "4A0718"))
            .cornerRadius(12, corners: [.topLeft, .topRight])
            
            VStack(alignment: .leading, spacing: 4) {
                Text(exhibit.name)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .frame(width: imageWidth - 24, alignment: .leading)
                
                Text("by \(exhibit.author)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(1)
                    .frame(width: imageWidth - 24, alignment: .leading)
            }
            .padding(12)
            .frame(width: imageWidth, alignment: .leading)
            .background(Color(hex: "4A0718"))
            .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
        }
        .frame(width: imageWidth)
        .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 3)
        .task {
            await imageLoader.load(from: exhibit.imageURL)
        }
    }
}

// Расширение для скругления определенных углов
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// Расширение для создания Color из HEX
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}
