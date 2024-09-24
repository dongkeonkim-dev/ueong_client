//
//  ProductsList.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//

import SwiftUI

struct ProductsList: View {
    @ObservedObject var viewModel: ProductsList.ViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.products) { product in
                Text("\(product.name) - \(product.price, specifier: "%.2f")원")
            }
            .navigationTitle("홈")
        }
    }
}

#Preview {
    ProductsList(viewModel: ProductsList.ViewModel())
}
