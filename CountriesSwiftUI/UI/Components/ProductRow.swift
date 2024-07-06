import SwiftUI
import LinkNavigator

struct ProductRow: View {
    let product: Product
    
    var body: some View {
       
            HStack {
                productImage
                productDescription
            }
            .frame(height:150)
            .background(Color.primary.colorInvert())
            .cornerRadius(6)
            .shadow(color: Color.primaryShadow, radius: 1, x: 2, y: 2)
            .padding(.horizontal, 8)
        
        
    }
}

private extension ProductRow {
    var productImage: some View {
        Image(product.imageNames[0])
            .resizable()
            .scaledToFill()
            .frame(width: 140)
            .clipped()
    }
    
    
    var productDescription: some View {
        VStack(alignment: .leading) {
            Text(product.name)
                .font(.headline)
                .foregroundStyle(Color.black)
                .fontWeight(.medium)
                .padding(.bottom, 6)
            
            Text(product.description)
                .font(.footnote)
                .foregroundColor(.secondaryText)
            
            Spacer()
            footerView
            
        }
        .padding([.leading, .bottom], 12)
        .padding([.top, .trailing])
    }
    
    var footerView: some View {
        HStack(spacing: 0) {
            Text("₩").font(.footnote)
                .foregroundStyle(Color.black)
                + Text("\(product.price)").font(.headline)
                .foregroundStyle(Color.black)
            
            Spacer()
            
            if product.isFavorite {
                Image(systemName: "heart.fill")
                    .foregroundColor(Color.blue) // 돋보기 아이콘의 색상을 파란색으로 변경
                    .frame(width: 32, height: 32)
            }else {
                Image(systemName: "heart")
                    .foregroundColor(Color.blue) // 돋보기 아이콘의 색상을 파란색으로 변경
                    .frame(width: 32, height: 32)
            }
            
            Image(systemName: "message")
                .foregroundColor(.blue) // 돋보기 아이콘의 색상을 파란색으로 변경
                .frame(width: 32, height: 32)
        }
    }
}
