import LinkNavigator
import SwiftUI

struct SoldView: View {
    let navigator: LinkNavigatorType
    var body: some View {
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
    }
}

