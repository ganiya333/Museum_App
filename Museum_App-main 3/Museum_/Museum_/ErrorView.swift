//
//  ErrorView.swift
//  Museum_
//
//  Created by Ganiya Nursalieva on 10.05.2025.
//

import SwiftUI

struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.yellow)
            Text("Ошибка")
                .font(.title2)
                .bold()
            Text(error.localizedDescription)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            Button("Повторить", action: retryAction)
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}
