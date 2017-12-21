//
//  SellController.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 12/21/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import UIKit
import Firebase
class SellController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var image1View: UIImageView!
    @IBOutlet weak var image2View: UIImageView!
    @IBOutlet weak var image3View: UIImageView!
    @IBOutlet weak var productTitleTextField: UITextField!
    @IBOutlet weak var sellerPhoneNumberTextField: UITextField!
    @IBOutlet weak var priceOfProductTextField: UITextField!
    var imageOrder = 0
    var selectedImage:[UIImage]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let selectedImage1 = info[UIImagePickerControllerOriginalImage] as! UIImage
        //selectedImage2[0] = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //print(selectedImage)
        switch imageOrder {
            case 1:
            //selectedImage[0] = info[UIImagePickerControllerOriginalImage] as! UIImage
            //selectedImage[0] = selectedImage1
            image1View.image = selectedImage1
            case 2:
            //selectedImage[1] = info[UIImagePickerControllerOriginalImage] as! UIImage
               // selectedImage[1] = selectedImage1
            image2View.image = selectedImage1
            case 3:
            //selectedImage[2] = info[UIImagePickerControllerOriginalImage] as! UIImage
            //selectedImage[2] = selectedImage1
            image3View.image = selectedImage1
        default: break
            // do nothing
        }
        // upload image to firebase
        let myImageData = UIImageJPEGRepresentation(selectedImage1, 0.75)
        let userID = Auth.auth().currentUser?.uid
        let profileImageFileName = Auth.auth().currentUser!.uid + ".jpg"
        let profileRef = Storage.storage().reference(withPath: "productImages/\(String(describing: userID))/\(imageOrder)")
        profileRef.putData(myImageData!, metadata: nil) { (metaData, error) in
            if error == nil {
                print("Upload profile", metaData)
            }
            else {
                print("Up load to firebase Storage fail:\(error?.localizedDescription)")
            }

        }
        
    }
    
    @IBAction func onClickButtonChooseCategory(_ sender: UIButton) {
       print("image one stored")
        print(selectedImage[0])
        print("image one stored")
        print(selectedImage[1])
        print("image one stored")
        print(selectedImage[2])
        
    }
    // choose image for sell view product
    @IBAction func onClickBrowsePhotos(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select image", message: "Which image order?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Set image1", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            print("select image 1")
            self.imageOrder = 1
            self.startSelectImage()
        }))
        alert.addAction(UIAlertAction(title: "Set image2", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            print("select image 2")
            self.imageOrder = 2
            self.startSelectImage()
        }))
        alert.addAction(UIAlertAction(title: "Set image3", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            print("select image 3")
            self.imageOrder = 3
            self.startSelectImage()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    func startSelectImage(){
        print("Start choose image")
        let imagePickerVc = UIImagePickerController()
        imagePickerVc.sourceType = .photoLibrary
        imagePickerVc.delegate = self
        present(imagePickerVc, animated: true, completion: nil)
    }
    
}
