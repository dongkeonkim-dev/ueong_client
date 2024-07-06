
import SwiftUI
import MapKit
import LinkNavigator

struct ProductDetail: View {
    let product: Product
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 이미지 슬라이더
                TabView {
                    ForEach(product.imageNames, id: \.self) { imageName in
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width)
                            .clipped()
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(height: 350)
                
                //제목, 좋아요, 작성자, 채팅하기
                HStack {
                    VStack(alignment: .leading, spacing: 20){
                        HStack{
                            //제목
                            Text(product.name)
                                .font(.system(size: 28, weight: .bold))
                                .fontWeight(.bold)
                            
                            //좋아요
                            if product.isFavorite {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                            } else {
                                Image(systemName: "heart")
                                    .foregroundColor(.red)
                            }
                        }
                        
                        //가격
                        Text("가격: ₩\(product.price)")
                            .font(.system(size: 21, weight: .semibold))
                            .padding(.top, 1)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    VStack {
                        Text("작성자: \(product.writer)")
                            .font(.system(size: 15, weight: .thin))
                            .padding(.top, 5)
                        
                        Button(action: {
                            // 대화하기 버튼 클릭 시 실행할 코드
                        }) {
                            HStack{
                                Text("채팅하기")
                                //Image(systemName: "bubble.right").font(.system(size: 14))
                            }.font(.title3)
                                .padding(10)
                                .foregroundColor(.white)
                                .background(.blue)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 5)
                
                
                //본문
                Text(product.description)
                    .font(.body)
                    .padding(.top, 5)
                    .padding(.horizontal)
                
                //지도
                Map(initialPosition: .region(MKCoordinateRegion(center: product.location, span: (MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))))) {
                    Marker(product.name, coordinate: product.location)
                        .tint(.blue)
                }
                .frame(height: 200)
                .cornerRadius(10)
                .padding(.top,5)
            }
        }
    }
}

//
//// Preview Provider
//struct Product_Detail_View_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductDetailView(product: productSamples[1])
//    }
//}
