import SwiftUI

struct PostsList: View {
    @ObservedObject var viewModel: PostsList.ViewModel
    
    var body: some View {
            VStack(spacing: 20) {
                HStack(spacing: -15){
                    SelectRegion()
                    SearchBar()
                    
                }
                .zIndex(1)
                
                SelectPostOption()
            
            
                ScrollView {
                    VStack(spacing: 13) {
                        ForEach(viewModel.posts) { post in
                            NavigationLink(
                                destination: PostDetail(viewModel: PostDetail.ViewModel(post: post))
                            ) {
                                PostRow(post: post)
                            }
                            
                        }
                    }
                }
                
            }
        
    }
}

#Preview {
    PostsList(viewModel: PostsList.ViewModel())
}

