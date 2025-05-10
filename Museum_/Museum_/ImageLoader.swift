//
//  ImageLoader.swift
//  Museum_
//
//  Created by Ganiya Nursalieva on 10.05.2025.
//

import SwiftUI
import UIKit

@MainActor
class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
    @Published var error: Error?
    
    private static let cache = NSCache<NSString, UIImage>()
    
    func load(from urlString: String) async {
        guard !urlString.isEmpty, let url = URL(string: urlString) else {
            self.error = URLError(.badURL)
            return
        }
        
        if let cached = Self.cache.object(forKey: urlString as NSString) {
            self.image = cached
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                throw URLError(.cannotDecodeContentData)
            }
            
            Self.cache.setObject(image, forKey: urlString as NSString)
            self.image = image
        } catch {
            self.error = error
            print("Image load failed: \(error.localizedDescription)")
        }
    }
}
