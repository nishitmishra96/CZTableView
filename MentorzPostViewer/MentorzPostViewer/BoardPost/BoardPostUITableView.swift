//
//  BoardPostUITableView.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 11/01/20.
//  Copyright © 2020 Nishit Mishra. All rights reserved.
//

import UIKit
import Alamofire

@objc public protocol BoardPostStatusCodeDelegates{
    @objc func didReceiveForTableViewData(with statusCode:Int)
    @objc func showNoSearchResult(with Value:Bool)
}
public class BoardPostUITableView: BaseTableView {
    var controller:PostController?
    
    @objc open var statusCodeDelegate:BoardPostStatusCodeDelegates?
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    @objc public  func resetProfileImage(){
        PostsRestManager.shared.cache.removeObject(forKey: /MentorzPostViewer.shared.dataSource?.getUserId() as NSString)
        self.didPullToRefresh()
    }
    @objc override func didPullToRefresh(){
        self.refreshControl?.beginRefreshing()
        self.controller?.filterPostString = ""
        self.reset()
    }
    @objc public func filterLocalPost(string:String){
        self.controller?.filterPostString = string
        self.reloadData()
        if self.numberOfRows(inSection: 1) == 0{
            statusCodeDelegate?.showNoSearchResult(with: true)
        }else{
            statusCodeDelegate?.showNoSearchResult(with: false)
        }
    }
    @objc public func setupTableViewForProfile(user id:String){
        self.controller = PostController(foruserProfile: id, base: self)
    }
    @objc public func setupTableViewForBoardPost(user id:String){
        self.controller = PostController(userid: id, base: self)
    }
    @objc public func setupTableViewForBoardPostBasedOnInterestList(user id:String,interesetList:[Int]){
        self.controller = PostController(userid: id, base: self, interestList: interesetList)
    }
    
    @objc public func setUpTableViewForOtherUserProfile(otherUserId:String){
        self.controller = PostController(foruserProfile: /MentorzPostViewer.shared.dataSource?.getUserId(), otherUserId: otherUserId, base: self)
    }
    @objc public func getPost(){
        self.controller?.getPost(forPage: 0)
    }
    
    @objc public func setupTableViewForSinglePost(userid:String,postid:String){
        self.controller = PostController(userid: userid, postid: postid, base: self)
    }
    
    func uploadPostPopup(info: [UIImagePickerController.InfoKey : Any],descriptionText:String,selectedImage:UIImage?,isVideo:Bool = false,videoFileUrl:NSURL? = nil,isText:Bool = false){
        UploadPostManager.shared.request = upload(Data(), to: URL.init(string: "https://www.google.com")!)
        self.reloadSections(IndexSet(integersIn: 0...0), with: UITableView.RowAnimation.top)
        if isText{
            UploadPostManager.shared.uploadTextPost(descriptionFieldText: descriptionText)  { (newPost, statusCode) in
                UploadPostManager.shared.request = nil
                UploadPostManager.shared.uploadCompleted?()
                if statusCode == HttpResponseCodes.success.rawValue{
                    if let newPostToShow = newPost{
                        MentorzPostViewer.shared.userActivitiesDelegate?.trackNewPostUploadEvent()
                        self.controller?.InsertNewRow(withPost:newPostToShow)
                    }else{
                        MentorzPostViewer.shared.delegate?.handleErrorMessage(error: "Something Went Wrong")
                        self.showAlertMessageWith(title: "Warning", message: "Upload Failure")
                    }
                }else if statusCode == HttpResponseCodes.NoInternet.rawValue{
                    self.showAlertMessageWith(title: "Warning", message: "Please Connect to Internet")
                }
            }
        }else{
            let imageURL = info[.imageURL]
            var imageName = ("\((Date().timeIntervalSince1970 * 1000))").replacingOccurrences(of: ".", with: "")
            var mimeType = ""
            var imageDataToBeUploaded = Data()
            
            if let image = (imageURL as? URL){
                mimeType = image.pathExtension.lowercased()
            }
            
            if mimeType == "png" {
                imageDataToBeUploaded = (selectedImage?.pngData()!)!;
            } else {
                imageDataToBeUploaded = (selectedImage?.jpegData(compressionQuality: 1)!)!;
            }
            if !isVideo{
                UploadPostManager.shared.uploadImagePost(imageName: imageName, imageDataToBeUploaded: imageDataToBeUploaded, mimeType: mimeType, descriptionFieldText: /descriptionText) { (newPost, statusCode) in
                    UploadPostManager.shared.request = nil
                    UploadPostManager.shared.uploadCompleted?()
                    if statusCode == HttpResponseCodes.success.rawValue{
                        if let newPostToShow = newPost{
                            self.controller?.InsertNewRow(withPost:newPostToShow)
                            print("post Sucessfully uploaded")
                            MentorzPostViewer.shared.userActivitiesDelegate?.trackNewPostUploadEvent()
                        }else{
                            MentorzPostViewer.shared.delegate?.handleErrorMessage(error: "Something Went Wrong")
                            self.showAlertMessageWith(title: "Warning", message: "Upload Failure")
                        }
                    }else if statusCode == HttpResponseCodes.NoInternet.rawValue{
                        self.showAlertMessageWith(title: "Warning", message: "Please Connect to Internet")
                    }
                }
            }else{
                if /videoFileUrl?.lastPathComponent != ""{
                    imageName = imageName + "." + /videoFileUrl?.pathExtension?.lowercased()
                    UploadPostManager.shared.uploadVideoPost(videoName: imageName, videoFileURL: videoFileUrl, mimeType:  /videoFileUrl?.pathExtension, descriptionFieldText: descriptionText) { (newPost, statusCode) in
                        UploadPostManager.shared.request = nil
                        UploadPostManager.shared.uploadCompleted?()
                        if statusCode == HttpResponseCodes.success.rawValue{
                            if let newPostToShow = newPost{
                                self.controller?.InsertNewRow(withPost:newPostToShow)
                                print("post Sucessfully uploaded")
                                MentorzPostViewer.shared.userActivitiesDelegate?.trackNewPostUploadEvent()
                            }else{
                                MentorzPostViewer.shared.delegate?.handleErrorMessage(error: "Something Went Wrong")
                                self.showAlertMessageWith(title: "Warning", message: "Upload Failure")
                            }
                        }else if statusCode == HttpResponseCodes.NoInternet.rawValue{
                            self.showAlertMessageWith(title: "Warning", message: "Please Connect to Internet")
                        }
                    }
                }
            }
        }
        
    }
    
    func showAlertMessageWith(title:String,message:String){
        let uploadPopUp = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Dismiss", style: .destructive){ _ in
        }
        uploadPopUp.addAction(cancelAction)
        uploadPopUp.modalPresentationStyle = .overFullScreen
        UIApplication.shared.keyWindow?.rootViewController?.present(uploadPopUp, animated: true, completion: nil)
    }
    @objc public func addPostbuttonClicked() {
        if UploadPostManager.shared.request != nil{
            self.showAlertMessageWith(title:  "Alert", message: "Wait or cancel current uploading to add a new post.")
        }else{
            self.setContentOffset(.zero, animated: true)
            let uploadPostVC = Storyboard.home.instanceOf(viewController: UploadPostPopupVC.self)!
            let uploadPopUp = UIAlertController(title: "Add Post", message: "", preferredStyle: .alert)
            let uploadAction = UIAlertAction(title: "Publish", style: .default) { (uploadAction) in
                if uploadPostVC.isText{
                    self.uploadPostPopup(info: [:], descriptionText: /uploadPostVC.descriptionField.text, selectedImage: nil, isVideo: false, videoFileUrl: nil, isText: true)
                }else if uploadPostVC.isVideo{
                    self.uploadPostPopup(info: uploadPostVC.info, descriptionText: /uploadPostVC.descriptionField.text, selectedImage: uploadPostVC.descriptionImage.image, isVideo: uploadPostVC.isVideo, videoFileUrl: (uploadPostVC.info[UIImagePickerController.InfoKey.mediaURL] as! NSURL))
                }else{
                    self.uploadPostPopup(info: uploadPostVC.info, descriptionText: /uploadPostVC.descriptionField.text, selectedImage: uploadPostVC.descriptionImage.image)
                }
            }
            uploadAction.isEnabled = false
            uploadPostVC.uploadAction = uploadAction
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive){ _ in
                
            }
            uploadPopUp.addAction(uploadAction)
            uploadPopUp.addAction(cancelAction)
            uploadPopUp.preferredContentSize = UIApplication.shared.keyWindow?.frame.offsetBy(dx: 50, dy: 50).size ?? CGSize.zero
            uploadPopUp.setValue(uploadPostVC, forKey: "contentViewController")
            let height:NSLayoutConstraint = NSLayoutConstraint(item: uploadPopUp.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 300)
            uploadPopUp.view.addConstraint(height)
            uploadPopUp.modalPresentationStyle = .overFullScreen
            UIApplication.shared.keyWindow?.rootViewController?.present(uploadPopUp, animated: true, completion: nil)
        }
        
    }

}
