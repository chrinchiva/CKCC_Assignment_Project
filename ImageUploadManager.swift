//
//  ImageUploadManager.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 12/14/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase

struct Constants{
    struct Car {
        static let imagesFolder: String = "carImages"
    }
}


class ImageUploadManager: NSObject {
    
    func uploadImage(_ image: UIImage, progressBlock:@escaping (_ percentage: Double) -> Void, completionBlock: @escaping (_ url: URL?, _ errorMessage: String?) -> Void)
    {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        // storage / carImages/image.jpg
        let imageName = "\(Date().timeIntervalSince1970).jpg"
        let imageReference = storageReference.child(Constants.Car.imagesFolder).child(imageName)
        
        if let imageData = UIImageJPEGRepresentation(image, 0.8){
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let uploadTask = imageReference.putData(imageData, metadata: metadata, completion: { (metadata, error) in
                if let metadata = metadata {
                    completionBlock(metadata.downloadURL(), nil)
                }
                else{
                    completionBlock(nil, (error?.localizedDescription)!)
                }
            })
            uploadTask.observe(.progress, handler: { (snapshot) in
                guard let progress = snapshot.progress else{
                    return
                }
                
                let percentage = (Double(progress.completedUnitCount) / Double(progress.totalUnitCount)) * 100
                progressBlock(percentage)
                
            })
        }else{
            completionBlock(nil,"Image couldn't be converted to Data.")
        }
    }
}
