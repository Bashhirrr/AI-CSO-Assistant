//
//  SupportRow.swift
//  AI-CSO
//
//  Created by Aliyu Khalifa on 27/11/2025.
//

import SwiftUI

struct SupportRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(Color.redAccent)
                .frame(width: 65, height: 65)
                .background(Color.redHighlight.opacity(0.15))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.redPrimary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.3))
        )
    }
}
