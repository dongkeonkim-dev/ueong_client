//
//  ProductDetailPage.swift
//  UItest
//
//  Created by 김석원 on 5/14/24.
//

import SwiftUI
import LinkNavigator

struct ProductDetailPage: View {
    let navigator: LinkNavigatorType
    var body: some View {
        
        ProductDetail(product: productSamples[0])
            .navigationBarHidden(false)
            .navigationBarTitle("", displayMode: .inline)
    }
    
}

