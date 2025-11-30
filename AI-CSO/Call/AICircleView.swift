//
//  AICircleView.swift
//  AI-CSO
//
//  Created by Aliyu Khalifa on 28/11/2025.
//

import SwiftUI

struct AICircleView: View {

    var isLive: Bool = false
    var isAvatar: Bool = false

    // Automatically chooses which label to show
    private var statusText: String? {
        if isLive { return "LIVE" }
        if isAvatar { return "Avatar" }
        return nil
    }

    var body: some View {
        ZStack(alignment: .bottom) {

            // Outer circle
            Circle()
                .fill(Color.redDark)
                .frame(width: 230, height: 230)
                .overlay(
                    // Inner circle
                    Circle()
                        .fill((isLive || isAvatar) ? Color.redDim : Color.redPrimary)
                        .frame(width: 215, height: 215)
                        .overlay(
                            Text("AI")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.white)
                        )
                )

            // Status label (LIVE / Avatar)
            if let statusText {
                Text(statusText)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.horizontal, 22)
                    .padding(.vertical, 12)
                    .background(Color.redDark)
                    .clipShape(Capsule())
                    .offset(y: 25)
            }
        }
    }
}






//struct AICircleView: View {
//    var isLive: Bool = false
//    
//    var body: some View {
//        ZStack {
//            if isLive {
//                // Pulsing animation for live call
//                Circle()
//                    .fill(Color.blue.opacity(0.3))
//                    .frame(width: 230, height: 230)
//                    .scaleEffect(isLive ? 1.1 : 1.0)
//                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isLive)
//            }
//            
//            Circle()
//                .fill(Color.blue.opacity(0.7))
//                .frame(width: 200, height: 200)
//
//            Circle()
//                .fill(Color.blue.opacity(0.5))
//                .frame(width: 185, height: 185)
//                .overlay(
//                    Text("AI")
//                        .font(.largeTitle)
//                        .bold()
//                        .foregroundColor(.white)
//                )
//        }
//    }
//}

