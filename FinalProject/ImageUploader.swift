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

class ImageUploader: NSObject {
    
    class func upload(image: UIImage, withName imageName: String) {
        
        let testRef = storageRef.child("images/\(imageName)")
        let data = ImageUploader.convertImageToData(image: image)
        
        testRef.put(data, metadata: nil) { metadata, error in
            
            if error == nil {
                // how to return for parent function
                print("image upload successful: \(imageName)")
            } else {
                print(error!.localizedDescription)
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
