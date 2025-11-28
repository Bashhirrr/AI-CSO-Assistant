//
//  ContentView.swift
//  AI-CSO
//
//  Created by Aliyu Khalifa on 27/11/2025.
//


import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
       

            ScrollView {
                
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: - Header
//                    HStack {
//
//
//                        Spacer()
//
//                        Button(action: {}) {
//                            Image(systemName: "bell.fill")
//                                .font(.system(size: 22))
//                                .foregroundColor(.red)
//                                .padding(12)
//                                .background(Color.red.opacity(0.15))
//                                .clipShape(Circle())
//                        }
//                    }
//                    .padding(.horizontal)
                    
                    
                    // MARK: - Assistant Card
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Hello, Boluwatife")
                            .font(.largeTitle).bold()
                            .padding(.leading)
                        
                        
                    }
                    VStack(alignment: .leading, spacing: 12) {
                        
                        HStack(spacing: 10) {
                            Image(systemName: "sparkles")
                                .foregroundColor(.white)
                            
                            Text("AI-CSO Assistant")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        
                        Text("How can I help you today?")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("Get instant support via chat, voice, or video call")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 160)
                    .background(
                        LinearGradient(
                            colors: [Color.redPrimary, Color.redPrimary.opacity(0.7)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(20)
                    .padding(.horizontal)
                    
                    
                    // MARK: - Section Title
                    Text("CHOOSE SUPPORT MODE")
                        .font(.caption).bold()
                        .foregroundColor(.gray)
                        .font(.largeTitle).bold()
                        .padding(.horizontal)
                    
                    
                    // MARK: - Support Options
                    VStack(spacing: 16) {
                        NavigationLink {
                            ChatView()
                        } label: {
                            SupportRow(
                                icon: "message.fill",
                                title: "Chat Support",
                                subtitle: "Text-based AI assistance"
                            )
                        }
                        .buttonStyle(.plain)

                        
                        SupportRow(icon: "phone.fill",
                                   title: "Voice Call",
                                   subtitle: "Speak with AI assistant")
                        
                        SupportRow(icon: "video.fill",
                                   title: "Video Avatar",
                                   subtitle: "Face-to-face AI experience")
                    }
                    .padding(.horizontal)
                    
                    
                    Spacer()
                    
                    
                    // MARK: - Footer
                    HStack {
                        Image(systemName: "shield.fill")
                        Text("End-to-end encrypted • Your data is protected")
                    }
                    .font(.footnote)
                    .foregroundColor(Color.redPrimary)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.redHighlight.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
//            .navigationTitle("Home")
//            .navigationBarTitleDisplayMode(.inline)
            .padding(.top, 45)

        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView()
            .previewDevice("iPhone SE (2nd generation)")
    }
}
