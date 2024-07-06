import SwiftUI
import LinkNavigator

struct ChatsView: View {
    
    let navigator: LinkNavigatorType
    
    
    var body: some View {
        VStack() {
            
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
            
            ScrollView(){
                
                VStack {
                    HStack {
                        // 프로필 이미지 불러오기
                        Image("\(sortChatListByDate()[0].imageName)")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .font(.system(size: 32))
                            .padding(.trailing, 10) // 이미지랑 채팅 스택 사이 공백을 위한 패딩
                        
                        VStack { // 프로필 이름과 내용 가져오기
                            HStack {
                                Text("\(sortChatListByDate()[0].name)")
                                    .padding(.bottom, 3)
                                Spacer()
                                Text("\(sortChatListByDate()[0].date)")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(.lightGray))
                            }
                            HStack {
                                Text("\(sortChatListByDate()[0].Chat)")
                                    .lineLimit(2) // 내용 2줄로 제한해서 가져오기
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.gray))
                                Spacer()
                                
                                // nil 일 때 값을 없애기 위해서 if let으로 만들기
                                if let read = sortChatListByDate()[0].notRead {
                                    Text("\(read)")
                                        .padding(.leading, 5)
                                        .padding(.trailing, 5)
                                        .background(.red)
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                        .cornerRadius(9)
                                } else { // 값이 없을때도 padding을 맞추기 위해서 spacer 넣어주기
                                    Spacer()
                                }
                            }
                        }
                        Spacer()
                        
                        
                    }
                    .padding(.top, 30)
                    HStack {
                        // 프로필 이미지 불러오기
                        Image("\(sortChatListByDate()[1].imageName)")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .font(.system(size: 32))
                            .padding(.trailing, 10) // 이미지랑 채팅 스택 사이 공백을 위한 패딩
                        
                        VStack { // 프로필 이름과 내용 가져오기
                            HStack {
                                Text("\(sortChatListByDate()[1].name)")
                                    .padding(.bottom, 3)
                                Spacer()
                                Text("\(sortChatListByDate()[1].date)")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(.lightGray))
                            }
                            HStack {
                                Text("\(sortChatListByDate()[1].Chat)")
                                    .lineLimit(2) // 내용 2줄로 제한해서 가져오기
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.gray))
                                Spacer()
                                
                                // nil 일 때 값을 없애기 위해서 if let으로 만들기
                                if let read = sortChatListByDate()[1].notRead {
                                    Text("\(read)")
                                        .padding(.leading, 5)
                                        .padding(.trailing, 5)
                                        .background(.red)
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                        .cornerRadius(9)
                                } else { // 값이 없을때도 padding을 맞추기 위해서 spacer 넣어주기
                                    Spacer()
                                }
                            }
                        }
                        Spacer()
                        
                        
                    }
                    .padding(.top, 30)
                    
                    //----------------------------------------------------------------------------
                    
                }
                
                .navigationBarHidden(true)
                
            }
            .padding(.horizontal, 15)
            
        }
        
        
        
    }}
