

import SwiftUI
import UIKit
import ARKit
import RealityKit
import QuickLook // QuickLook 프레임워크 임포트


enum FocusField: Hashable {
  case title
  case price
  case explanation
}

struct WritePost: View {
  @StateObject var wViewModel: ViewModel
  @Environment(\.dismiss) var dismiss  // 수정된 부분
  var addPostRow: (Post) -> Void
  var refreshPostsList: () -> Void
  
  init(
    emdId: Int?,
    postId: Int?,
    addPostRow: @escaping (Post) -> Void,
    refreshPostsList: @escaping () -> Void
  ) {
    self.addPostRow = addPostRow
    self.refreshPostsList = refreshPostsList
    self._wViewModel = StateObject(wrappedValue: ViewModel(
      emdId: emdId,
      postId: postId,
      addPostRow: addPostRow,
      refreshPostsList: refreshPostsList
    ))
  }
  
  @FocusState private var focusField: FocusField?
  @State private var showPicker: Bool = false
  @State private var showCaptureView: Bool = false
    
// -------------------------------------------------------------------------------------------------------
  
    // MARK: - Body
  var body: some View {
    ScrollView {
      VStack {
        HStack {
          ArkitButton(showCaptureView: $showCaptureView, wViewModel: wViewModel)
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
      confirmButton
    }
    .padding(.vertical, 20)
  }
  

  
// -------------------------------------------------------------------------------------------------------

  // MARK: - Confirm Button
  private var confirmButton: some View {
    HStack {
      Button(action: {
        Task {
          await handlePostUpload()
        }
      }) {
        Text("작성 완료")
          .font(.system(size: 20).weight(.bold))
          .frame(maxWidth: .infinity)
          .padding()
          .background(RoundedRectangle(cornerRadius: 12).fill(Color.blue))
          .foregroundColor(.white)
      }
      .padding(.horizontal)
    }
  }
    
// -------------------------------------------------------------------------------------------------------

  // MARK: - Post Upload Handling
  private func handlePostUpload() async {
    print("ConfirmButton clicked")
    if let response = await wViewModel.uploadPost() {
      print("Post uploaded successfully: upload ID \(response)")
      dismiss()                   // 수정된 부분
      refreshPostsList()
    } else {
      print("Upload failed: No response received or an error occurred.")
    }
  }
  
}

// -------------------------------------------------------------------------------------------------------

// 기존 ArkitButton에 파일 선택 버튼 추가
// MARK: - Arkit Button
struct ArkitButton: View {
@Binding var showCaptureView: Bool
@State private var showModelOptions = false
@State private var showDocumentPicker = false // State variable to trigger document picker
@ObservedObject var wViewModel: WritePost.ViewModel // Observing the ViewModel

var body: some View {
    VStack {
        Button(action: {
            showModelOptions.toggle()
        }) {
            ButtonShapePicker(
                systemImageName: "arkit",
                count: wViewModel.selectedARFile == nil ? 0 : 1, // Update count based on selection
                maxCount: 1
            )
        }
        .buttonStyle(PlainButtonStyle())
        .confirmationDialog("모델 선택하기", isPresented: $showModelOptions) {
            Button("모델 생성하기") {
                showCaptureView = true
            }
            Button("모델 선택하기") {
                showDocumentPicker = true // Trigger the document picker for "Select Model"
            }
            Button("취소", role: .cancel) {
                showModelOptions = false
            }
        } message: {
        
        }
        .fullScreenCover(isPresented: $showCaptureView) {
            MainCaptureView(onDismiss: {
                showCaptureView = false
            })
        }
        .sheet(isPresented: $showDocumentPicker) {
            CustomDocumentPickerView { url in
                // Update selected AR file
                Task{
                    await wViewModel.addSelectedARFile(url) // Store the selected file URL
                }
                showDocumentPicker = false // Close the document picker
            }
        }

    }
}
}



  // MARK: - Photo Picker Button
struct PhotoPickerButton: View {
  @Binding var showPicker: Bool
  @ObservedObject var wViewModel: WritePost.ViewModel
  var maxCount: Int = 10
  
  var body: some View {
    Button(action: {
      if wViewModel.selectedPhotos.count < maxCount {
        showPicker.toggle()
      }
    }) {
      ButtonShapePicker(
        systemImageName: "photo",
        count: wViewModel.selectedPhotos.count,
        maxCount: maxCount
      )
    }
    .fullScreenCover(isPresented: $showPicker) {
      MultiImagePicker(
        onImagesPicked: { images in
          Task{
            await wViewModel.addSelectedImages(images)
          }
        },
        selectedImageCounts: wViewModel.selectedPhotos.count,
        isPresented: $showPicker
      )
    }
  }
}

// -------------------------------------------------------------------------------------------------------

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

// -------------------------------------------------------------------------------------------------------

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
          .focused(focusField, equals: .title) // 특정 필드에 포커스
          .textFieldStyle(PlainTextFieldStyle())
          .padding(7)
          .overlay(
            RoundedRectangle(cornerRadius: 5)
              .stroke((Color.gray.opacity(0.5)), lineWidth: 1.5)  // 테두리 두께 1.5로 설정
          )
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
          .focused(focusField, equals: .price) // 특정 필드에 포커스
          .textFieldStyle(PlainTextFieldStyle())
          .padding(7)
          .overlay(
            RoundedRectangle(cornerRadius: 5)
              .stroke((Color.gray.opacity(0.5)), lineWidth: 1.5)  // 테두리 두께 1.5로 설정
          )
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
              .stroke(Color.gray.opacity(0.5), lineWidth: 1)
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
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
        }
      }
      Spacer()
    }
  }
}


//---------------------------------------------------------------------------------------------

struct CustomDocumentPickerView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    var onFilePicked: (URL) -> Void

    func makeUIViewController(context: Context) -> CustomDocumentPickerViewController {
        let viewController = CustomDocumentPickerViewController()
        viewController.onFilePicked = { url in
            onFilePicked(url)
            presentationMode.wrappedValue.dismiss()
        }
        return viewController
    }

    func updateUIViewController(_ uiViewController: CustomDocumentPickerViewController, context: Context) {}
}

class CustomDocumentPickerViewController: UIViewController {
    var onFilePicked: ((URL) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // 배경 색상
        view.backgroundColor = .white
        
        // UIDocumentPickerViewController 설정
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.usdz], asCopy: true)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .fullScreen // 전체 화면 모드 설정

        // 화면의 절반 크기로 문서 선택기 표시
        addChild(documentPicker)
        view.addSubview(documentPicker.view)

        // Autolayout으로 문서 선택기의 크기 및 위치 설정
        documentPicker.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            documentPicker.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            documentPicker.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            documentPicker.view.topAnchor.constraint(equalTo: view.topAnchor),
            documentPicker.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1) // 화면의 절반 차지
        ])
        documentPicker.didMove(toParent: self)
    }
}

// MARK: - UIDocumentPickerDelegate
extension CustomDocumentPickerViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let url = urls.first {
            onFilePicked?(url)
        }
        dismiss(animated: true, completion: nil)
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
}

#Preview {
  WritePost(emdId: 1, postId: 1, addPostRow: {_ in}, refreshPostsList: {})
}



// Display selected AR file if available
//            if let selectedARFile = wViewModel.selectedARFile {
//                HStack {
//                    Text("선택한 AR 파일:")
//                    Text(selectedARFile.lastPathComponent) // Show the file name
//                        .foregroundColor(.blue)
//                        .lineLimit(1)
//                        .truncationMode(.tail)
//
//                    Button(action: {
//                        wViewModel.selectedARFile = nil // Clear selection
//                    }) {
//                        Image(systemName: "xmark.circle.fill")
//                            .foregroundColor(.red)
//                    }
//                }
//                .padding(.top, 5)
//            }





// MARK: - Header Buttons
//  private var headerButtons: some View { // 수정된 부분
//    HStack {
//      ArkitButton(showCaptureView: $showCaptureView, wViewModel: wViewModel) // 서브뷰 인스턴스화
//      PhotoPickerButton(showPicker: $showPicker, wViewModel: wViewModel) // 서브뷰 인스턴스화
//      PhotoIndicator(wViewModel: wViewModel) // 서브뷰 인스턴스화
//    }
//    .padding(.vertical, 10)
//  }


// MARK: - Confirm Button
//struct ConfirmButton: View {
//  @ObservedObject var wViewModel: WritePost.ViewModel
//  var refreshPostList: () -> Void = {}
//
//  @Environment(\.presentationMode) var presentationMode
//
//  public var body: some View {
//    VStack {
//      Spacer()
//      HStack {
//        Button(action: {
//            print("12343214234")
//          Task { @MainActor in
//            print("ConfirmButton clicked")
//            if let response = await wViewModel.uploadPost() {
//              print("Post uploaded successfully: upload ID \(response)")
//              presentationMode.wrappedValue.dismiss()
//              refreshPostList()
//
//            } else {
//              print("Upload failed: No response received or an error occurred.")
//            }
//          }
//        }) {
//          Text("작성 완료")
//            .font(.system(size: 20).weight(.bold))
//            .frame(maxWidth: .infinity)
//        }
//        .padding()
//        .frame(maxWidth: .infinity)
//        .background(
//          RoundedRectangle(cornerRadius: 12).fill(Color.blue)
//        )
//        .padding(.horizontal)
//        .foregroundColor(Color.white)
//      }
//    }
//  }
//}


//// MARK: - Title Input
//private var titleInput: some View {
//TitleInputField(
//  focusField: $focusField,
//  title: $wViewModel.post.title
//)
//}
//
//// MARK: - Price Input
//private var priceInput: some View {
//PriceInputField(
//  focusField: $focusField,
//  price: $wViewModel.post.price
//)
//.padding(.top, 30)
//}
//
//// MARK: - Description Input
//private var descriptionInput: some View {
//DescriptionInputField(
//  focusField: $focusField,
//  text: $wViewModel.post.text
//)
//.padding(.top, 30)
//}
//
//// MARK: - Location Selection
//private var locationSelection: some View {
//LocationSelection(wViewModel: wViewModel)
//  .padding(.top, 30)
//}
