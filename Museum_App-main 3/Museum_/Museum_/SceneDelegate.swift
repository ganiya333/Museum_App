//
//  SceneDelegate.swift
//  prpr
//
//  Created by Ganiya Nursalieva on 30.04.2025.
import UIKit
import SwiftUI
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let authService = AuthService()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UIHostingController(
            rootView: ContentView()
                .environmentObject(authService)
        )
        window?.makeKeyAndVisible()
        
        // Дополнительная проверка при запуске
        authService.isAuthenticated = false
    }
}
