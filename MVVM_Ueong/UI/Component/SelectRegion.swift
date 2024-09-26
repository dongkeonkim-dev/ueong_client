import SwiftUI

struct SelectRegion: View {
    
    @State var selection1: String? = "단월동" // 초기값을 "단월동"으로 설정
    
    var body: some View {
        DropDownPicker(
            selection: $selection1,
            options: [
                "단월동",
                "구월동",
                "연수동",
                "신연수동",
                "Instagram"
            ],
            maxWidth: 130 // 원하는 넓이로 설정 (이 부분을 조정)
        )
    }
}

enum DropDownPickerState {
    case top
    case bottom
}

struct DropDownPicker: View {
    
    @Binding var selection: String?
    var state: DropDownPickerState = .bottom
    var options: [String]
    var maxWidth: CGFloat // maxWidth를 초기화할 때 설정
    
    @State var showDropdown = false
    @SceneStorage("drop_down_zindex") private var index = 1000.0
    @State var zindex = 1000.0
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            
            VStack(spacing: 0) {
                if state == .top && showDropdown {
                    OptionsView(options: options, selection: $selection, maxWidth: maxWidth)
                }
                
                HStack {
                    Spacer() // 왼쪽 여백을 만듭니다
                    Text(selection == nil ? "Select" : selection!)
                        .font(.system(size: 20).weight(.bold)) // 글씨 크기를 20으로 설정
                        .foregroundColor(.black) // 텍스트 색깔을 검은색으로 변경
                        .lineLimit(1) // 줄 수를 1로 제한
                        .truncationMode(.tail) // 끝에서 잘리는 방식 설정
                        .frame(maxWidth: .infinity, alignment: .center) // 가운데 정렬을 위한 설정
                    
                    Image(systemName: state == .top ? "chevron.up" : "chevron.down")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees((showDropdown ? -180 : 0)))
                }
                .padding(.horizontal, 15)
                .frame(width: maxWidth, height: 50) // maxWidth 사용
                .background(.white) // 배경색 설정
                .contentShape(.rect)
                .onTapGesture {
                    index += 1
                    zindex = index
                    withAnimation(.snappy) {
                        showDropdown.toggle()
                    }
                }
                .zIndex(10)
                
                if state == .bottom && showDropdown {
                    OptionsView(options: options, selection: $selection, maxWidth: maxWidth)
                }
            }
            .clipped()
            .background(.white) // 배경색 설정
            .frame(height: size.height, alignment: state == .top ? .bottom : .top)
        }
        .frame(width: maxWidth, height: 50)
        .zIndex(zindex)
    }
    
    func OptionsView(options: [String], selection: Binding<String?>, maxWidth: CGFloat) -> some View {
        VStack(spacing: 0) {
            ForEach(options, id: \.self) { option in
                HStack {
                    Text(option)
                        .font(.system(size: 20)) // 옵션 텍스트의 글씨 크기를 20으로 설정
                    Spacer()
                    Image(systemName: "checkmark")
                        .opacity(selection.wrappedValue == option ? 1 : 0)
                }
                .foregroundStyle(selection.wrappedValue == option ? Color.primary : Color.gray)
                .animation(.none, value: selection.wrappedValue)
                .frame(height: 40)
                .contentShape(.rect)
                .padding(.horizontal, 15)
                .onTapGesture {
                    withAnimation(.snappy) {
                        selection.wrappedValue = option
                        showDropdown.toggle()
                    }
                }
            }
        }
        .frame(width: maxWidth) // 드롭다운의 maxWidth를 사용하여 옵션 뷰의 넓이를 설정
        .transition(.move(edge: state == .top ? .bottom : .top))
        .zIndex(1)
    }
}

#Preview {
    SelectRegion()
}

