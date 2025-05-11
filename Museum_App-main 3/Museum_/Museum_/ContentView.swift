//
//  ContentView.swift
//  Museum_
//
//  Created by Ganiya Nursalieva on 08.05.2025.
import SwiftUI
import FirebaseAuth
import SwiftUI
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        Group {
            if authService.isAuthenticated {
                MuseumListView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            // Гарантируем сброс при возврате на этот экран
            if !authService.isAuthenticated {
                try? Auth.auth().signOut()
            }
        }
    }
}
