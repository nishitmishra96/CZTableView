//
//  GalleryImagePicker.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 18/12/19.
//  Copyright © 2019 Nishit Mishra. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import Photos
class GalleryImagePicker:NSObject{
    func openAlbums(currentlyPresentedVC:UploadPostPopupVC?,isVideo:Bool = false){
        let authorisationStatus = PHPhotoLibrary.authorizationStatus()
        switch authorisationStatus{
            case .authorized:
                self.presentImagePicker(currentlyPresentedVC:currentlyPresentedVC,isVideo: isVideo)
            case .notDetermined,.denied,.restricted:
                self.checkAuthorisation(currentlyPresentedVC:currentlyPresentedVC)
            @unknown default:
                print("Unknown error")
            }
    }
    
    func checkAuthorisation(currentlyPresentedVC:UploadPostPopupVC?,isVideo:Bool = false){
        PHPhotoLibrary.requestAuthorization { (authorisation) in
            if authorisation == .authorized{
                self.presentImagePicker(currentlyPresentedVC:currentlyPresentedVC,isVideo: isVideo)
            }else{
                print("Not authorised")
            }
        }
    }
    
    func presentImagePicker(currentlyPresentedVC:UploadPostPopupVC?,isVideo:Bool = false){
        let imagePickerController = UIImagePickerController()
        if /isVideo{
            imagePickerController.sourceType = .camera
        }else{
            imagePickerController.sourceType = .photoLibrary

        }
        imagePickerController.allowsEditing = true
        imagePickerController.mediaTypes = [kUTTypeMovie as String,kUTTypeImage as String]
        imagePickerController.delegate = currentlyPresentedVC
        imagePickerController.modalPresentationStyle = .fullScreen
        currentlyPresentedVC?.present(imagePickerController, animated: true, completion: nil)
        }
}

