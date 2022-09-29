//
//  ImagePicker.swift
//  Twitter_SwiftUI
//
//  Created by Sai Lakshmi on 8/4/22.
//

import SwiftUI
//UIViewControllerRepresentable protocol allows us to create some UIKit's UIView/ViewController and translates it into SwiftUIView for us.
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        //We are creating a View Controller here..
        let picker = UIImagePickerController()
        ////Every UIViewControllerRepresentable has to have a coordinator(the Coordinator class) )that links/bridges the gap between UIKit and SwiftUI.
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        print("write code here")
    }
}

extension ImagePicker {
    
    // To work with ImagePicker, it has to conform to UINavigationControllerDelegate and UIImagePickerControllerDelegate
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else { return }
            parent.selectedImage = image
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
