import SwiftUI

struct AddPostButton: View {
    @ObservedObject var pViewModel: PostsList.ViewModel
    public var body: some View {
        VStack {
            Spacer() // 버튼을 하단으로 이동
            HStack {
                Spacer() // 버튼을 오른쪽으로 이동
                NavigationLink(destination: WritePost(wViewModel: WritePost.ViewModel(), pViewModel:pViewModel)) { // PostCreationView로 이동
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)
                        .padding()
                }
            }
        }
        .padding(.bottom, 20) // 하단 여백
        .padding(.trailing, 10) // 오른쪽 여백
    }
}

