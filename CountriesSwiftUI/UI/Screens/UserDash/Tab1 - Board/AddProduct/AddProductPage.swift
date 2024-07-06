import SwiftUI
import LinkNavigator

struct AddProductPage: View {
    let navigator: LinkNavigatorType
    @State private var title: String = "" // 제목을 저장할 변수
    @State private var price: String = "" //형변환 필요
    @State private var explanation: String = ""
    @FocusState private var isTitleFocused: Bool
    @FocusState private var isPriceFocused: Bool
    @FocusState private var isExplanationFocused: Bool

    var body: some View {
        
        ScrollView(){
            VStack {
            //---------------------------------------------------------------------------------------
                // 사진 추가 버튼 클릭시 사진을 선택하는 화면으로 너어가야하고 사용자에게 사진 접근 동의를 받아야함
                // 사진이 추가되면 레이아웃이 변화해야 함: 추가한 사진이 보이고 사진을 더 추가할 수 있는 버튼
                // AR 모델링 추가 기능도 필요
                HStack() {
                    Button(action: {}) {
                        HStack(alignment: .top) {
                            Image(systemName: "camera")
                                .font(.system(size: 30))
                                .foregroundColor(.blue) // 버튼 내부 내용의 색상을 파란색으로 설정
                                .frame(width: 70, height: 70) // 버튼의 높이와 너비를 지정하여 정사각형 모양으로 만듦
                                .background(Color.clear) // 배경을 투명하게 설정
                                .cornerRadius(10) // 버튼의 모서리를 둥글게 처리
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2)) // 모서리 부분에 파란색 테두리 추가
                        }
                    }
                    Spacer()
                }
                .padding(.top, 30)
                
            //---------------------------------------------------------------------------------------
                
                HStack() {
                    VStack(alignment: .leading) {
                        
                        Text("제목")
                        TextField("제목을 입력하세요", text: $title)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(
                                RoundedRectangle(cornerRadius: 2) // 테두리의 모양을 지정
                                    .stroke(isTitleFocused ? Color.black : Color.gray.opacity(0.5), lineWidth: 1)
                            )
                            .padding(.horizontal, 10)
                            .padding(.leading, -10)
                            .focused($isTitleFocused)
                    }
                    Spacer()
                }
                .padding(.top, 30)
                
            //---------------------------------------------------------------------------------------
                // 추후에 숫자를 int 형으로 형변환할 필요가 있음. 가격을 받는
                // 7번째줄 @State private var price: String = "" 이 코드도 수정 필요
                HStack() {
                    VStack(alignment: .leading) {
                        
                        Text("가격")
                        TextField("가격을 입력하세요", text: $price)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad) // 숫자만 입력할 수 있도록 설정
                            .overlay(
                                RoundedRectangle(cornerRadius: 2) // 테두리의 모양을 지정
                                    .stroke(isPriceFocused ? Color.black : Color.gray.opacity(0.5), lineWidth: 1)
                            )
                            .padding(.horizontal, 10)
                            .padding(.leading, -10)
                            .focused($isPriceFocused)
                    }
                    Spacer()
                }
                .padding(.top, 30)
                
            //---------------------------------------------------------------------------------------
                // 텍스트의 길이가 텍스트필드의 길이를 넘어가면 자동으로 다음줄로 넘어가는 기능 필요
                // 플레이스홀더가 위쪽으로 정렬되게 해야 함
                HStack() {
                    VStack(alignment: .leading) {
                        
                        Text("자세한 설명")
                        TextField("게시글 내용을 작서해 주세요\n 신뢰할 수 있는 거래를 위해 자세히 적어주세요", text: $explanation)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(height: 250)
                            .overlay(
                                RoundedRectangle(cornerRadius: 2) // 테두리의 모양을 지정
                                    .stroke(isExplanationFocused ? Color.black : Color.gray.opacity(0.5), lineWidth: 1)
                            )
                            .padding(.horizontal, 10)
                            .padding(.leading, -10)
                            .focused($isExplanationFocused)
                        
                        
                    }
                    Spacer()
                }
                .padding(.top, 30)
                
            //---------------------------------------------------------------------------------------
                
                //거래희망장소 추가
                HStack() {
                    VStack(alignment: .leading) {
                        
                        Text("거래 희망 장소")
                        TextField("단월동", text: $price)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad) // 숫자만 입력할 수 있도록 설정
                            .overlay(
                                RoundedRectangle(cornerRadius: 2) // 테두리의 모양을 지정
                                    .stroke(isPriceFocused ? Color.black : Color.gray.opacity(0.5), lineWidth: 1)
                            )
                            .padding(.horizontal, 10)
                            .padding(.leading, -10)
                            .focused($isPriceFocused)
                    }
                    Spacer()
                }
                .padding(.top, 30)
                
                
            //---------------------------------------------------------------------------------------

                
                
            }
            // 네이게이션 뒤로가기 명 변경 현재 "root"로 표기되는 것을 "back"으로 변경 필요
            .padding(.leading, 20)
            .navigationBarHidden(false)
            .navigationBarTitle("내 물건 팔기", displayMode: .inline)
            Spacer()
        }
        .overlay(
            AddButton(navigator: navigator)
        )
    }
}

struct AddButton: View {
    let navigator: LinkNavigatorType
    public var body: some View {
        VStack(){
            Spacer()
            HStack(){
                
                Button(action: {
                    navigator.back(isAnimated: true)
                })
                {
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
