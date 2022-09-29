//
//  ImageUploader.swift
//  Twitter_SwiftUI
//
//  Created by Sai Lakshmi on 8/11/22.
//

import Firebase
import FirebaseStorage
import FirebaseFirestore
import UIKit

// upload an image into the Storage and download the image URL (path of the stored image)
struct ImageUploader {
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        //reduces the image quality and size when you download image 
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
                //creates a unique string
        let filename = NSUUID().uuidString
        // creates a path to an image we create in the firebase storage (a new folder with a unique file name shows up in the  profile_image folder)
        let ref = Storage.storage().reference(withPath: "/profile_image/\(filename)")
        
        ref.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("DEBUG: Failed to upload image with error: \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL { imageUrl, _ in
                guard let imageUrl = imageUrl?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
}
