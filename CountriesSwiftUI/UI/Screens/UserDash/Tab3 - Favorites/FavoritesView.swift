//import LinkNavigator
//import SwiftUI
//
//struct FavoritesView: View {
//
//    let navigator: LinkNavigatorType
//
//  var body: some View {
//    VStack(spacing: 16) {
//        
//        HStack(){
//            Text("관심상품")
//                .font(.system(size: 25).weight(.bold))
//            Spacer()
//        }
//        .padding(.horizontal, 20)
//        
//        ScrollView(){
//            VStack(){
//                Button(action: {navigator.next(paths: ["productDetail"], items: [:], isAnimated: true)})
//                {
//                    ProductRow(product: productSamples[1])
//                }
//                
//                Button(action: {navigator.next(paths: ["productDetail"], items: [:], isAnimated: true)})
//                {
//                    ProductRow(product: productSamples[1])
//                }
//                
//                Button(action: {navigator.next(paths: ["productDetail"], items: [:], isAnimated: true)})
//                {
//                    ProductRow(product: productSamples[1])
//                }
//                
//                Button(action: {navigator.next(paths: ["productDetail"], items: [:], isAnimated: true)})
//                {
//                    ProductRow(product: productSamples[1])
//                }
//                
//            }
//                
//        }
//    
//    }
//    
//  }
//}
//
