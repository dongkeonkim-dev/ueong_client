import SwiftUI

struct ChatListView: View {
    @ObservedObject var viewModel: ChatListView.ViewModel
    @State private var chatViewModel: ChatView.ViewModel?
    @State private var isChatViewActive = false

    var body: some View {
        VStack {
            // Title
            HStack {
                Text("채팅")
                    .font(.system(size: 25).weight(.bold))
                Spacer()
            }
            .padding(.horizontal, 20)

            // Button Filters
            HStack {
                Button(action: {}) {
                    Text("전체")
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                }
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.3)))
                
                Button(action: {}) {
                    Text("판매")
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                }
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.3)))
                
                Button(action: {}) {
                    Text("구매")
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                }
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.3)))
                
                Button(action: {}) {
                    Text("안 읽은 채팅방")
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                }
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.3)))
                
                Spacer()
            }
            .padding(.top, 5)
            .padding(.horizontal, 20)

            // Chat List
            List(viewModel.chats.sorted(by: { $0.rawLastSentTime > $1.rawLastSentTime })) { chat in
                Button(action: {
                    // 채팅 뷰모델을 비동기적으로 생성
                    Task {
                        if let post = await viewModel.fetchPost(by: chat.relatedPostId) {
                            chatViewModel = ChatView.ViewModel(
                                chatRoomId: chat.id,
                                username: username,
                                userNickname: "유저1",
                                partnerUsername: chat.partnerUsername,
                                partnerNickname: chat.partnerNickname,
                                relatedPost: post
                            )
                            isChatViewActive = true // 채팅 뷰를 활성화
                        }
                    }
                }) {
                    HStack {
                        // 상대방 프로필 이미지
                        if let profilePhotoURL = chat.partnerProfilePhotoURL,
                           let url = URL(string: profilePhotoURL) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            } placeholder: {
                                Circle()
                                    .fill(Color.gray)
                                    .frame(width: 50, height: 50)
                            }
                        } else {
                            // 프로필 사진이 없을 경우 기본 이미지
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 50, height: 50)
                        }
                        
                        VStack(alignment: .leading) {
                            // 상대방 이름 및 마지막 메시지
                            Text(chat.partnerNickname)
                                .font(.headline)
                            Text(chat.lastMessageText)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        VStack {
                            // 메시지 수신 시간 및 읽지 않은 메시지 표시
                            Text(chat.rawLastSentTime)
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            if chat.unreadMessages > 0 {
                                Text("\(chat.unreadMessages)")
                                    .font(.caption2)
                                    .padding(6)
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                .background(
                    NavigationLink(destination: chatViewModel.map { ChatView(viewModel: $0) }, isActive: $isChatViewActive) {
                        EmptyView()
                    }
                    .hidden() // NavigationLink를 숨깁니다.
                )
            }
            .listStyle(PlainListStyle())
        }
        .onAppear {
            // 뷰가 나타날 때 호출되는 코드
            viewModel.loadChat{
                // // loadChat 함수의 실행이 끝난 후 수행할 작업
            }
        }
    }
}

