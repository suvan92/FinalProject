//
//  ImageUploader.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-17.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit
import Firebase

let storage = FIRStorage.storage()
let storageRef = storage.reference(forURL: "gs://finalproject-1b778.appspot.com")

// data(withMaxSize size: Int64, completion: @escaping (Data?, Error?) -> Swift.Void)

class ImageUploader: NSObject {
    
    class func upload(image: UIImage, withName imageName: String, completion: @escaping (Error?) -> Swift.Void) {
        
        let testRef = storageRef.child("images/\(imageName)")
        let data = ImageUploader.convertImageToData(image: image)
        
        testRef.put(data, metadata: nil) { metadata, error in
            
            if error == nil {
                completion(nil)
            } else {
                completion(error)
            }
        }
    }
    
    class func upload(profileImage: UIImage, foruser userid: String, completion: @escaping (Error?) -> Swift.Void) {
        let profileImageRef = storageRef.child("profileImages/\(userid)")
        let data = ImageUploader.convertImageToData(image: profileImage)
        profileImageRef.put(data, metadata: nil) { metadata, error in
            
            if error == nil {
                completion(nil)
            } else {
                completion(error)
            }
        }
    }
    
    class func convertImageToData(image: UIImage) -> Data {
        let imageData : Data = UIImageJPEGRepresentation(image, 0.5)!
        return imageData
    }
    
    class func generateImageName() -> String {
        let uuid = NSUUID().uuidString
        return uuid + ".jpg"
    }
    
}
