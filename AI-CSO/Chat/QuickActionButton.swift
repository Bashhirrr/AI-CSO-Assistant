//
//  QuickActionButton.swift
//  AI-CSO
//
//  Created by Aliyu Khalifa on 27/11/2025.
//

import SwiftUI

struct QuickActionButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.red.opacity(0.12))
                .foregroundColor(.red)
                .cornerRadius(20)
        }
    }
}

