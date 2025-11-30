//
//  TypingIndicator.swift
//  AI-CSO
//
//  Created by Aliyu Khalifa on 28/11/2025.
//

import SwiftUI

struct TypingIndicator: View, Identifiable {
    let id = UUID() // unique for each instance
    
    @State private var scale: CGFloat = 0.5
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<3) { index in
                Circle()
                    .frame(width: 6, height: 6)
                    .scaleEffect(scale)
                    .animation(
                        .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                        value: scale
                    )
            }
        }
        .onAppear { scale = 1 }
        .padding(10)
        .background(Color.primary.opacity(0.08))
        .cornerRadius(12)
    }
}


