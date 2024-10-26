import SwiftUI
import MapKit

struct WritePost: View {
    @ObservedObject var pViewModel: PostsList.ViewModel
    @StateObject var wViewModel: WritePost.ViewModel
    
    init(pViewModel: PostsList.ViewModel) {
        self.pViewModel = pViewModel
        self._wViewModel = StateObject(wrappedValue: WritePost.ViewModel(emdId: pViewModel.selection?.id ?? 0))
    }

    @FocusState private var isTitleFocused: Bool
    @FocusState private var isPriceFocused: Bool
    @FocusState private var isExplanationFocused: Bool
    @State private var showPicker: Bool = false
    @State private var showCaptureView: Bool = false // MainCaptureView를 위한 상태 추가
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Button(action: {
                        showCaptureView.toggle() // MainCaptureView를 모달로 띄우기 위한 상태 변경
                    }) {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: 70, height: 70)
                            .cornerRadius(10)
                            .overlay(
                                VStack {
                                    Image(systemName: "arkit")
                                        .font(.system(size: 20))
                                        .foregroundColor(.blue)
                                    Text("\(0)/1")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                                .frame(width: 70, height: 70, alignment: .top)
                                .padding(.top, 40)
                            )
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .fullScreenCover(isPresented: $showCaptureView) { // MainCaptureView를 모달로 표시
                        MainCaptureView(onDismiss: {
                            showCaptureView = false // 캡처가 끝나면 모달 닫기
                        })
                    }

                    Button(action: {
                        showPicker.toggle()
                    }) {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: 70, height: 70)
                            .cornerRadius(10)
                            .overlay(
                                VStack {
                                    Image(systemName: "photo")
                                        .font(.system(size: 20))
                                        .foregroundColor(.blue)
                                    Text("\(wViewModel.selectedImages.count)/10")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                                .frame(width: 70, height: 70, alignment: .top)
                                .padding(.top, 40)
                            )
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2))
                    }
                    .fullScreenCover(isPresented: $showPicker) {
                        MultiImagePicker(selectedImages: $wViewModel.selectedImages, isPresented: $showPicker)
                    }

                    // 선택된 이미지 보여주기
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
                                            wViewModel.selectedImages.remove(at: index)
                                        }
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.white)
                                            .font(.system(size: 18))
                                            .background(Color.black)
                                            .clipShape(Circle())
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.black, lineWidth: 1)
                                            )
                                            .frame(width: 18, height: 18)
                                            .offset(x: 4, y: -4)
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
                        HStack {
                            Text("₩")
                                .font(.system(size: 20))
                                .padding(.leading, 3)
                            
                            TextField("가격을 입력하세요.", text: Binding(
                                get: {
                                    if wViewModel.post.price == 0 {
                                        return ""
                                    }
                                    let formatter = NumberFormatter()
                                    formatter.numberStyle = .decimal
                                    return formatter.string(from: NSNumber(value: wViewModel.post.price)) ?? ""
                                },
                                set: {
                                    let cleanValue = $0.replacingOccurrences(of: ",", with: "")
                                    if let value = Double(cleanValue) {
                                        wViewModel.post.price = value
                                    } else if cleanValue.isEmpty {
                                        wViewModel.post.price = 0.0
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
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray.opacity(0.16), lineWidth: 1)
                            )
                    }
                    Spacer()
                }
                .padding(.top, 30)

                // 거래 희망 장소
                HStack {
                    VStack(alignment: .leading) {
                        Text("거래 희망 장소")
                        NavigationLink(destination: SelectLocation(wViewModel: wViewModel)) {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.white)
                                .frame(height: 50)
                                .overlay(
                                    Text(wViewModel.post.locationDetail.isEmpty ? "위치를 선택하세요" : wViewModel.post.locationDetail)
                                        .foregroundColor(.black)
                                        .padding()
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                        }
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
                    Task { @MainActor in
                        print("AddButton clicked")
                        if let response = await wViewModel.uploadPost() {
                            print("Post uploaded successfully: \(response.message)")
                            presentationMode.wrappedValue.dismiss()
                            await pViewModel.fetchPosts()
                        } else {
                            print("Upload failed: No response received or an error occurred.")
                        }
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
    WritePost(pViewModel: PostsList.ViewModel())
}

