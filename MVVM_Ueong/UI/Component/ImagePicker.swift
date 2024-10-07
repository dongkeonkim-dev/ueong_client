//
//  ImagePicker.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 10/1/24.
//
import SwiftUI
import UIKit
import PhotosUI

// MARK: - ImagePicker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var imageData: Data?
    @Environment(\.presentationMode) var presentationMode
    var sourceType: UIImagePickerController.SourceType

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.imageData = image.jpegData(compressionQuality: 0.8)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// MARK: - MultiImagePicker
struct MultiImagePicker: UIViewControllerRepresentable {
    
    @Binding var selectedImages: [UIImage] // 선택된 이미지 배열
    @Binding var isPresented: Bool // Picker의 상태를 관리하는 변수
    
    var configuration: PHPickerConfiguration {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 10 - selectedImages.count // 최대 선택 가능 이미지 수
        config.filter = .images // 이미지 필터링
        return config
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    class Coordinator: NSObject, PHPickerViewControllerDelegate {

        var parent: MultiImagePicker

        init(_ parent: MultiImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            let itemProviders = results.map(\.itemProvider)

            for provider in itemProviders {
                if provider.canLoadObject(ofClass: UIImage.self) {
                    provider.loadObject(ofClass: UIImage.self) { (image, error) in
                        if let uiImage = image as? UIImage {
                            DispatchQueue.main.async {
                                // 현재 선택된 이미지 수에 따라 추가
                                if self.parent.selectedImages.count < 10 && !self.parent.selectedImages.contains(uiImage) {
                                    self.parent.selectedImages.append(uiImage) // 중복 체크
                                }
                            }
                        }
                    }
                }
            }
            self.parent.isPresented = false // Hidden 처리
        }

        func imagePickerControllerDidCancel(_ picker: PHPickerViewController) {
            self.parent.isPresented = false // Hidden 처리
        }
    }
}

