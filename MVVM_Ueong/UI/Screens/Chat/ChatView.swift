
import SwiftUI
// MARK: - 채팅창
struct ChatView: View {
    @ObservedObject var viewModel: ChatView.ViewModel
    
    @State private var newMessage: String = ""

    var body: some View {
        VStack {
            
//-------------------------------------------------------------------------------------------------------------------------
            //채팅방 상단 상품 정보
            NavigationLink(
                destination: PostDetail(postId: viewModel.relatedPost.id, togglePostsListFavorite: {_ in})
            ) {
              PostRow(
                post: $viewModel.relatedPost,
                togglePostsListFavorite: {_ in},
                togglePostStatus: { post in  // $ 제거하고 일반 매개변수로
                  viewModel.togglePostStatus(post: post)  // wrappedValue 사용
                }
              )
            }
            
//-------------------------------------------------------------------------------------------------------------------------

            // 메시지 목록 스크롤
            MessageListView(viewModel: viewModel)

//-------------------------------------------------------------------------------------------------------------------------
            
            // 메시지 입력 및 전송
            MessageInputView(newMessage: $newMessage, sendMessageAction: {
             
                if !newMessage.isEmpty {
                    viewModel.sendMessageOrCreateChat(chatRoomId: viewModel.chatRoomId, username: UserDefaultsManager.shared.getUsername() ?? mockedUsername, partnerUsername: viewModel.partnerUsername, messageContent: newMessage, postId: viewModel.relatedPost.id)
                    
                    newMessage = "" // 메시지 전송 후 입력 필드를 비웁니다.
                }
                
            })
            
//-------------------------------------------------------------------------------------------------------------------------
            
        }
        .navigationTitle("\(viewModel.partnerNickname)")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(){
            if viewModel .chatRoomId != nil {
                viewModel.allReadMessage(chatRoomId: viewModel.chatRoomId!, username: UserDefaultsManager.shared.getUsername() ?? mockedUsername)
                
            }
        }
        .onDisappear(){
            if viewModel .chatRoomId != nil {
                viewModel.allReadMessage(chatRoomId: viewModel.chatRoomId!, username: UserDefaultsManager.shared.getUsername() ?? mockedUsername)
            }
        }
    }
}

// MARK: - 메시지 입력부 ------------------------------------------------------------------------------------------------------
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
//-------------------------------------------------------------------------------------------------------------------------


// MARK: - 채팅 목록 --------------------------------------------------------------------------------------------------------
struct MessageListView: View {
    @ObservedObject var viewModel: ChatView.ViewModel

    var body: some View {
        ScrollViewReader { scrollViewProxy in
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(viewModel.messages.sorted(by: { $0.id < $1.id })) { message in
                        ChatBubbleView(viewModel: viewModel, message: message)
                    }
                }
                .padding()
            }
            .onChange(of: viewModel.messages) { _ in
                // 메시지 배열이 변경될 때마다 스크롤
                if let lastMessageId = viewModel.messages.last?.id {
         
                        scrollViewProxy.scrollTo(lastMessageId, anchor: .bottom)
                    
                }
            }
            .onAppear {
                            // 뷰가 나타날 때 마지막 메시지로 스크롤
                            if let lastMessageId = viewModel.messages.last?.id {
                                scrollViewProxy.scrollTo(lastMessageId, anchor: .bottom)
                            }
                        }
            
            
        }
    }
}

//-------------------------------------------------------------------------------------------------------------------------


// MARK: - 채팅 버블 ---------------------------------------------------------------------------------------------------------
struct ChatBubbleView: View {
  @ObservedObject var viewModel: ChatView.ViewModel
  let message: Message
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        
        Text(message.senderUsername == UserDefaultsManager.shared.getUsername() ?? mockedUsername ? "" : message.senderUsername)
          .font(.caption)
          .foregroundColor(.gray)
        Text(message.messageText)
          .padding()
          .background(Color.gray.opacity(0.2))
          .cornerRadius(10)
          .frame(maxWidth: .infinity, alignment: message.senderUsername == UserDefaultsManager.shared.getUsername() ?? mockedUsername ? .trailing : .leading)
          //                if let sentTime = message.sentTime {
          //                    Text(sentTime, style: .time)
        Text(chatTime(message.sentTime))
          .font(.caption2)
          .foregroundColor(.gray)
          .frame(maxWidth: .infinity, alignment: message.senderUsername == UserDefaultsManager.shared.getUsername() ?? mockedUsername ? .trailing : .leading)
          //                } else {
          //                    // sentTime이 nil일 때 처리할 내용을 여기 작성
          //                    Text("Unknown Time")
          //                        .font(.caption2)
          //                        .foregroundColor(.gray)
          //                        .frame(maxWidth: .infinity, alignment: message.senderUsername == viewModel.username ? .trailing : .leading)
          //                }
      }
      Spacer()
    }
    .padding(.vertical, 2)
    .id(message.id) // ID로 메시지를 추적
  }
}
//-------------------------------------------------------------------------------------------------------------------------



// Preview 구성
//#Preview {
//    ChatView(viewModel: ChatViewModel(chatterUsername:"username2", chatterNickname:"유저2", postId:1))
//}

