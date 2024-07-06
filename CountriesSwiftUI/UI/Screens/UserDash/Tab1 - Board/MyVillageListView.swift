//// Views/MyVillageListView.swift
//import SwiftUI
//
//struct MyVillageListView: View {
//    @StateObject private var viewModel = MyVillageViewModel()
//    @EnvironmentObject var authViewModel: AuthViewModel
//
//    var body: some View {
//        NavigationView {
//            List(viewModel.myVillages, id: \.emdId) { myVillage in
//                Text("마을 이름: \(myVillage.emdName)")
//            }
//            .navigationTitle("~~동")//selected village
//            .onAppear {
//                viewModel.fetchMyVillages()
//            }
//        }
//    }
//}
