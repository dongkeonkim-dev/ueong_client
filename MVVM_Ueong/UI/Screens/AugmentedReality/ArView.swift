//
//  Untitled.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 11/3/24.
//

//import SwiftUI
//
//
//struct ArView: View {
// 
//  var body: some View{
//      ARQuickLookController(modelFile: modelFile)
//  }
//}
//
//private struct ARQuickLookController: UIViewControllerRepresentable {
//
//
//    let modelFile: URL
//
//
//    func makeUIViewController(context: Context) -> QLPreviewControllerWrapper {
//        let controller = QLPreviewControllerWrapper()
//        controller.qlvc.dataSource = context.coordinator
//        controller.qlvc.delegate = context.coordinator
//        return controller
//    }
//
//    func makeCoordinator() -> ARQuickLookController.Coordinator {
//        return Coordinator(parent: self)
//    }
//
//    func updateUIViewController(_ uiViewController: QLPreviewControllerWrapper, context: Context) {}
//
//    class Coordinator: NSObject, QLPreviewControllerDataSource, QLPreviewControllerDelegate {
//        let parent: ARQuickLookController
//
//        init(parent: ARQuickLookController) {
//            self.parent = parent
//        }
//
//        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
//            return 1
//        }
//
//        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
//            return parent.modelFile as QLPreviewItem
//        }
//
//
//    }
//}
//
//private class QLPreviewControllerWrapper: UIViewController {
//    let qlvc = QLPreviewController()
//    var qlPresented = false
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        if !qlPresented {
//            present(qlvc, animated: false, completion: nil)
//            qlPresented = true
//        }
//    }
//}
//
