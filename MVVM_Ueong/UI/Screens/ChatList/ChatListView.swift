import SwiftUI

struct ChatListView: View {
    @ObservedObject var viewModel: ChatListView.ViewModel
    @State private var chatViewModel: ChatView.ViewModel?
    @State private var isChatViewActive = false
    @State private var selectedFilter: ChatFilter = .all // 선택된 필터 상태

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
                Button(action: {
                    selectedFilter = .all
                }) {
                    Text("전체")
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .font(selectedFilter == .all ? .headline : .body) // 진하게 변경
                }
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(selectedFilter == .all ? 0.5 : 0.3)))

                Button(action: {
                    selectedFilter = .seller
                }) {
                    Text("판매")
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .font(selectedFilter == .seller ? .headline : .body) // 진하게 변경
                }
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(selectedFilter == .seller ? 0.5 : 0.3)))

                Button(action: {
                    selectedFilter = .buyer
                }) {
                    Text("구매")
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .font(selectedFilter == .buyer ? .headline : .body) // 진하게 변경
                }
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(selectedFilter == .buyer ? 0.5 : 0.3)))

                Spacer()
            }
            .padding(.top, 5)
            .padding(.horizontal, 20)

            // Chat List
            List {
                ForEach(filteredChats(), id: \.id) { chat in // 필터링된 채팅 목록을 표시
                    Button(action: {
                        Task {
                            chatViewModel = nil
                            isChatViewActive = false

                            if let post = await viewModel.fetchPost(by: chat.relatedPostId) {
                                chatViewModel = ChatView.ViewModel(
                                    chatRoomId: chat.id,
                                    username: UserDefaultsManager.shared.getUsername() ?? mockedUsername,
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
                               let url = URL(string: baseURL.joinPath(profilePhotoURL)) {
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
                                    .lineLimit(1)  // 한 줄로 제한
                                    .truncationMode(.tail)  // 끝부분에 ... 표시
                            }

                            Spacer()

                            VStack {
                                // 메시지 수신 시간 및 읽지 않은 메시지 표시
                                Text(chatListTime(chat.lastSentTime))
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
                }
            }
            .listStyle(PlainListStyle())

            // NavigationLink를 List 바깥에 배치
            NavigationLink(destination: chatViewModel.map { ChatView(viewModel: $0) }, isActive: $isChatViewActive) {
                EmptyView()
            }
            .hidden() // NavigationLink를 숨깁니다.
        }
        .onAppear {
            // 뷰가 나타날 때 호출되는 코드
            viewModel.loadChat {
                // loadChat 함수의 실행이 끝난 후 수행할 작업
            }
        }
    }

    // 채팅 필터링 함수
    private func filteredChats() -> [Chat] {
        switch selectedFilter {
        case .all:
            return viewModel.chats
        case .seller:
            return viewModel.chats.filter { $0.partnerUsername != UserDefaultsManager.shared.getUsername() }
        case .buyer:
            return viewModel.chats.filter { $0.partnerUsername == UserDefaultsManager.shared.getUsername() }
        }
    }
}

// 필터링을 위한 enum
enum ChatFilter {
    case all
    case seller
    case buyer
}
