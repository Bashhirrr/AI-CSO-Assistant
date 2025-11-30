////
////  VideoCallView.swift
////  AI-CSO
////
////  Created by Aliyu Khalifa on 29/11/2025.
////
//
//import SwiftUI
//import AgoraRtcKit
//import Network
//import AVFoundation
//
//struct VideoCallViewTest: View {
//
//    @Environment(\.dismiss) private var dismiss
//    @StateObject private var agora = AgoraManager.shared
//
//    @State private var callState: CallState = .ready
//    @State private var callDuration: Int = 0
//    @State private var isMicOn: Bool = true
//    @State private var isCameraOn: Bool = true
//    @State private var networkMonitor = NWPathMonitor()
//    @State private var isConnected: Bool = true
//    @State private var loadingProgress: Double = 0.0
//    @State private var loadingTimer: Timer?
//
//    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//
//    var body: some View {
//        VStack {
//            if callState == .ready {
//                headerView
//            } else if callState == .connecting || callState == .active {
//                headerTextOnly
//            }
//            
//            Group {
//                switch callState {
//                case .ready:
//                    preCallView
//                    Spacer()
//                    FooterView()
//                case .connecting:
//                    connectingView
//                    FooterView()
//                case .active:
//                    activeCallView
//                    FooterView()
//                case .ended:
//                    endedCallView
//                case .connectionFailed:
//                    connectionFailedView
//                }
//            }
//        }
//        .navigationBarBackButtonHidden(true)
//        .onReceive(timer) { _ in if callState == .active { callDuration += 1 } }
//        .onAppear {
//            startNetworkMonitoring()
//            agora.initialize(appId: "YOUR_AGORA_APP_ID")
//            agora.setupLocalVideo() // Setup local video preview
//        }
//        .onDisappear {
//            networkMonitor.cancel()
//            loadingTimer?.invalidate() // FIX 2: Clean up timer
//            agora.leaveChannel()
//        }
//    }
//
//    // MARK: - Pre Call
//    private var preCallView: some View {
//        VStack(spacing: 30) {
//            Spacer().frame(height: 80)
//            
//            // AI Circle
//            ZStack(alignment: .bottom) {
//                Circle()
//                    .fill(Color.red.opacity(0.7))
//                    .frame(width: 230, height: 230)
//
//                Circle()
//                    .fill(Color.red.opacity(0.5))
//                    .frame(width: 215, height: 215)
//                    .overlay(
//                        Text("AI")
//                            .font(.largeTitle)
//                            .bold()
//                            .foregroundColor(.white)
//                    )
//            }
//            
//            // Title + Subtitle
//            VStack(spacing: 6) {
//                Text("Video Support")
//                    .font(.headline)
//
//                Text("Connect with our AI avatar for a face-to-face experience")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                    .multilineTextAlignment(.center)
//                    .lineLimit(2)
//            }
//            .padding(.top, 10)
//            
//            Spacer().frame(height: 5)
//            
//            // Call Button + Loading Text
//            VStack(spacing: 30) {
//                Button(action: { startVideoCall() }) {
//                    ZStack {
//                        Circle()
//                            .fill(Color.green)
//                            .frame(width: 70, height: 70)
//                        Image(systemName: "video.fill")
//                            .font(.title2)
//                            .foregroundColor(.white)
//                    }
//                }
//                
//                Text("Loads in under 5 seconds")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                    .padding(.bottom, 10)
//            }
//            .padding(.top, -20)
//        }
//    }
//
//    
//    // MARK: - Connecting View
//    private var connectingView: some View {
//        VStack(spacing: 30) {
//            Spacer().frame(height: 80)
//
//            ZStack {
//                Circle().fill(Color.red).frame(width: 150, height: 150)
//                Text("AI").font(.system(size: 50, weight: .bold)).foregroundColor(.white)
//            }
//
//            VStack(spacing: 10) {
//                Text("Loading Avatar...").font(.headline)
//                Text("\(Int(loadingProgress))%").font(.title3).foregroundColor(.gray)
//                
//                // Connection status indicator
//                if !isConnected {
//                    HStack(spacing: 8) {
//                        Image(systemName: "wifi.slash")
//                            .foregroundColor(.red)
//                        Text("No Internet Connection")
//                            .font(.caption)
//                            .foregroundColor(.red)
//                    }
//                    .padding(.top, 10)
//                }
//            }
//            .padding(.top, 10)
//
//            Spacer()
//        }
//        .onAppear { animateLoading() }
//    }
//
//
//    // MARK: - Active Call
//    private var activeCallView: some View {
//        ZStack {
//            LinearGradient(gradient: Gradient(colors: [Color.red.opacity(0.8), Color.red.opacity(0.95)]),
//                           startPoint: .topLeading,
//                           endPoint: .bottomTrailing)
//            .ignoresSafeArea()
//
//            // Remote Video (AI Avatar) - Full Screen Background
//            if let remoteUid = agora.remoteUsers.first {
//                AgoraVideoView(uid: remoteUid, isLocal: false)
//                    .edgesIgnoringSafeArea(.all)
//            } else {
//                // Placeholder while waiting for remote user
//                VStack(spacing: 20) {
//                    Spacer()
//                    ZStack {
//                        Circle().fill(Color.red.opacity(0.3)).frame(width: 250, height: 250)
//                        Text("AI").font(.system(size: 100, weight: .bold)).foregroundColor(.white)
//                        Image(systemName: "waveform").font(.system(size: 40)).foregroundColor(.white.opacity(0.8)).offset(y: 100)
//                    }
//                    
//                    Text("Connecting to AI Avatar...")
//                        .font(.caption)
//                        .foregroundColor(.white.opacity(0.7))
//                    
//                    Spacer()
//                }
//            }
//            
//            // Call Duration Timer - Top Center
//            VStack {
//                Text(timeString(from: callDuration))
//                    .font(.title2)
//                    .foregroundColor(.white)
//                    .padding(.horizontal, 20)
//                    .padding(.vertical, 8)
//                    .background(Color.black.opacity(0.4))
//                    .cornerRadius(20)
//                    .padding(.top, 60)
//                
//                Spacer()
//            }
//
//            // Control buttons
//            VStack {
//                Spacer()
//                HStack(spacing: 40) {
//                    
//                    CallControlButton(
//                        icon: isMicOn ? "mic.fill" : "mic.slash.fill",
//                        isActive: isMicOn
//                    ) {
//                        hapticTap()
//                        isMicOn.toggle()
//                        agora.muteLocalAudio(!isMicOn)
//                    }
//
//                    EndCallButtonView {
//                        hapticTap()
//                        endCall()
//                    }
//                    
//                    CallControlButton(
//                        icon: isCameraOn ? "video.fill" : "video.slash.fill",
//                        isActive: isCameraOn
//                    ) {
//                        hapticTap()
//                        toggleCamera()
//                    }
//
//                }
//                .padding(.bottom, 40)
//            }
//
//            // Mini Camera Preview - Your Camera
//            VStack {
//                Spacer()
//                HStack {
//                    Spacer()
//
//                    // Agora local video view
//                    if isCameraOn {
//                        AgoraVideoView(uid: 0, isLocal: true)
//                            .frame(width: 120, height: 160)
//                            .clipShape(RoundedRectangle(cornerRadius: 12))
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 12)
//                                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
//                            )
//                            .padding(.trailing, 16)
//                            .padding(.bottom, 120)
//                    } else {
//                        // Camera off placeholder
//                        ZStack {
//                            RoundedRectangle(cornerRadius: 12)
//                                .fill(Color.gray.opacity(0.3))
//                                .frame(width: 120, height: 160)
//                            
//                            VStack(spacing: 8) {
//                                Image(systemName: "video.slash.fill")
//                                    .font(.title2)
//                                    .foregroundColor(.gray)
//                                Text("Camera Off")
//                                    .font(.caption2)
//                                    .foregroundColor(.gray)
//                            }
//                        }
//                        .padding(.trailing, 16)
//                        .padding(.bottom, 120)
//                    }
//                }
//            }
//        }
//    }
//
//    // MARK: - Ended Call
//    private var endedCallView: some View {
//        VStack(spacing: 20) {
//            HStack {
//                Spacer()
//                Button { dismiss() } label: {
//                    Image(systemName: "xmark")
//                        .padding(10)
//                        .foregroundColor(.black)
//                }
//                .padding(.trailing, 30)
//                .padding(.top, 10)
//            }
//            Spacer()
//            Image(systemName: "phone.down.fill")
//                .font(.system(size: 80))
//                .foregroundColor(.white)
//                .frame(width: 120, height: 120)
//                .background(Color.gray)
//                .clipShape(Circle())
//            Text("Call Ended").font(.largeTitle).bold()
//            Text("Duration: \(timeString(from: callDuration))")
//                .foregroundColor(.gray)
//                .font(.title3)
//            
//            Button { resetCall() } label: {
//                Text("Start New Call")
//                    .font(.headline)
//                    .foregroundColor(.black)
//                    .padding()
//                    .background(Color.gray.opacity(0.3))
//                    .cornerRadius(12)
//                    .padding(.horizontal, 40)
//            }
//            .padding(.top, 20)
//            
//            Spacer()
//        }
//    }
//
//    // MARK: - Connection Failed
//    private var connectionFailedView: some View {
//        VStack(spacing: 20) {
//            Spacer()
//            Text("Connection Failed").font(.largeTitle).bold()
//            Text("Please check your internet connection and try again.")
//                .foregroundColor(.gray)
//                .multilineTextAlignment(.center)
//                .padding(.horizontal, 40)
//            Spacer()
//            Button { resetCall() } label: {
//                Text("Try Again")
//                    .font(.headline)
//                    .padding()
//                    .background(Color.gray.opacity(0.3))
//                    .cornerRadius(12)
//            }
//            Spacer()
//        }
//    }
//
//    // MARK: - Header
//    private var headerView: some View {
//        HStack(spacing: 16) {
//            Button { dismiss() } label: {
//                Image(systemName: "arrow.left")
//                    .font(.title3)
//            }
//
//            VStack(alignment: .leading, spacing: 2) {
//                Text("Video Support").font(.headline).bold()
//                Text("Connect with AI avatar").font(.caption).foregroundColor(.gray)
//            }
//
//            Spacer()
//        }
//        .padding(.horizontal)
//        .padding(.top)
//    }
//    
//    // MARK: - Header Text Only (no back button)
//    private var headerTextOnly: some View {
//        HStack(spacing: 16) {
//            VStack(alignment: .leading, spacing: 2) {
//                Text("Video Support").font(.headline).bold()
//                Text("Connect with AI avatar").font(.caption).foregroundColor(.gray)
//            }
//
//            Spacer()
//        }
//        .padding(.horizontal)
//        .padding(.top)
//    }
//
//    // MARK: - Functions
//    private func startVideoCall() {
//        callState = .connecting // FIX 3: Only set to connecting, let animateLoading handle the rest
//    }
//
//    private func endCall() {
//        callState = .ended
//        loadingTimer?.invalidate() // FIX 4: Clean up timer when ending call
//        agora.leaveChannel()
//    }
//
//    private func resetCall() {
//        callDuration = 0
//        loadingProgress = 0.0 // FIX 5: Reset loading progress
//        callState = .ready
//    }
//    
//    private func toggleCamera() {
//        isCameraOn.toggle()
//        
//        if isCameraOn {
//            // Turn camera back on
//            agora.enableVideo(true)
//        } else {
//            // Turn camera off
//            agora.muteLocalVideo(true)
//        }
//    }
//
//    private func timeString(from seconds: Int) -> String {
//        String(format: "%02d:%02d", seconds / 60, seconds % 60)
//    }
//
//    private func startNetworkMonitoring() {
//        let queue = DispatchQueue(label: "NetworkMonitor")
//        networkMonitor.start(queue: queue)
//        networkMonitor.pathUpdateHandler = { path in
//            DispatchQueue.main.async { self.isConnected = path.status == .satisfied }
//        }
//    }
//    
//    private func animateLoading() {
//        // Check internet connection first
//        if !isConnected {
//            callState = .connectionFailed
//            hapticTap()
//            return
//        }
//        
//        loadingProgress = 0.0 // FIX 6: Reset at start
//        loadingTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [self] timer in
//            if loadingProgress < 100 {
//                loadingProgress += 2
//            } else {
//                timer.invalidate()
//                // Double-check connection before joining
//                if isConnected {
//                    // FIX 7: Move Agora setup here where it belongs
//                    agora.enableVideo(true)
//                    agora.joinChannel(token: nil, channelName: "videoChannel")
//                    callState = .active
//                } else {
//                    callState = .connectionFailed
//                    hapticTap()
//                }
//            }
//        }
//    }
//    
//    private func hapticTap() {
//        let generator = UIImpactFeedbackGenerator(style: .medium)
//        generator.prepare()
//        generator.impactOccurred()
//    }
//}
//
//// MARK: - Agora Video View
//struct AgoraVideoView: UIViewRepresentable {
//    let uid: UInt
//    let isLocal: Bool
//    
//    func makeUIView(context: Context) -> UIView {
//        let view = UIView()
//        
//        if isLocal {
//            // Setup local video canvas
//            let videoCanvas = AgoraRtcVideoCanvas()
//            videoCanvas.uid = uid
//            videoCanvas.view = view
//            videoCanvas.renderMode = .hidden
//            AgoraManager.shared.setupLocalVideoCanvas(videoCanvas)
//        } else {
//            // Setup remote video canvas
//            let videoCanvas = AgoraRtcVideoCanvas()
//            videoCanvas.uid = uid
//            videoCanvas.view = view
//            videoCanvas.renderMode = .hidden
//            AgoraManager.shared.setupRemoteVideoCanvas(videoCanvas)
//        }
//        
//        return view
//    }
//    
//    func updateUIView(_ uiView: UIView, context: Context) {
//        // Update if needed
//    }
//}
//
//
//struct VideoCallView_Previews: PreviewProvider {
//    static var previews: some View {
//        VideoCallView()
//    }
//}
//
//struct VideoCallView_Previews2: PreviewProvider {
//    static var previews: some View {
//        VideoCallView()
//            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
//    }
//}
