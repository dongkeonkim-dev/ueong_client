import SwiftUI
import MapKit

enum FocusField: Hashable {
  case title
  case price
  case explanation
}

struct WritePost: View {
  @StateObject var wViewModel: WritePost.ViewModel
  var refreshPostsList: () -> Void
  
  init(
    emdId: Int?,
    postId: Int?,
    refreshPostsList: () -> Void = refreshPostsList
    //Cannot use instance member 'refreshPostsList' as a default parameter
  ) {
    self._wViewModel = StateObject(wrappedValue: WritePost.ViewModel(
      emdId: emdId,
      postId: postId,
      refreshPostsList: refreshPostsList
    ))
  }
  
  @FocusState private var focusField: FocusField?
  @State private var showPicker: Bool = false
  
  var body: some View {
    ScrollView {
      VStack {
        HStack {
          ArkitButton()
          PhotoPickerButton(showPicker: $showPicker, wViewModel: wViewModel)
          PhotoIndicator(wViewModel: wViewModel)
        }
        .padding(.bottom, 10)
        .padding(.top, 20)
        
          // 제목 입력
        TitleInputField(
          focusField: $focusField,
          title: $wViewModel.post.title)
          
        
          // 가격 입력
        PriceInputField(
          focusField: $focusField,
          price: $wViewModel.post.price)
          .padding(.top, 30)
        
          // 설명 입력
        DescriptionInputField(
          focusField: $focusField,
          text: $wViewModel.post.text)
          .padding(.top, 30)
        
          // 거래 희망 장소
        LocationSelection(wViewModel: wViewModel)
          .padding(.top, 30)
      }
      .padding(.horizontal, 20)
      .navigationBarTitle("내 물건 팔기", displayMode: .inline)
      Spacer()
      
      ConfirmButton(
        wViewModel: wViewModel,
        refreshPostList: refreshPostsList
      )
        .padding(.top, 20)
        .padding(.bottom, 20)
    }
  }
}

  // MARK: - Arkit Button
struct ArkitButton: View {
  var body: some View {
    Button(action: {
        // showPicker.toggle()
    }) {
      ButtonShapePicker(
        systemImageName: "arkit",
        count: 0,
        maxCount: 1
      )
    }
  }
}

  // MARK: - Photo Picker Button
struct PhotoPickerButton: View {
  @Binding var showPicker: Bool
  @ObservedObject var wViewModel: WritePost.ViewModel
  
  var body: some View {
    Button(action: {
      showPicker.toggle()
    }) {
      ButtonShapePicker(
        systemImageName: "photo",
        count: wViewModel.selectedPhotos.count,
        maxCount: 10
      )
    }
    .fullScreenCover(isPresented: $showPicker) {
      MultiImagePicker(
        onImagesPicked: { images in
          Task{
            await wViewModel.addSelectedImages(images)
          }
        },
        isPresented: $showPicker
      )
    }
  }
}

//MARK: - ButtonShape
struct ButtonShapePicker: View {
  var systemImageName: String
  var count: Int
  var maxCount: Int
  var imageColor: Color = .blue
  var strokeColor: Color = .blue
  var frameWidth: CGFloat = 70
  var frameHeight: CGFloat = 70
  var cornerRadius: CGFloat = 10
  var paddingTop: CGFloat = 40
  
  var body: some View {
    Rectangle()
      .fill(Color.clear)
      .frame(width: frameWidth, height: frameHeight)
      .cornerRadius(cornerRadius)
      .overlay(
        VStack {
          Image(systemName: systemImageName)
            .font(.system(size: 20))
            .foregroundColor(imageColor)
          Text("\(count)/\(maxCount)")
            .font(.caption)
            .foregroundColor(imageColor)
        }
          .frame(width: frameWidth, height: frameHeight, alignment: .top)
          .padding(.top, paddingTop)
      )
      .overlay(
        RoundedRectangle(cornerRadius: cornerRadius)
          .stroke(strokeColor, lineWidth: 2)
      )
  }
}
  // MARK: - Photo Indicator
struct PhotoIndicator: View {
  @ObservedObject var wViewModel : WritePost.ViewModel
  
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack {
        ForEach($wViewModel.selectedPhotos, id: \.self.id) { photo in
          ZStack(alignment: .topTrailing) {
            let url = URL(string: baseURL.joinPath(photo.url.wrappedValue))
            
            AsyncImage(url: url) { phase in
              
              switch phase {
                case .empty:
                  ProgressView()
                    .frame(width: 70, height: 70)
                case .success(let image):
                  image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .clipped()
                    .cornerRadius(10)
                case .failure:
                  Image(systemName:"exclamationmark.square")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .foregroundColor(.red)
                @unknown default:
                  EmptyView()
              }
            }
            
              // X 버튼 추가
            Button(action: {
              if let index = wViewModel.selectedPhotos.firstIndex(where: { $0.id == photo.id.wrappedValue }) {
                Task{
                  await wViewModel.deleteImage(photoId: photo.id.wrappedValue) // 이미지 제거
                }
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
}

// MARK: - Delete Photo Button

  // MARK: - Title Input Field
struct TitleInputField: View {
  var focusField: FocusState<FocusField?>.Binding
  @Binding var title: String
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text("제목")
        TextField("제목을 입력하세요.", text: $title)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .focused(focusField, equals: .title) // 특정 필드에 포커스
      }
      Spacer()
    }
    .padding(.top, 30)
  }
}

  // MARK: - Price Input Field
struct PriceInputField: View {
  var focusField: FocusState<FocusField?>.Binding
  @Binding var price: Double
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text("가격")
        HStack {
          Text("₩")
            .font(.system(size: 20))
            .padding(.leading, 3)
          
          TextField("가격을 입력하세요.", text: Binding(
            get: {
              if price == 0 {
                return ""
              }
              let formatter = NumberFormatter()
              formatter.numberStyle = .decimal
              return formatter.string(from: NSNumber(value: price)) ?? ""
            },
            set: {
              let cleanValue = $0.replacingOccurrences(of: ",", with: "")
              if let value = Double(cleanValue) {
                price = value
              } else if cleanValue.isEmpty {
                price = 0.0
              }
            }
          ))
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .focused(focusField, equals: .price) // 특정 필드에 포커스
        }
      }
      Spacer()
    }
  }
}

  // MARK: - Description Input Field
struct DescriptionInputField: View {
  var focusField: FocusState<FocusField?>.Binding
  @Binding var text: String
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text("자세한 설명")
        TextEditor(text: $text)
          .frame(height: 150)
          .focused(focusField, equals: .explanation) // 특정 필드에 포커스
          .overlay(
            RoundedRectangle(cornerRadius: 5)
              .stroke(Color.gray.opacity(0.16), lineWidth: 1)
          )
      }
      Spacer()
    }
  }
}

  // MARK: - Location Selection
struct LocationSelection: View {
  @ObservedObject var wViewModel: WritePost.ViewModel
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text("거래 희망 장소")
        NavigationLink(
          destination: SelectLocation(wViewModel: wViewModel)
        ) {
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
  }
}

  // MARK: - Confirm Button
struct ConfirmButton: View {
  @ObservedObject var wViewModel: WritePost.ViewModel
  var refreshPostList: () -> Void = {}
  
  @Environment(\.presentationMode) var presentationMode
  
  public var body: some View {
    VStack {
      Spacer()
      HStack {
        Button(action: {
          Task { @MainActor in
            print("ConfirmButton clicked")
            if let response = await wViewModel.uploadPost() {
              print("Post uploaded successfully: upload ID \(response)")
              presentationMode.wrappedValue.dismiss()
              refreshPostList()
              
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
  WritePost(emdId: 1, postId: 1)
}

