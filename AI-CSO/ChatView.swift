//
//  ChatView.swift
//  AI-CSO
//
//  Created by Aliyu Khalifa on 27/11/2025.
//

import SwiftUI

struct ChatView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var isTyping = false
    @State private var messageText = ""
    
    
    
    
    @State private var messages: [Message] = [
        Message(text: "Hello! I'm your AI-CSO assistant. How can I help you today?", isUser: false),
        Message(text: "What are your loan rates like.", isUser: true),
        Message(text: """
    ALAT offers flexible loans:
    
    💰 Personal: Up to ₦5M
    🏡 Salary Advance: 50%
    📈 Business: Custom limits
    """, isUser: false)
    ]
    
    
    var body: some View {
        VStack {
            
            // MARK: - Header
            HStack(spacing: 12) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.25)){
                        dismiss()
                    }
                }) {
                    Image(systemName: "arrow.left")
                        .padding(10)
                        .foregroundColor(.black)
                        .background(Color.redHighlight.opacity(0.15))
                        .clipShape(Circle())
                }
                
                ZStack(alignment: .bottomTrailing) {
                    Image(systemName: "brain.head.profile")
                        .foregroundColor(.white)
                        .padding(14)
                        .background(Color.redPrimary)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 3) // border
                                .background(Circle().fill(Color.green)) // inner color
                                .frame(width: 14, height: 14)
                                .offset(x: 20, y: 18)
                        )
                }
                
                VStack(alignment: .leading) {
                    Text("AI-CSO Assistant")
                        .font(.headline)
                    Text("Online")
                        .font(.caption)
                        .foregroundColor(.green)
                }
                
                Spacer()
            }
            .padding()
            
            Divider()
            
            
            // MARK: - Messages
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(messages) { message in
                            if message.text.isEmpty && !message.isUser {
                                TypingIndicator()
                                    .padding(.leading)
                            } else if message.isUser {
                                UserBubble(text: message.text, time: message.time)
                            } else {
                                AssistantBubble(text: message.text, time: message.time)
                            }
                        }
                        
//                        if isTyping {
//                            TypingIndicator()
//                                .padding(.leading)
//                        }
                    }
                    .padding()
                }
                .onChange(of: messages.count) { _ in
                    if let lastID = messages.last?.id {
                        withAnimation(.easeInOut) {
                            proxy.scrollTo(lastID, anchor: .bottom)
                        }
                    }
                }
            }

                
                
                
                
                // MARK: - Quick Actions
                VStack(alignment: .leading, spacing: 10) {
                    Text("Quick actions")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    HStack {
                        QuickActionButton(title: "Check balance"){
                            sendQuickAction("Check my balance")
                        }
                        .disabled(isTyping)
                        QuickActionButton(title: "Reset PIN"){
                            sendQuickAction("I want to reset my PIN")
                        }
                        .disabled(isTyping)
                        QuickActionButton(title: "Get loan"){
                            sendQuickAction("I want to apply for a loan")
                        }
                        .disabled(isTyping)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 5)
                
                
                // MARK: - Message Input Bar
                HStack(spacing: 14) {
                    Button(action: {}) {
                        Image(systemName: "paperclip")
                            .foregroundColor(.red)
                            .padding(12)
                            .overlay(Circle().stroke(Color.red))
                    }
                    
                    HStack {
                        TextField("Type a message...", text: $messageText)
                            .foregroundColor(.black)
                        
//                        Button(action: {}) {
//                            Image(systemName: "mic.fill")
//                                .foregroundColor(.gray)
//                        }
                    }
                    .padding(12)
                    
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(30)
                    
                    // Send button
                    Button(action: sendMessage){
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .padding(14)
                            .background(Color.red)
                            .clipShape(Circle())
                    }
                    .disabled(messageText.isEmpty)
                }
                .padding()
                
            }
        
        .navigationBarBackButtonHidden(true)
        
        }
    
    func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        // Add user message
        let userMessage = Message(text: messageText, isUser: true)
        messages.append(userMessage)
        messageText = ""
        
        // Insert a temporary typing placeholder
        let typingMessage = Message(text: "", isUser: false)
        messages.append(typingMessage)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Remove typing placeholder
            messages.removeAll { $0.id == typingMessage.id }
            
            // Add AI reply
            messages.append(
                Message(text: "Thanks for your message. How else can I help?", isUser: false)
            )
        }
    }

    
    func sendQuickAction(_ text: String) {
        // Add user message
        messages.append(Message(text: text, isUser: true))
        
        // Insert temporary typing placeholder
        let typingMessage = Message(text: "", isUser: false)
        messages.append(typingMessage)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            // Remove typing placeholder
            messages.removeAll { $0.id == typingMessage.id }
            
            // Add AI reply
            messages.append(
                Message(text: "Processing: \(text)…", isUser: false)
            )
        }
    }




    
    }
    
    



    
    struct Message: Identifiable {
        let id = UUID()
        let text: String
        let isUser: Bool
        let time: String
        
        init(text: String, isUser: Bool) {
            self.text = text
            self.isUser = isUser
            self.time = Message.getCurrentTime()
        }
        
        static func getCurrentTime() -> String {
             let formatter = DateFormatter()
             formatter.dateFormat = "hh:mm a"
             return formatter.string(from: Date())
         }
    }
    


        
    
    
    
    struct ChatView_Previews: PreviewProvider {
        static var previews: some View {
            ChatView()
        }
    }

