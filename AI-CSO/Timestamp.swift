//
//  Timestamp.swift
//  AI-CSO
//
//  Created by Aliyu Khalifa on 27/11/2025.
//

import SwiftUI

struct TimestampView: View {
    let time: String
    
    var body: some View {
        Text(time)
            .font(.caption)
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

