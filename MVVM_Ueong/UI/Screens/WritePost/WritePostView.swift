import SwiftUI

struct WritePost: View {
    @ObservedObject var wViewModel: WritePost.ViewModel
    @ObservedObject var pViewModel: PostsList.ViewModel
    @FocusState private var isTitleFocused: Bool
    @FocusState private var isPriceFocused: Bool
    @FocusState private var isExplanationFocused: Bool
    @State private var showPicker: Bool = false

    var body: some View {
        ScrollView {
            VStack {
                HStack{
                    Button(action: {
                        showPicker.toggle()
                    }) {
                        Rectangle() // Rectangle으로 감싸기
                            .fill(Color.clear) // 배경 색상 투명으로 설정
                            .frame(width: 70, height: 70)
                            .cornerRadius(10)
                            .overlay(
                                VStack {
                                    Image(systemName: "photo")
                                        .font(.system(size: 20))
                                        .foregroundColor(.blue)
                                    Text("\(wViewModel.selectedImages.count)/10") // 선택된 이미지 수 표시
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                                .frame(width: 70, height: 70, alignment: .top) // 프레임 크기 및 정렬 조정
                                .padding(.top, 40)
                            )
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2))
                    }
                    .fullScreenCover(isPresented: $showPicker) {
                        MultiImagePicker(selectedImages: $wViewModel.selectedImages, isPresented: $showPicker)
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(wViewModel.selectedImages, id: \.self) { image in
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 70, height: 70)
                                        .clipped()
                                        .cornerRadius(10)

                                    // X 버튼 추가
                                    Button(action: {
                                        if let index = wViewModel.selectedImages.firstIndex(of: image) {
                                            wViewModel.selectedImages.remove(at: index) // 이미지 제거
                                        }
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.white) // 아이콘 색상
                                            .font(.system(size: 18)) // 아이콘 크기
                                            .background(Color.black) // 배경색을 검은색으로 설정
                                            .clipShape(Circle()) // 원형으로 자르기
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.black, lineWidth: 1) // 검은 테두리 추가
                                            )
                                            .frame(width:18, height: 18) // 버튼의 전체 크기 조정
                                            .offset(x: 4, y: -4) // 버튼 위치 조정
                                    }
                                }.frame(minHeight: 85)
                            }
                        }
                    }
                }
                .padding(.bottom, 10)
                .padding(.top, 20)

                // 제목 입력
                HStack {
                    VStack(alignment: .leading) {
                        Text("제목")
                        TextField("제목을 입력하세요.", text: $wViewModel.post.title)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .focused($isTitleFocused)
                    }
                    Spacer()
                }
                .padding(.top, 30)

                // 가격 입력
                HStack {
                    VStack(alignment: .leading) {
                        Text("가격")
                        HStack{
                            Text("₩") // 원화 기호
                                .font(.system(size: 20)) // 폰트 크기 설정
                                .padding(.leading, 3) // 원화 기호와 숫자 간의 간격
                            
                            TextField("가격을 입력하세요.", text: Binding(
                                get: {
                                    // 가격이 0일 경우 빈 문자열 반환
                                    if wViewModel.post.price == 0 {
                                        return ""
                                    }
                                    // 3자리마다 쉼표를 추가
                                    let formatter = NumberFormatter()
                                    formatter.numberStyle = .decimal
                                    return formatter.string(from: NSNumber(value: wViewModel.post.price)) ?? ""
                                },
                                set: {
                                    // 입력값이 빈 문자열일 경우 0으로 설정
                                    let cleanValue = $0.replacingOccurrences(of: ",", with: "") // 쉼표 제거
                                    if let value = Double(cleanValue) { // Double로 변환
                                        wViewModel.post.price = value // 저장
                                    } else if cleanValue.isEmpty {
                                        wViewModel.post.price = 0.0 // 비어있는 경우 0으로 설정 (Double)
                                    }
                                }
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .focused($isPriceFocused)
                        }
                        
                            
                        
                    }
                    Spacer()
                }
                .padding(.top, 30)

                // 설명 입력
                HStack {
                    VStack(alignment: .leading) {
                        Text("자세한 설명")
                        TextEditor(text: $wViewModel.post.text)
                            .frame(height: 150)
                            .focused($isExplanationFocused)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5) // 모서리 둥글게
                                    .stroke(Color.gray.opacity(0.16), lineWidth: 1) // 회색 테두리 추가
                            )
                    }
                    Spacer()
                }
                .padding(.top, 30)

                // 거래 희망 장소
                HStack {
                    VStack(alignment: .leading) {
                        Text("거래 희망 장소")
                        TextField("단월동", text: $wViewModel.post.locationDetail)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .focused($isPriceFocused)
                    }
                    Spacer()
                }
                .padding(.top, 30)
            }
            .padding(.horizontal, 20)
            .navigationBarTitle("내 물건 팔기", displayMode: .inline)
            Spacer()
            AddButton(wViewModel: wViewModel, pViewModel: pViewModel)
                .padding(.top, 20)
                .padding(.bottom, 20)
        }
    }
}


struct AddButton: View {
    @ObservedObject var wViewModel: WritePost.ViewModel
    @ObservedObject var pViewModel: PostsList.ViewModel
    @Environment(\.presentationMode) var presentationMode

    public var body: some View {
        VStack {
            Spacer()
            HStack {
                Button(action: {
                    Task {
                        print("AddButton clicked")
                        await wViewModel.uploadPost()
                        pViewModel.fetchPosts()
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("작성 완료")
                        .font(.system(size: 20).weight(.bold))
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12).fill(Color.blue)
                )
                .padding(.horizontal)
                .foregroundColor(Color.white)
            }
        }
    }
}

#Preview {
    WritePost(wViewModel: WritePost.ViewModel(village:MyVillage()), pViewModel: PostsList.ViewModel())
}
