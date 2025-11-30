//
//  CallButton.swift
//  AI-CSO
//
//  Created by Aliyu Khalifa on 28/11/2025.
//

import SwiftUI

//struct PrimaryCallButton: View {
//    let action: () -> Void
//    
//    var body: some View {
//        Button(action: action) {
//            Image(systemName: "phone.fill")
//                .font(.system(size: 30))
//                .foregroundColor(.white)
//                .frame(width: 70, height: 70)
//                .background(Color.green)
//                .clipShape(Circle())              
//        }
//    }
//}


struct PrimaryCallButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.green)
                    .frame(width: 70, height: 70)
                Image(systemName: "phone.fill")
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
    }
}

