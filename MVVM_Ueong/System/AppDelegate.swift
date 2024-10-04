import SwiftUI


class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // 앱 실행 시 소켓 연결
        SocketManagerService.shared.connect()

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // 앱 종료 시 소켓 연결 해제
        SocketManagerService.shared.disconnect()
    }
}

