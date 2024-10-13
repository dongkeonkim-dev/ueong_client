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
    @Binding var isPresented: Bool
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
                if let resizedImage = image.resize(within: CGSize(width: 600, height: 600)),
                   let compressedData = resizedImage.compress(to: 20) {
                    parent.imageData = compressedData // 압축된 데이터 저장
                }
            }
            //parent.presentationMode.wrappedValue.dismiss()
            self.parent.isPresented = false
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
                                if let resizedImage = uiImage.resize(within: CGSize(width: 600, height: 600)),
                                   let compressedData = resizedImage.compress(to: 20),
                                    self.parent.selectedImages.count < 10 && !self.parent.selectedImages.contains(uiImage) {
                                    print("Resized Image Size: \(resizedImage.size)") // 해상도 확인
                                    print("Compressed Image Size: \((compressedData.count) / 1024) KB") // 용량 확인
                                    self.parent.selectedImages.append(UIImage(data: compressedData)!) // 중복 체크
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

extension UIImage {
    /// 주어진 해상도로 이미지를 조정합니다.
    func resize(within targetSize: CGSize) -> UIImage? {
            let originalSize = self.size

            // 가로와 세로의 비율을 각각 계산
            let widthRatio = targetSize.width / originalSize.width
            let heightRatio = targetSize.height / originalSize.height

            // 비율을 유지하면서 최대 크기 내에 맞게 조정
            let scaleFactor = min(widthRatio, heightRatio)

            // 새로운 크기 계산 (최대 targetSize 내로 제한)
            let newSize = CGSize(
                width: originalSize.width * scaleFactor,
                height: originalSize.height * scaleFactor
            )

            print("Resizing image to: \(newSize)") // 디버그용 로그

            let renderer = UIGraphicsImageRenderer(size: newSize)
            return renderer.image { _ in
                self.draw(in: CGRect(origin: .zero, size: newSize))
            }
        }
    
    func compress(to maxSizeInKB: Int, compressionQuality: CGFloat = 1.0) -> Data? {
        var compression = compressionQuality
        var compressedData = self.jpegData(compressionQuality: compression)

        // 최대 크기보다 큰 경우 반복해서 압축 수행
        while let data = compressedData, data.count > maxSizeInKB * 1024, compression > 0 {
            compression -= 0.1 // 압축 품질 낮추기
            compressedData = self.jpegData(compressionQuality: compression)
        }

        return compressedData
    }
    
}
