
import SwiftUI

struct SearchBar: View {
    @ObservedObject var viewModel: PostsList.ViewModel
    public var body: some View {
        
        VStack(spacing: 15) {
            
            NavigationLink(destination:SearchPost(sViewModel: SearchPost.ViewModel(), pViewModel:viewModel)){
                HStack{
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.blue) // 돋보기 아이콘의 색상을 파란색으로 변경
                        
                    Text("검색")
                        .font(.system(size: 15))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.3))
                    
            )
            .padding(.horizontal)
        }
    }
}

#Preview{SearchBar(viewModel:PostsList.ViewModel())}
