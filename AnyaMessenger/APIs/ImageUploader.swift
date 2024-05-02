//
//  ImageUploader.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 10/12/23.
//


        //ref is the path where the image is stored. Image is storage in a different storage bucket
import UIKit
import Firebase
import FirebaseStorage

enum UploadType {
    case profile
    case message
    case channel
    
    var filePath: StorageReference {
        let filename = NSUUID().uuidString
        switch self {
        case .profile:
            return Storage.storage().reference(withPath: "/profile_images/\(filename)")
        case .message:
            return Storage.storage().reference(withPath: "/message_images/\(filename)")
        case .channel:
        return Storage.storage().reference(withPath: "/channel_images/\(filename)")

        }
    }
}

struct ImageUploader {
    static func uploadImage(image: UIImage, type: UploadType, completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let ref = type.filePath
        
        ref.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("DEBUG: Failed to upload image \(error.localizedDescription)")
                return
            }
                        
            ref.downloadURL { url, _ in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
}
