import LinkNavigator
import SwiftUI

struct ForSalesView: View {
    let navigator: LinkNavigatorType
    var body: some View {
        ScrollView(){
            VStack(){
                Button(action: {navigator.next(paths: ["productDetail"], items: [:], isAnimated: true)})
                {
                    ProductRow(product: productSamples[1])
                }
                
                Button(action: {navigator.next(paths: ["productDetail"], items: [:], isAnimated: true)})
                {
                    ProductRow(product: productSamples[1])
                }
                
                Button(action: {navigator.next(paths: ["productDetail"], items: [:], isAnimated: true)})
                {
                    ProductRow(product: productSamples[1])
                }
                
                Button(action: {navigator.next(paths: ["productDetail"], items: [:], isAnimated: true)})
                {
                    ProductRow(product: productSamples[1])
                }
                
            }
                
        }
    }
}
