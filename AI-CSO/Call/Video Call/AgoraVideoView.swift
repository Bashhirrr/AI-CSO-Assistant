//
//  AgoraVideoView.swift
//  AI-CSO
//
//  Created by Aliyu Khalifa on 30/11/2025.
//

import SwiftUI
import AgoraRtcKit

struct AgoraVideoView: UIViewRepresentable {
    let uid: UInt
    let isLocal: Bool

    func makeUIView(context: Context) -> UIView {
        let view = UIView()

        if isLocal {
            let canvas = AgoraRtcVideoCanvas()
            canvas.uid = uid
            canvas.view = view
            canvas.renderMode = .hidden
            AgoraManager.shared.setupLocalVideoCanvas(canvas)
        } else {
            let canvas = AgoraRtcVideoCanvas()
            canvas.uid = uid
            canvas.view = view
            canvas.renderMode = .hidden
            AgoraManager.shared.setupRemoteVideoCanvas(canvas)
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
