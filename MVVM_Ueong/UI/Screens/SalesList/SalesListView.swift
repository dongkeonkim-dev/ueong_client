////
////  SalesListView.swift
////  MVVM_Ueong
////
////  Created by 김동건 on 9/25/24.
////
//import SwiftUI
//
//struct SalesListView: View {
//    @ObservedObject var viewModel: SalesListView.ViewModel
//    @State private var selectedTab = 0
//
//    var body: some View {
//        VStack {
//            HStack {
//                Text("판매목록")
//                    .font(.system(size: 25).weight(.bold))
//                Spacer()
//            }
//            .padding(.horizontal, 20)
//
//            UpperTabBar(selectedTab: $selectedTab)
//            
//            ZStack {
//                ForSalesView(viewModel: viewModel)
//                    .offset(x: selectedTab == 0 ? 0 : -UIScreen.main.bounds.width) // Slide to left if selected tab is 0
//
//                SoldView(viewModel: viewModel)
//                    .offset(x: selectedTab == 1 ? 0 : UIScreen.main.bounds.width) // Slide to right if selected tab is 1
//            }
//            .animation(.easeInOut, value: selectedTab)
//        }
//    }
//}
//
//struct UpperTabBar: View {
//    @Binding var selectedTab: Int
//
//    var body: some View {
//        VStack {
//            HStack {
//                TabBarButton(title: "판매중", index: 0, selectedTab: $selectedTab)
//                    .frame(maxWidth: .infinity)
//                TabBarButton(title: "판매완료", index: 1, selectedTab: $selectedTab)
//                    .frame(maxWidth: .infinity)
//            }
//            .padding()
//            Rectangle()
//                .frame(width: UIScreen.main.bounds.width / 2, height: 2)
//                .foregroundColor(Color.blue)
//                .offset(x: UIScreen.main.bounds.width / 4 * CGFloat(selectedTab == 0 ? -1 : 1), y: 0)
//                .animation(.easeInOut, value: selectedTab)
//        }
//    }
//
//}
//
//struct TabBarButton: View {
//    let title: String
//    let index: Int
//    @Binding var selectedTab: Int
//
//    var body: some View {
//        Button(action: {
//            self.selectedTab = self.index
//        }) {
//            Text(title)
//                .foregroundColor(self.selectedTab == index ? .black : .gray)
//                .padding()
//        }
//    }
//}
//
//struct ForSalesView: View {
//    @ObservedObject var viewModel: SalesListView.ViewModel
//    var body: some View {
//        ScrollView {
//            NavigationView(){
//                VStack {
//                    ForEach(viewModel.postsForSale) { post in
//                        NavigationLink(PostDetailView())
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
//
//
//
//struct SoldView: View {
//    @ObservedObject var viewModel: SalesListView.ViewModel
//    var body: some View {
//        ScrollView {
//            VStack {
//                ForEach(viewModel.postSold) { product in
//                    Button(action: { viewModel.navigateToPostDetail(post) }) {
//                        PostRow(post: post)
//                    }
//                }
//            }
//        }
//    }
//}
//
//
//#Preview {
//    SalesListView(viewModel: SalesListView.ViewModel())
//}
//
