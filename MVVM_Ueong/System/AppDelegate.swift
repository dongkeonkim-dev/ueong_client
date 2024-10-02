//
//  AppDelegate.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 10/2/24.
//

import SwiftUI
import SocketIO

// AppDelegate
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var manager: SocketManager!
    var socket: SocketIOClient!
 

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Socket.IO 설정
        manager = SocketManager(socketURL: URL(string: baseURL)!, config: [.log(true), .compress])
        socket = manager.defaultSocket

        // 소켓 이벤트 리스너 설정
        socket.on(clientEvent: .connect) { data, ack in
            print("소켓 연결됨")
            
            // 서버에 ACK 메시지 전송
            self.socket.emit("acknowledge", "클라이언트가 연결되었습니다.")
        }
        
        // 소켓 연결 오류 처리
        socket.on(clientEvent: .error) { data, ack in
            print("소켓 연결 오류: \(data)")
        }
        
//        
//        socket.on(clientEvent: .disconnect) { data, ack in
//            print("소켓 연결 끊김")
//        }
//        
//        // 서버로부터의 메시지 수신
//        socket.on("newMessage") { data, ack in
//            print("새 메시지 수신: \(data)")
//        }



        // 소켓 연결
        socket.connect()

        return true
    }
}



