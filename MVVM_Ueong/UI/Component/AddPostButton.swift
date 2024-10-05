import SwiftUI

struct AddPostButton: View {
    @ObservedObject var pViewModel: PostsList.ViewModel
    @ObservedObject var wViewModel: WritePost.ViewModel
    @State private var isNavigating = false // State to control navigation

    public var body: some View {
        ZStack {
            // This hidden NavigationLink allows us to navigate programmatically
            NavigationLink(destination: WritePost(wViewModel: wViewModel, pViewModel: pViewModel), isActive: $isNavigating) {
                EmptyView()
            }
            .hidden() // Hide the navigation link

            VStack {
                Spacer() // Push everything up
                HStack {
                    Spacer() // Push everything to the right
                    Button(action: {
                        Task {
                            await wViewModel.fetchPage() // Fetch data asynchronously
                            if let selectedId = pViewModel.selection?.id { // Safely unwrap the optional
                                    wViewModel.post.emdId = selectedId // Now this should work correctly
                                }
                            isNavigating = true // Set navigation flag to true after fetching
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                            .padding()
                    }
                    .padding(.bottom, 20) // Bottom padding
                    .padding(.trailing, 10) // Right padding
                }
            }
        }
    }
}
