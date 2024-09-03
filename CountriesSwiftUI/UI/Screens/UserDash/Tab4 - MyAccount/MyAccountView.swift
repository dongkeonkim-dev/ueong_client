//import LinkNavigator
//import SwiftUI
//
//struct MyAccountView: View {
//    let navigator: Navigator
//    @EnvironmentObject var authViewModel: AuthViewModel
//    @StateObject var userViewModel = UserViewModel()
//
//    var body: some View {
//        VStack() {
//            HStack() {
//                Text("내정보")
//                    .font(.system(size: 25).weight(.bold))
//                Spacer()
//            }
//            .padding(.horizontal, 20)
//
//            ScrollView {
//                VStack(spacing: 20) {
//                    if let user = userViewModel.user {
//                        //별명, 별점
//                        HStack {
//                            Image(systemName: "person.crop.circle")
//                                .font(.system(size: 40, weight: .thin))
//                            Text(user.nickname)
//                                .font(.system(size: 26))
//                            Spacer()
//                            HStack(spacing: -3) {
//                                Image(systemName: "star.fill")
//                                Image(systemName: "star.fill")
//                                Image(systemName: "star.fill")
//                                Image(systemName: "star.fill")
//                                Image(systemName: "star")
//                            }
//                            .font(.system(size: 12, weight: .bold))
//                            .foregroundColor(.blue)
//                        }
//                        .font(.title)
//                        .padding(.horizontal)
//                        .padding(.leading, -6)
//
//                        //ID
//                        HStack {
//                            Text("ID:")
//                                .bold()
//                            Text(user.username)
//                            Spacer()
//                        }
//                        .font(.title3)
//                        .padding(.horizontal)
//
//                        //이메일, 로그아웃
//                        HStack {
//                            Text(user.email)
//                            Spacer()
//                            Button(action: {
//                                authViewModel.logout()
//                            }) {
//                                HStack(spacing: 1) {
//                                    Text("로그아웃")
//                                    Image(systemName: "rectangle.portrait.and.arrow.right")
//                                }
//                                .font(.system(size: 14, weight: .bold))
//                                .foregroundColor(.blue)
//                                .background(.white)
//                                .cornerRadius(10)
//                            }
//                        }
//                        .font(.title3)
//                        .padding(.horizontal)
//
//                        Divider()
//                            .padding()
//
//                        //정보 수정
//                        Button(action: {
//                            navigator.next(paths: ["editProfile"], items: [:], isAnimated: true)
//                        }) {
//                            HStack {
//                                Image(systemName: "gearshape")
//                                Text("정보수정")
//                                Spacer()
//                            }
//                        }
//                        .font(.title3)
//                        .padding(.horizontal)
//
//                        //판매목록
//                        Button(action: {
//                            navigator.next(paths: ["myListings"], items: [:], isAnimated: true)
//                        }) {
//                            HStack {
//                                Image(systemName: "list.bullet.rectangle.portrait")
//                                Text("판매목록")
//                                Spacer()
//                            }
//                            .font(.title3)
//                            .padding(.horizontal)
//                        }
//
//                        Divider().padding()
//
//                        //탈퇴
//                        Button(action: {
//                            ///
//                        }) {
//                            HStack {
//                                Image(systemName: "trash")
//                                Text("회원 탈퇴")
//                                Spacer()
//                            }
//                            .foregroundColor(.red)
//                            .font(.title3)
//                            .padding(.horizontal)
//                        }
//                    } else if let errorMessage = userViewModel.errorMessage {
//                        Text("Error: \(errorMessage)")
//                            .foregroundColor(.red)
//                            .padding()
//                    }
//
//                    Spacer()
//                }
//                .padding()
//                .padding(.leading, 5)
//            }
//        }
//        .onAppear {
//            userViewModel.fetchUser(byUsername: authViewModel.username)
//        }
//    }
//}
