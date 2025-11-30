//
//  UserBubble.swift
//  AI-CSO
//
//  Created by Aliyu Khalifa on 27/11/2025.
//

import SwiftUI

struct UserBubble: View {
    let text: String
    let time: String
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(text)
                    .padding()
                    .background(Color.redHighlight.opacity(0.2))
                    .cornerRadius(16)
                
                // Timestamp aligned bottom-right
                Text(time)
                    .font(.caption2)
                    .foregroundColor(.black)
                    .padding(.trailing, 8)
            }
            
            Image(systemName: "person.fill")
                .foregroundColor(.white)
                .padding(10)
                .background(Color.redPrimary)
                .clipShape(Circle())
        }
    }
}

