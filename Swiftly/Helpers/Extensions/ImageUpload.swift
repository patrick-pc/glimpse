
import AVFoundation
import Photos
import SwiftUI

protocol ImageUploadable: AnyObject {
    var showingImagePicker: Bool { get set }
    var sourceType: UIImagePickerController.SourceType { get set }

    func checkCameraPermission()
    func checkPhotoLibraryPermission()
}

extension ImageUploadable {
    func checkCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if granted {
                    // Open camera
                    self.sourceType = .camera
                    self.showingImagePicker = true
                } else {
                    // Handle camera permission denied
                    print("Camera permission denied")
                }
            }
        }
    }

    func checkPhotoLibraryPermission() {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized, .limited:
                    self.sourceType = .photoLibrary
                    self.showingImagePicker = true
                case .denied, .restricted:
                    // Handle photo library permission denied
                    print("Photo library permission denied")
                case .notDetermined:
                    // This shouldn't be reached, but handle just in case
                    print("Photo library permission not determined")
                @unknown default:
                    break
                }
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType = .photoLibrary

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(
            _: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }

    func updateUIViewController(
        _: UIImagePickerController,
        context _: UIViewControllerRepresentableContext<ImagePicker>
    ) {}
}
