//
//  CallControlButton.swift
//  AI-CSO
//
//  Created by Aliyu Khalifa on 30/11/2025.
//

import SwiftUI

struct CallControlButton: View {
    let icon: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(isActive ? Color.white : Color.gray)
                    .frame(width: 60, height: 60)
                    .shadow(radius: 4)

                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(isActive ? .black : .white)
            }
        }
    }
}
