
import SwiftUI
struct ChatListView: View {
    @ObservedObject var viewModel: ChatListView.ViewModel

    var body: some View {
        NavigationView {
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
                List(viewModel.chats) { chat in
                    Button(action: {}) {
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
                    .buttonStyle(PlainButtonStyle()) // 기본 버튼 스타일 제거
                  
                }
                .listStyle(PlainListStyle()) // 리스트 스타일을 평범한 스타일로 변경
               
            }
        }
    }
}

