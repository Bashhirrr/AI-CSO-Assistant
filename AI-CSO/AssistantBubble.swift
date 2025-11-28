//
//  AssistantBubble.swift
//  AI-CSO
//
//  Created by Aliyu Khalifa on 27/11/2025.
//

import SwiftUI

struct AssistantBubble: View {
    let text: String
    let time: String
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            Image(systemName: "brain.head.profile")
                .foregroundColor(.white)
                .padding(10)
                .background(Color.redPrimary)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(text)
                    .padding()
                    .background(Color.redHighlight.opacity(0.15))
                    .cornerRadius(16)
                
                // Timestamp aligned bottom-left
                Text(time)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(.leading, 8)
            }
            
            Spacer()
        }
    }
}

