//
//  FooterView.swift
//  AI-CSO
//
//  Created by Aliyu Khalifa on 28/11/2025.
//

import SwiftUI

struct FooterView: View {
    var body: some View {
        HStack {
            Image(systemName: "lock.fill")
            Text("Encrypted call • AI speech recognition enabled")
        }
        .font(.footnote)
        .foregroundColor(.gray)
        .padding(.bottom)
    }
}

