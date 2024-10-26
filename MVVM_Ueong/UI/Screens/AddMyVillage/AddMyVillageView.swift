//
//  AddMyVillageView.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 10/14/24.
//

import SwiftUI

struct AddMyVillage: View {
    @ObservedObject var viewModel: AddMyVillage.ViewModel
    @ObservedObject var pViewModel: PostsList.ViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            // 검색 텍스트 필드
            TextField("사는 곳의 주소를 검색해주세요 : 예) 광안동", text: $viewModel.searchTerm)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onSubmit {
                    Task {
                        await viewModel.searchAddress() // 검색 실행
                    }
                }

            // 검색 결과 목록
            List(viewModel.addressList, id: \.id) { address in
                HStack {
                    Text(address.Address)
                    Spacer()
                    if viewModel.selectedAddress?.id == address.id {
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.selectedAddress = address // 주소 선택
                }
            }

            Spacer()

            // 저장 버튼
            Button("추가") {
                Task {
                    await viewModel.addMyVillage() // 동네 추가
                    presentationMode.wrappedValue.dismiss() // 모달 닫기
                    pViewModel.fetchVillageList()
                }
            }
            .disabled(viewModel.selectedAddress == nil) // 선택된 주소가 없으면 비활성화
            .padding()
            .frame(maxWidth: .infinity)
            .background(viewModel.selectedAddress == nil ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding()
        }
        .navigationTitle("내 동네 추가")
    }
}

#Preview {
    AddMyVillage(viewModel: AddMyVillage.ViewModel(), pViewModel:  PostsList.ViewModel())
}
