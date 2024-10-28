import SwiftUI
import PhotosUI

  // MARK: - 내 정보
struct MyAccountView: View {
  @EnvironmentObject var appState: AppState
  @StateObject var viewModel = MyAccountView.ViewModel()
  
  var body: some View {
    VStack {
      headerView
      ScrollView {
        contentView
          .onAppear {
            viewModel.fetchPage()
          }
          .padding(.leading, 5)
      }
    }
  }
  
    // MARK: - Header View
  private var headerView: some View {
    HStack {
      Text("내 정보")
        .font(.system(size: 25).weight(.bold))
      Spacer()
    }
    .padding(.horizontal, 20)
  }
  
    // MARK: - Content View
  private var contentView: some View {
    VStack(spacing: 20) {
      profileHeaderView
      accountInfoView
      accountActionsView
    }
  }
  
    // MARK: - 프로필 헤더
  private var profileHeaderView: some View {
    VStack {
      if let photoUrl = viewModel.user.profilePhotoUrl,
         let url = URL(string: baseURL.joinPath(photoUrl)) {
        AsyncImage(url: url) { image in
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 325, height: 325)
            .clipped()
            .clipShape(Circle())
        } placeholder: {
          ProgressView()
            .frame(width: 325, height: 325)
        }
      } else {
        Image(systemName: "person.circle.fill")
          .foregroundColor(.gray)
          .font(.system(size: 325, weight: .thin))
      }
      
      HStack {
        Text(viewModel.user.nickname)
          .padding(.leading, 8)
          .tracking(2)
          .font(.system(size: 26))
        Spacer()
          .font(.system(size: 12, weight: .bold))
          .foregroundColor(.blue)
      }
      .padding(.horizontal, 20)
      .padding(.leading, -6)
    }
  }
  
    // MARK: - 계정 정보
  private var accountInfoView: some View {
    VStack(spacing: 20) {
      HStack {
        Text("ID:")
          .bold()
        Text(viewModel.user.username)
        Spacer()
      }
      .padding(.horizontal, 20)
      
      HStack {
        Text(viewModel.user.email)
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
  
    // MARK: - 계정 액션
  private var accountActionsView: some View {
    VStack(spacing: 20) {
      Divider().padding(5)
      
      NavigationLink(destination: AccountEditView(viewModel: AccountEditView.ViewModel(), mViewModel: viewModel)) {
        HStack {
          Image(systemName: "gearshape")
          Text("정보수정")
          Spacer()
        }
      }
      .font(.body)
      .padding(.horizontal)
      
      NavigationLink(destination: SalesListView(viewModel: SalesListView.ViewModel())) {
        HStack {
          Image(systemName: "list.bullet.rectangle.portrait")
          Text("판매목록")
          Spacer()
        }
      }
      .font(.body)
      .padding(.horizontal)
      
      Divider().padding(5)
      
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
  
    // MARK: - 액션들
  private func logoutAction() {
    viewModel.onLogout = {
      appState.isLoggedIn = false
    }
    viewModel.logout()
  }
  
  private func deleteAccountAction() {
    viewModel.onLogout = {
      appState.isLoggedIn = false
    }
    viewModel.deleteUser()
  }
}
