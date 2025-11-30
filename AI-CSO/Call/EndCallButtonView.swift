//
//  EndCallButtonView.swift
//  AI-CSO
//
//  Created by Aliyu Khalifa on 30/11/2025.
//

import SwiftUI

struct EndCallButtonView: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.red)
                    .frame(width: 60, height: 60)

                Image(systemName: "phone.down.fill")
                    .font(.title3)
                    .foregroundColor(.white)
            }
        }
    }
}
