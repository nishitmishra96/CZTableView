//
//  UploadPostVC.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 27/12/19.
//  Copyright © 2019 Nishit Mishra. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos

class UploadPostPopupVC: UIViewController {
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var descriptionImage: UIImageView!
    @IBOutlet weak var textCount: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var constraintWithImageVisible: NSLayoutConstraint!
    @IBOutlet weak var popUpHeight: NSLayoutConstraint!
    @IBOutlet weak var popUpWidth: NSLayoutConstraint!
    @IBOutlet weak var constraintWithImageInvisible: NSLayoutConstraint!
    var uploadAction : UIAlertAction?
    var info : [UIImagePickerController.InfoKey : Any] = [:]
    var isVideo = false
    var isText = true
    
    @IBAction func GalleryButtonPressed(_ sender: Any) {
        GalleryImagePicker().openAlbums(currentlyPresentedVC:self)
    }
    @IBAction func MakeVideo(_ sender: Any) {
        GalleryImagePicker().openAlbums(currentlyPresentedVC:self,isVideo: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.descriptionImage.isHidden = true
        self.errorLabel.isHidden = true
        self.contentView.alpha = 0.2
        self.descriptionField.delegate = self
//        self.descriptionField.addTarget(self, action: #selector(validations), for: .allEvents)
        self.descriptionField.layer.borderWidth = 0.5
        self.descriptionField.layer.borderColor = UIColor.postTextColor.cgColor
        self.descriptionField.textColor = UIColor.postTextColor
        self.textCount.textColor = UIColor.borderColor
        self.textCount.font = UIFont.appFont(font:Fonts.bold , size: FontSize.midTextFont)
        descriptionField.text = "Share what you know"
        descriptionField.textColor = UIColor.lightGray
    }
    
    @objc func validations(){
        self.textCount.text = "\(/descriptionField.text?.count)" + "/140"
        if /descriptionField.text?.count > 0{
            self.errorLabel.isHidden = true
            uploadAction?.isEnabled = true
        }else{
            self.errorLabel.isHidden = false
            self.errorLabel.text = "Please Enter Description"
            uploadAction?.isEnabled = false
        }
    }
    
    func imageSelected() {
//        let imageViewer = Storyboard.home.instanceOf(viewController: ImageViewerVC.self)!
//        imageViewer.delegate = self
////        imageViewer.modalPresentationStyle = .fullScreen
//        let navController = UINavigationController(rootViewController: imageViewer) // Creating a navigation controller with VC1 at the root of the navigation stack.
//        navController.modalPresentationStyle = .fullScreen
//
//        self.present(navController, animated: true){
//            if let editedImage = self.info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
//                imageViewer.imageView.image = editedImage
//            }else{
//                imageViewer.imageView.image = self.info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//            }
//        }
    }
    
    func videoSelected() {
//        let imageViewer = Storyboard.home.instanceOf(viewController: ImageViewerVC.self)!
//        imageViewer.delegate = self
//        imageViewer.modalPresentationStyle = .fullScreen
//        let navController = UINavigationController(rootViewController: imageViewer) // Creating a navigation controller with VC1 at the root of the navigation stack.
//        navController.modalPresentationStyle = .fullScreen
//
//        self.present(navController, animated: true){
//            imageViewer.imageView.image = UploadPostManager.shared.getVideoThumbnail(filePathLocal: (self.info[UIImagePickerController.InfoKey.mediaURL] as! URL).absoluteString)
//            }
    }
}

extension UploadPostPopupVC:ImagePickerDelegate{
    func donePressed() {
        self.descriptionImage.isHidden = false
        self.constraintWithImageInvisible.constant = /self.descriptionImage.frame.width + 8
        if isVideo{
            self.descriptionImage.image = UploadPostManager.shared.getVideoThumbnail(filePathLocal: (self.info[UIImagePickerController.InfoKey.mediaURL] as! URL).absoluteString)
        }else{
            if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
                self.descriptionImage.image = editedImage
            }else{
                self.descriptionImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            }
        }

    }
    
    func imagePickerDissmissed() {
        self.isText = true
        self.isVideo = false
    }
    
}

extension UploadPostPopupVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        print("Hey this is info : ",info)
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! CFString
        self.info = info
        switch mediaType {
        case kUTTypeImage: print("ImageSelected")
        self.imageSelected()
            self.isVideo = false
            self.isText = false
        case kUTTypeMovie: print("VideoSelected")
        self.videoSelected()
            self.isText = false
            self.isVideo = true
        default:
            break
        }
        self.donePressed()
    }
}

extension UploadPostPopupVC:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Share what you know"
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        self.textCount.text = "\(/descriptionField.text?.count)" + "/140"
        
        if /descriptionField.text?.count > 0{
            self.errorLabel.isHidden = true
            uploadAction?.isEnabled = true
        }else{
            self.errorLabel.isHidden = false
            self.errorLabel.text = "Please Enter Description"
            uploadAction?.isEnabled = false
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        let maxLength = 140
        let currentString: NSString = textView.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: text) as NSString

        return newString.length <= maxLength
    }
}
