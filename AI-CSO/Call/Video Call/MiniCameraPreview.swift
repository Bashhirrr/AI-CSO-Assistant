//
//  MiniCameraPreview.swift
//  AI-CSO
//
//  Created by Aliyu Khalifa on 30/11/2025.
//

import SwiftUI
import AVFoundation

struct MiniCameraPreview: View {
    let isCameraOn: Bool
    let isAuthorized: Bool
    let session: AVCaptureSession

    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.black.opacity(0.7))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
            )
            .overlay(
                Group {
                    if isCameraOn && isAuthorized && session.isRunning {
                        CameraPreviewView(session: session)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "video.slash.fill")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                            Text("Camera Off").font(.caption2).foregroundColor(.gray)
                        }
                    }
                }
            )
            .frame(width: 120, height: 160)
    }
}

