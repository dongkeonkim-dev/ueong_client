import LinkNavigator
import SwiftUI

struct BoardView: View {
    let navigator: LinkNavigatorType
    @State private var showingVillageList = false
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack(spacing: 30) {
            
            HStack(spacing: -5){
                Button(action: {
                    showingVillageList = true
                }) {
                    HStack {
                        Text("단월동")
                            .font(.system(size: 20).weight(.bold))
                        Image(systemName: "chevron.down")
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                    }
                }
                
                SearchBarButton(navigator: navigator)
                
                Image(systemName: "bell")
                    .foregroundColor(.black)
                    .font(.system(size: 25))
            }
            .padding(.horizontal, 20)
            
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
                    Text("AR")
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                }
                .background(
                    RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.3))
                )
                
                Button(action:{}){
                    Text("가격순")
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                }
                .background(
                    RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.3))
                )
                
                Button(action:{}){
                    Text("관심순")
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                }
                .background(
                    RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.3))
                )
                
                Spacer()
            }
            
            .padding(.horizontal, 20)
            
                
            ScrollView(){
                VStack(){
                    Button(action: {navigator.next(paths: ["productDetail"], items: [:], isAnimated: true)})
                    {
                        ProductRow(product: productSamples[0])
                    }
                    
                    Button(action: {navigator.next(paths: ["productDetail"], items: [:], isAnimated: true)})
                    {
                        ProductRow(product: productSamples[0])
                    }
                    
                    Button(action: {navigator.next(paths: ["productDetail"], items: [:], isAnimated: true)})
                    {
                        ProductRow(product: productSamples[0])
                    }
                    
                    Button(action: {navigator.next(paths: ["productDetail"], items: [:], isAnimated: true)})
                    {
                        ProductRow(product: productSamples[0])
                    }
                    
                }
                    
            }
            .overlay(
                AddProduct(navigator: navigator)
            )
        }
        .sheet(isPresented: $showingVillageList) {
            MyVillageListView()
                .environmentObject(authViewModel)
        }
    }
}

struct SearchBarButton: View {
    let navigator: LinkNavigatorType
    public var body: some View {
        VStack(spacing: 15) {
            Button(action: {
                navigator.next(paths: ["search"], items: [:], isAnimated: true)
                
            })
            {
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

struct AddProduct: View {
    let navigator: LinkNavigatorType
    public var body: some View {
        VStack(){
            Spacer()
            HStack(){
                Spacer()
                Button(action: {
                    navigator.next(paths: ["addProduct"], items: [:], isAnimated: true)
                })
                {
                    Image(systemName: "plus")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .clipShape(Circle())
                }
                .padding(.bottom, 20) // 하단에 패딩 추가
                .padding(.trailing, 20) // 오른쪽에 패딩 추가
            }
        }
    }
}
