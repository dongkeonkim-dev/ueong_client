//
//  ChatView.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/25/24.
//
import SwiftUI

// MARK: - 채팅창
struct ChatView: View {
    @ObservedObject var viewModel: ChatViewModel
    @State private var newMessage: String = ""

    var body: some View {
        VStack {
            // 메시지 목록 스크롤
            MessageListView(messages: viewModel.messages)

            // 메시지 입력 및 전송
            MessageInputView(newMessage: $newMessage, sendMessageAction: {
                viewModel.sendMessage(newMessage)
                newMessage = ""
            })
        }
        .navigationTitle("\(viewModel.chatter)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 채팅 목록
struct MessageListView: View {
    let messages: [Message]

    var body: some View {
        ScrollViewReader { scrollViewProxy in
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(messages) { message in
                        ChatBubbleView(message: message)
                    }
                }
                .padding()
            }
            .onChange(of: messages.count) {
                if let lastMessageId = messages.last?.id {
                    withAnimation {
                        scrollViewProxy.scrollTo(lastMessageId, anchor: .bottom)
                    }
                }
            }
        }
    }
}

// MARK: - 채팅 버블
struct ChatBubbleView: View {
    let message: Message

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(message.sender)")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(message.text)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, alignment: message.sender == "" ? .trailing : .leading)
                Text(message.sentTime, style: .time)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: message.sender == "" ? .trailing : .leading)
            }
            Spacer()
        }
        .padding(.vertical, 2)
        .id(message.id) // ID로 메시지를 추적
    }
}


// MARK: - 메시지 입력부
struct MessageInputView: View {
    @Binding var newMessage: String
    var sendMessageAction: () -> Void

    var body: some View {
        HStack {
            TextField("", text: $newMessage)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(minHeight: 30)
            
            Button(action: sendMessageAction) {
                Image(systemName: "paperplane")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
            }
            .frame(height: 35)
            .frame(minWidth: 50)
            .background(Color.blue)
            .cornerRadius(10)
        }
        .padding()
    }
}



// Preview 구성
#Preview {
    ChatView(viewModel: ChatViewModel(userId: 1, chatter:"cat1"))
}
