//
//  EndCallButton.swift
//  AI-CSO
//
//  Created by Aliyu Khalifa on 28/11/2025.
//

import SwiftUI

struct EndCallButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "phone.down.fill")
                .font(.system(size: 30))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .padding()
                .background(Color.red)
                .clipShape(Circle())
        }
    }
}

