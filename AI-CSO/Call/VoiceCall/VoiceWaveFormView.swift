//
//  VoiceWaveFormView.swift
//  AI-CSO
//
//  Created by Aliyu Khalifa on 29/11/2025.
//

import SwiftUI

struct VoiceWaveformView: View {
    var level: CGFloat
    var isMicOn: Bool

    private let barCount = 12

    @State private var animatedLevel: CGFloat = 0

    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<barCount, id: \.self) { index in
                RoundedRectangle(cornerRadius: 3)
                    .fill(isMicOn ? Color.red : Color.gray)
                    .frame(
                        width: 6,
                        height: max(
                            6,
                            animatedLevel * barMultiplier(for: index) * 90
                        )
                    )
                    .opacity(isMicOn ? 1 : 0.25)
                    .animation(.easeOut(duration: 0.08), value: animatedLevel)
            }
        }
        .frame(height: 100)
        .padding(.horizontal, 40)
        .onChange(of: level) { newValue in
            // ✅ Smooth the signal so it feels natural
            animatedLevel = (animatedLevel * 0.6) + (newValue * 0.4)
        }
    }

    private func barMultiplier(for index: Int) -> CGFloat {
        let base = CGFloat(barCount - index) / CGFloat(barCount)
        return base + 0.15
    }
}




