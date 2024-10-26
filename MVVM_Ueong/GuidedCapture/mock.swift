////
////  mock.swift
////  MVVM_Ueong
////
////  Created by 김석원 on 10/21/24.
////
//
//import Foundation
//import RealityKit
//import UIKit
//import SwiftUI
//
//enum CaptureSessionState {
//    case initializing
//    case ready
//    case capturing
//    case detecting
//    case finished
//    case error // 오류 상태 추가
//}
//
//enum CameraTrackingState {
//    case normal
//    case limited
//    case notAvailable
//}
//
//protocol ObjectCaptureSession {
//    var state: CaptureSessionState { get }
//    var id: UUID { get } // 세션의 고유 식별자
//    var isPaused: Bool { get } // 세션이 일시 중지 상태인지 여부
//    var cameraTracking: CameraTrackingState { get } // 카메라 트래킹 상태
//
//    var userCompletedScanPassUpdates: AsyncStream<Bool> { get } // 스캔 완료 업데이트
//
//    func startCapturing()
//    func stopCapturing()
//    func detectObject() -> Bool
//}
//
//class MockObjectCaptureSession: ObjectCaptureSession {
//    var state: CaptureSessionState = .ready
//    var id: UUID = UUID() // 임의의 UUID 생성
//    var isPaused: Bool = false // 기본값 설정
//    var cameraTracking: CameraTrackingState = .normal // 기본값 설정
//
//    var capturedImages: [UIImage] = []
//    var isObjectFlippable: Bool = false
//
//    var userCompletedScanPassUpdates: AsyncStream<Bool> {
//        AsyncStream { continuation in
//            // 시뮬레이터에서 동작할 테스트용 로직 추가
//            continuation.yield(true) // 예시로 true를 지속적으로 반환
//            continuation.finish() // 스트림 종료
//        }
//    }
//
//    func startCapturing() {
//        state = .capturing
//    }
//
//    func stopCapturing() {
//        state = .ready
//    }
//
//    func detectObject() -> Bool {
//        return Bool.random() // 랜덤으로 true 또는 false 반환
//    }
//}
//
//
//
//
//
//struct ObjectCaptureView: View {
//    var session: ObjectCaptureSession
//    var cameraFeedOverlay: () -> AnyView // 필요에 따라 바꾸세요
//
//    var body: some View {
//        Text("시뮬레이터 환경이기 때문에 캡처 불가능")
//    }
//}
