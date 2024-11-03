import ARKit
import QuickLook
import SwiftUI
import UIKit
import os



struct ArView: View {
  @ObservedObject var viewModel: ArView.ViewModel
  @State private var modelData: Data? = nil
  @State private var localURL: URL? = nil
  @State private var error: Error? = nil
  
  var body: some View {
    VStack {
      if let error = error {
        Text("모델을 불러오는데 실패했습니다: \(error.localizedDescription)")
      } else if let localURL = localURL {
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
    let remoteURL = baseURL.joinPath(viewModel.url)+".usdz"
    print("Loading model from: \(remoteURL)") // 디버깅용
    
    guard let url = URL(string: remoteURL) else {
      self.error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
      return
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
      DispatchQueue.main.async {
        if let error = error {
          self.error = error
          return
        }
        
        guard let data = data else {
          self.error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
          return
        }
        
        do {
          let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
          let localURL = documentsPath.appendingPathComponent("model.usdz")
          try data.write(to: localURL)
          self.localURL = localURL
        } catch {
          self.error = error
        }
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

