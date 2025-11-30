//
//  VoiceCallviewTest.swift
//  AI-CSO
//
//  Created by Aliyu Khalifa on 29/11/2025.
//

import SwiftUI
import AgoraRtcKit
import Network
import AVFoundation

struct VoiceCallViewTest: View {

    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var agora = AgoraManager.shared

    @State private var callState: CallState = .ready
    @State private var callDuration: Int = 0
    @State private var networkMonitor = NWPathMonitor()
    @State private var isConnected: Bool = true
    @State private var isMicOn: Bool = true
    @State private var isSpeakerOn: Bool = false
    @State private var loadingProgress: Double = 0
    @State private var loadingTimer: Timer?

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            if callState != .ended { headerView }
            Group {
                switch callState {
                case .ready, .connecting:
                    preCallView
                    FooterView()
                case .active:
                    activeCallView
                    FooterView()
                case .ended:
                    endedCallView
                case .connectionFailed:
                    connectionFailedView
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onReceive(timer) { _ in if callState == .active { callDuration += 1 } }
        .onAppear {
            startNetworkMonitoring()
            agora.initialize(appId: "YOUR_AGORA_APP_ID")
        }
        .onDisappear {
            networkMonitor.cancel()
            loadingTimer?.invalidate()
            agora.leaveChannel()
        }
    }

    private var preCallView: some View {
        VStack(spacing: 30) {
            Spacer()
            AICircleView()
            VStack(spacing: 6) {
                Text("AI - CSO Voice").font(.headline)
                Text(callState == .ready ? "Ready to connect" : "Connecting...")
                    .foregroundColor(.gray)
            }
            Spacer()
            if callState == .ready {
                PrimaryCallButton { startVoiceCall() }
                    .padding(.bottom, 90)
            }
        }
    }

    private var activeCallView: some View {
        VStack {
            AICircleView(isLive: true)
            VStack(spacing: 6) {
                Text("AI - CSO Voice").font(.headline)
                Text(timeString(from: callDuration)).font(.caption).foregroundColor(.gray)
                Text("Mic: \(agora.micVolume)").foregroundColor(.red)
            }
            .padding(.top, 20)

            VoiceWaveformView(level: agora.micVolume, isMicOn: isMicOn).padding(.top, 16)
            Spacer()
            HStack(spacing: 40) {
                CallControlButton(icon: agora.isMicMuted ? "mic.slash.fill" : "mic.fill",
                                  isActive: !agora.isMicMuted) {
                    hapticTap()
                    isMicOn.toggle()
                    agora.muteLocalAudio(!isMicOn)
                }

                EndCallButton { endCall() }

                CallControlButton(icon: isSpeakerOn ? "speaker.wave.2.fill" : "speaker.slash.fill",
                                  isActive: isSpeakerOn) {
                    hapticTap()
                    isSpeakerOn.toggle()
                    agora.setSpeakerMode(isSpeakerOn)
                }
            }
            .padding(.bottom, 80)
        }
        .padding(.top, 60)
    }

    private var endedCallView: some View {
        VStack(spacing: 20) {

            HStack {
                Spacer()
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .padding(10)
                        .foregroundColor(.black)
                }
                .padding(.trailing, 30)
                .padding(.top, 10)
            }

            Spacer()

            Image(systemName: "phone.down.fill")
                .font(.system(size: 80))
                .foregroundColor(.white)
                .frame(width: 120, height: 120)
                .background(Color.gray)
                .clipShape(Circle())

            Text("Call Ended")
                .font(.largeTitle)
                .bold()

            Text("Duration: \(timeString(from: callDuration))")
                .foregroundColor(.gray)
                .font(.title3)

            Spacer()

            Button { resetCall() } label: {
                Text("Start New Call")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
            }
            .padding(.bottom, 120)
        }
    }

    private var connectionFailedView: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Connection Failed").font(.largeTitle).bold()
            Text("Please check your internet connection and try again.").foregroundColor(.gray).multilineTextAlignment(.center).padding(.horizontal, 40)
            Spacer()
            Button { dismiss() } label: {
                Text("Close").font(.headline).padding().background(Color.gray.opacity(0.3)).cornerRadius(12)
            }
            Spacer()
        }
    }

    private var headerView: some View {
        HStack(spacing: 16) {
            if callState == .ready {
                Button { dismiss() } label: { Image(systemName: "arrow.left").font(.title3) }
            }
            VStack(alignment: .leading, spacing: 2) {
                Text("Voice Support").font(.headline).bold()
                Text("Speak naturally with AI").font(.caption).foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.horizontal).padding(.top)
    }

    // MARK: - Functions
    private func startVoiceCall() {
        callState = .connecting
        guard isConnected else { callState = .connectionFailed; hapticTap(); return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if isConnected {
                agora.enableAudioOnly()
                agora.joinChannel(token: nil, channelName: "testChannel")
                callState = .active
            } else {
                callState = .connectionFailed
                hapticTap()
            }
        }
    }
    
    private func resetCall() {
        callDuration = 0
        loadingProgress = 0.0
        callState = .ready
    }

    private func endCall() {
        callState = .ended
        loadingTimer?.invalidate()
        agora.leaveChannel()
    }

    private func timeString(from seconds: Int) -> String {
        String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }

    private func startNetworkMonitoring() {
        let queue = DispatchQueue(label: "NetworkMonitor")
        networkMonitor.start(queue: queue)
        networkMonitor.pathUpdateHandler = { path in
            DispatchQueue.main.async { self.isConnected = path.status == .satisfied }
        }
    }

    private func hapticTap() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}



struct VoiceCallviewTest_Previews: PreviewProvider {
    static var previews: some View {
        VoiceCallViewTest()
    }
}
