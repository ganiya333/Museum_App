//
//  Exhibit.swift
//  Museum_
//
//  Created by Ganiya Nursalieva on 09.05.2025.
//
import Foundation

struct Exhibit: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let imageURL: String
    let author: String
    let year: String
    let description: String
    let museumId: String
    
    init(
        id: String,
        name: String,
        imageURL: String,
        author: String,
        year: String,
        description: String,
        museumId: String
    ) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.author = author
        self.year = year
        self.description = description
        self.museumId = museumId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Exhibit, rhs: Exhibit) -> Bool {
        lhs.id == rhs.id
    }
}
