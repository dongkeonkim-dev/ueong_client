import SwiftUI

@main
struct MVVM_UeongApp: App {
  
  static let subsystem: String = "org.sfomuseum.photogrammetry.guidedcapture"
    // AppDelegate 연결
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    // State variable to track socket connection
  @State private var isSocketConnected = false
  
  @StateObject var appState = AppState()
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(appState)
    }
  }
}
//  var body: some Scene {
//    WindowGroup {
        //Show the splash screen or the main content based on socket connection status
        //if isSocketConnected {
//      ContentView()
//        .environmentObject(appState)
        //} else {
        //    SplashScreen()
        //       .onReceive(NotificationCenter.default.publisher(for: .socketConnected)) { _ in
        //          // 소켓 연결 후 2초 대기
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        //              isSocketConnected = true
        //            }
        //          }
        //       }


// Splash Screen View
struct SplashScreen: View {
    var body: some View {
        VStack {
            // 임시 이미지를 시스템 아이콘으로 대체
            Image(systemName: "star") // 시스템 이미지 이름으로 대체 (예: "star")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200) // 필요에 따라 크기 조정
            
            Text("Your App Name") // 앱 이름으로 대체
                .font(.largeTitle)
                .padding()
            
            // 로딩 인디케이터 추가
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white) // 배경 색상
        .edgesIgnoringSafeArea(.all)
    }
}



