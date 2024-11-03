

import ARKit
import QuickLook
import SwiftUI
import UIKit
import os



struct ArView: View {
  @ObservedObject var viewModel: ArView.ViewModel
  @State private var modelData: Data? = nil
  @State private var localURL: URL? = nil
  
  var body: some View {
    VStack {
      if let localURL = localURL {
        ARQuickLookController(modelFile: localURL)
      } else {
        ProgressView("모델 로딩 중...")
          .onAppear {
            loadModel()
          }
      }
    }
  }
  
  private func loadModel() {
    let remoteURL = baseURL.joinPath(viewModel.url)
    
    // 임시 파일 URL 생성
    guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    let localURL = documentsPath.appendingPathComponent("model.usdz")
    
    // 비동기로 모델 다운로드
    URLSession.shared.dataTask(with: URL(string: remoteURL)!) { data, response, error in
      guard let data = data else { return }
      
      do {
        // 임시 파일에 저장
        try data.write(to: localURL)
        
        // UI 업데이트는 메인 스레드에서
        DispatchQueue.main.async {
          self.localURL = localURL
        }
      } catch {
        print("모델 저장 실패: \(error)")
      }
    }.resume()
  }
}

private struct ARQuickLookController: UIViewControllerRepresentable {
  let modelFile: URL
  
  func makeUIViewController(context: Context) -> QLPreviewControllerWrapper {
    let controller = QLPreviewControllerWrapper()
    controller.qlvc.dataSource = context.coordinator
    controller.qlvc.delegate = context.coordinator
    return controller
  }
    func makeCoordinator() -> ARQuickLookController.Coordinator {
        return Coordinator(parent: self)
    }

    func updateUIViewController(_ uiViewController: QLPreviewControllerWrapper, context: Context) {}

    class Coordinator: NSObject, QLPreviewControllerDataSource, QLPreviewControllerDelegate {
        let parent: ARQuickLookController

        init(parent: ARQuickLookController) {
            self.parent = parent
        }

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }

        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return parent.modelFile as QLPreviewItem
        }


    }
}

private class QLPreviewControllerWrapper: UIViewController {
    let qlvc = QLPreviewController()
    var qlPresented = false

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !qlPresented {
            present(qlvc, animated: false, completion: nil)
            qlPresented = true
        }
    }
}

