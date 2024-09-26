import SwiftUI

// MARK: - 내 정보
struct MyAccountView: View {
    @ObservedObject var viewModel: MyAccountView.ViewModel

    var body: some View {
        NavigationView { // NavigationView 추가
           VStack {
               HStack {
                   Text("내 정보")
                       .font(.system(size: 25).weight(.bold))
                   Spacer()
               }
               .padding(.horizontal, 20)
               
               ScrollView {
                   VStack(spacing: 20) {
                       ProfileHeaderView(user: viewModel.user)
                       AccountInfoView(user: viewModel.user, logoutAction: {
                           // viewModel.logout()
                       })
                       
                       AccountActionsView(
                        editInfoDestination: AccountEditView(viewModel: AccountEditView.ViewModel(userId: viewModel.user.id)),
                            salesListDestination: AnyView(Text("판매목록 임시 화면")), // 임시 텍스트로 대체
                            deleteAccountAction: {
                                // 탈퇴 액션
                            }
                       )
                    
                  }
                  .padding(.leading, 5)
              }
          }
      }
   }
}

// MARK: - 프로필 헤더
struct ProfileHeaderView: View {
    let user: User

    var body: some View {
        VStack {
            Image(systemName: "person.circle.fill")
                .foregroundColor(.gray)
                .font(.system(size: 325, weight: .thin))
            HStack {
                Text(user.nickname)
                    .padding(.leading, 8)
                    .tracking(2)
                    .font(.system(size: 26))
                Spacer()
                HStack(spacing: -3) {
                    Image(systemName: "star.fill")
                    Image(systemName: "star.fill")
                    Image(systemName: "star.fill")
                    Image(systemName: "star.fill")
                    Image(systemName: "star")
                }
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.blue)
            }
            .padding(.horizontal, 20)
            .padding(.leading, -6)
        }
    }
}

// MARK: - 계정 정보
struct AccountInfoView: View {
    let user: User
    var logoutAction: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("ID:")
                    .bold()
                Text(user.username)
                Spacer()
            }
            .padding(.horizontal, 20)

            HStack {
                Text(user.email)
                Spacer()
                Button(action: logoutAction) {
                    HStack(spacing: 3) {
                        Text("로그아웃")
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                    }
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - 네비게이션 링크 및 액션 버튼을 포함한 뷰 (AccountActionsView)
struct AccountActionsView: View {
    let editInfoDestination: AccountEditView
    let salesListDestination : AnyView //SalesListView
    var deleteAccountAction: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Divider().padding(5)

            // 정보수정으로 가는 NavigationLink
            NavigationLink(destination: editInfoDestination) {
                HStack {
                    Image(systemName: "gearshape")
                    Text("정보수정")
                    Spacer()
                }
            }
            .font(.body)
            .padding(.horizontal)

            // 판매 목록으로 가는 NavigationLink
            NavigationLink(destination: salesListDestination) {
                HStack {
                    Image(systemName: "list.bullet.rectangle.portrait")
                    Text("판매목록")
                    Spacer()
                }
            }
            .font(.body)
            .padding(.horizontal)

            Divider().padding(5)

            // 회원 탈퇴 버튼은 여전히 액션 처리
            Button(action: deleteAccountAction) {
                HStack {
                    Image(systemName: "trash")
                    Text("회원 탈퇴")
                    Spacer()
                }
                .foregroundColor(.red)
                .font(.body)
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    MyAccountView(viewModel: MyAccountView.ViewModel())
}
