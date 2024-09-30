import SwiftUI


struct ChatListView: View {
    @ObservedObject var viewModel: ChatListView.ViewModel
    
    var body: some View {
        // NavigationView 추가
            VStack {
                
                //----------------------------------------------------------------------------

                HStack(){
                    Text("채팅")
                        .font(.system(size: 25).weight(.bold))
                    Spacer()
                }
                .padding(.horizontal, 20)

                //----------------------------------------------------------------------------

                HStack(){
                    Button(action:{}){
                        Text("전체")
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.3))
                    )

                    Button(action:{}){
                        Text("판매")
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.3))
                    )

                    Button(action:{}){
                        Text("구매")
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.3))
                    )

                    Button(action:{}){
                        Text("안 읽은 채팅방")
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.3))
                    )

                    Spacer()
                }

                .padding(.top, 5)
                .padding(.horizontal, 20)

                //----------------------------------------------------------------------------

                ScrollView {
                    ForEach(viewModel.chats, id: \.id) { chat in
                        NavigationLink(destination: ChatView(viewModel: ChatViewModel(chatterUsername: chat.chatterUsername ?? "", chatterNickname:chat.chatterNickname ?? "", postId:chat.relatedPostId))) {
                            HStack {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                                    .padding(.trailing, 10)

                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(chat.chatterNickname ?? "Unknown User") // chatterNickname을 사용하여 nickname 표시
                                            .padding(.bottom, 3)
                                        Spacer()
                                        if let lastSentTime = chat.lastSentTime {
                                            Text(lastSentTime, style: .time) // lastSentTime이 있을 경우
                                                .font(.system(size: 12))
                                                .foregroundColor(Color(.lightGray))
                                        } else {
                                            Text("Unknown Time") // lastSentTime이 없을 경우
                                                .font(.system(size: 12))
                                                .foregroundColor(Color(.lightGray))
                                        }
                                    }
                                    HStack {
                                        Text(chat.lastMessageText)
                                            .lineLimit(2)
                                            .font(.system(size: 14))
                                            .foregroundColor(Color(.gray))
                                        Spacer()
                                    }
                                }
                                Spacer()
                            }
                            .padding(.top, 30)
                        }

                    }
                }
                .padding(.horizontal, 15)
            }
    }
}

#Preview {
    ChatListView(viewModel: ChatListView.ViewModel())
}
