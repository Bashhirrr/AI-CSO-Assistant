//
//  AgoraManager.swift
//  AI-CSO
//
//  Created by Aliyu Khalifa on 30/11/2025.
//

import Foundation
import AgoraRtcKit
import AVFoundation


final class AgoraManager: NSObject, ObservableObject {
    static let shared = AgoraManager()
    private override init() {}

    private var agoraKit: AgoraRtcEngineKit?

    // MARK: - Observable Properties for SwiftUI
    @Published var isMicMuted: Bool = false
    @Published var isVideoMuted: Bool = false
    @Published var isConnected: Bool = false
    @Published var remoteUsers: Set<UInt> = []

    // ✅ REAL MIC VOLUME FOR WAVEFORM
    @Published var micVolume: CGFloat = 0.0

    // MARK: - Setup
    func initialize(appId: String) {

        // ✅ MUST BE FIRST — FIXES ERROR 101
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, options: [.defaultToSpeaker, .allowBluetooth])
            try session.setMode(.voiceChat)
            try session.setActive(true)
            print("✅ AVAudioSession Activated")
        } catch {
            print("❌ Audio session error:", error)
        }

        let config = AgoraRtcEngineConfig()
        config.appId = appId
        agoraKit = AgoraRtcEngineKit.sharedEngine(with: config, delegate: self)

        agoraKit?.enableVideo()

        agoraKit?.setAudioProfile(.speechStandard, scenario: .chatRoom)

        let videoConfig = AgoraVideoEncoderConfiguration(
            size: CGSize(width: 640, height: 480),
            frameRate: .fps30,
            bitrate: AgoraVideoBitrateStandard,
            orientationMode: .adaptative,
            mirrorMode: .auto
        )
        agoraKit?.setVideoEncoderConfiguration(videoConfig)

        agoraKit?.enableAudio()
        agoraKit?.enableVideo()

        agoraKit?.setAudioScenario(.chatRoom)

        // ❌ IMPORTANT: DO NOT enable volume indication here anymore
    }

    func joinChannel(token: String?, channelName: String, uid: UInt = 0) {
        guard let agoraKit = agoraKit else { return }

        agoraKit.setChannelProfile(.communication)
        agoraKit.setClientRole(.broadcaster)

        _ = agoraKit.joinChannel(
            byToken: token,
            channelId: channelName,
            info: nil,
            uid: uid
        ) { [weak self] channel, uid, elapsed in
            print("✅ Joined Agora channel \(channel) as \(uid)")
            agoraKit.enableAudioVolumeIndication(100, smooth: 3, reportVad: false)

            DispatchQueue.main.async { self?.isConnected = true }
        }
    }

    func leaveChannel() {
        agoraKit?.stopPreview()
        agoraKit?.leaveChannel()
        isConnected = false
        isMicMuted = false
        isVideoMuted = false
        micVolume = 0
        remoteUsers.removeAll()
    }
    
    // MARK: - Audio / Video Controls
    func enableVideo(_ enabled: Bool) {
        guard let agoraKit = agoraKit else { return }
        if enabled {
            agoraKit.enableVideo()
            agoraKit.startPreview()
            isVideoMuted = false
        } else {
            agoraKit.muteLocalVideoStream(true)
            isVideoMuted = true
        }
    }

    func muteLocalAudio(_ mute: Bool) {
        agoraKit?.muteLocalAudioStream(mute)
        isMicMuted = mute

        if mute {
            micVolume = 0
        }
    }

    func muteLocalVideo(_ mute: Bool) {
        agoraKit?.muteLocalVideoStream(mute)
        isVideoMuted = mute
    }

    // MARK: - Video Canvas Setup
    func setupLocalVideo() {
        agoraKit?.startPreview()
    }

    func setupLocalVideoCanvas(_ canvas: AgoraRtcVideoCanvas) {
        agoraKit?.setupLocalVideo(canvas)
    }

    func setupRemoteVideoCanvas(_ canvas: AgoraRtcVideoCanvas) {
        agoraKit?.setupRemoteVideo(canvas)
    }

    // MARK: - Audio-Only Mode (for voice calls)
    func enableAudioOnly() {
        agoraKit?.disableVideo()
        agoraKit?.stopPreview()

        agoraKit?.setAudioProfile(.speechStandard, scenario: .chatRoom)

        // ✅ KEEP VOLUME CALLBACK ACTIVE
        agoraKit?.enableAudioVolumeIndication(100, smooth: 3, reportVad: false)

        enableAudioEnhancements()
    }

    // MARK: - Speaker Mode Control
    func setSpeakerMode(_ enabled: Bool) {
        agoraKit?.setEnableSpeakerphone(enabled)
    }

    // MARK: - Audio Enhancements
    func enableAudioEnhancements() {
        agoraKit?.setParameters("{\"che.audio.ains_mode\": 2}")
        agoraKit?.setParameters("{\"che.audio.enable.aec\": true}")
        agoraKit?.setParameters("{\"che.audio.agc.enable\": true}")
        agoraKit?.setParameters("{\"che.audio.enable.ns\": true}")
    }
}

// MARK: - Agora Delegate
extension AgoraManager: AgoraRtcEngineDelegate {

    func rtcEngine(
        _ engine: AgoraRtcEngineKit,
        reportAudioVolumeIndicationOfSpeakers speakers: [AgoraRtcAudioVolumeInfo],
        totalVolume: Int
    ) {
        DispatchQueue.main.async {

            // ✅ Prefer direct local mic volume when available
            if let localUser = speakers.first(where: { $0.uid == 0 }) {
                let normalized = min(CGFloat(localUser.volume) / 255.0, 1.0)
                self.micVolume = normalized
                print("🎤 LOCAL MIC:", normalized)
            }
            // ✅ Fallback to total volume if local packet is missing
            else {
                let normalized = min(CGFloat(totalVolume) / 255.0, 1.0)
                self.micVolume = normalized
                print("🎤 TOTAL MIC:", normalized)
            }
        }
    }


    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        DispatchQueue.main.async {
            self.remoteUsers.insert(uid)
        }
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        DispatchQueue.main.async {
            self.remoteUsers.remove(uid)
        }
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        DispatchQueue.main.async {
            self.isConnected = true
        }
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        print("❌ Agora Error: \(errorCode.rawValue)")
    }
}
