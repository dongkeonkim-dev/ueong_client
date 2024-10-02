import SwiftUI

enum DropDownPickerState {
    case top
    case bottom
}

struct SelectRegion: View {
    @Binding var selection: MyVillage?
    var state: DropDownPickerState = .bottom
    var options: [MyVillage]
    var maxWidth: CGFloat
    
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
                    Spacer()
                    Text(selection?.name ?? "Select")
                        .font(.system(size: 20).weight(.bold))
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Image(systemName: state == .top ? "chevron.up" : "chevron.down")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees((showDropdown ? -180 : 0)))
                }
                .padding(.horizontal, 15)
                .frame(width: maxWidth, height: 50)
                .background(.white)
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
            .background(.white)
            .frame(height: size.height, alignment: state == .top ? .bottom : .top)
        }
        .frame(width: maxWidth, height: 50)
        .zIndex(zindex)
    }
    
    func OptionsView(options: [MyVillage], selection: Binding<MyVillage?>, maxWidth: CGFloat) -> some View {
        VStack(spacing: 0) {
            ForEach(options) { option in
                optionRow(option: option)
            }
        }
    }
    
    func optionRow(option: MyVillage) -> some View {
        HStack {
            Text(option.name)
                .font(.system(size: 20))
            Spacer()
            Image(systemName: "checkmark")
                .opacity(selection?.id == option.id ? 1 : 0)
        }
        .foregroundStyle(selection?.id == option.id ? Color.primary : Color.gray)
        .animation(.none, value: selection)
        .frame(height: 40)
        .contentShape(.rect)
        .padding(.horizontal, 15)
        .onTapGesture {
            withAnimation(.snappy) {
                selection = option
                showDropdown.toggle()
            }
        }
    }
    
}

#Preview {
    @Previewable @State var selectedVillage: MyVillage? = MyVillage()
    SelectRegion(selection: $selectedVillage, options: [MyVillage()], maxWidth: 130)
}
