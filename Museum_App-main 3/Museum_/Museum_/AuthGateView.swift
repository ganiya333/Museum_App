//
//  AuthGateView.swift
//  Museum_
//
//  Created by Ganiya Nursalieva on 11.05.2025.
//
import SwiftUI
struct AuthGateView: View {
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        Group {
            if authService.isAuthenticated {
                ContentView() // Ваш экран с музеями
            } else {
                LoginView()
            }
        }
    }
}
