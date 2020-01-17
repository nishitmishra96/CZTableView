//
//  uploadPostManager.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 12/01/20.
//  Copyright © 2020 Nishit Mishra. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Photos

public class UploadPostManager:NSObject{
    static var shared = UploadPostManager()
    var request:UploadRequest?
    var delegate:UploadPostProgressDelegate?
    var uploadCompleted: (()->())?
    var videoURL:String?
    func getUploadedPost(postId:String,handler:@escaping ((Post?,Int)->())){
        PostsRestManager.shared.getPostByPostId(userId: /MentorzPostViewer.shared.dataSource?.getUserId(), postId: postId) { (post, statusCode) in
            if let uploadedPost = post{
                handler(uploadedPost,statusCode)
            }else{
                handler(nil,statusCode)
            }
        }
    }
    
    public func getVideoThumbnail(filePathLocal: String) -> UIImage? {
        let vidURL = URL(fileURLWithPath:filePathLocal as String)
        let asset = AVURLAsset(url: vidURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            return UIImage(cgImage: imageRef)
        }
        catch let error as NSError
        {
            print("Image generation failed with error \(error)")
            return nil
        }
    }
    
    func uploadImagePost(imageName:String,imageDataToBeUploaded:Data,mimeType:String,descriptionFieldText:String,handler:@escaping ((Post?,Int)->())){
        PostsRestManager.shared.uploadSessionURI(name: imageName, mime: mimeType) { (googleUrl, statusCode) in
            if /googleUrl != ""{
                self.request = Alamofire.upload(imageDataToBeUploaded, to: /googleUrl, method: .put, headers: nil)
                    .uploadProgress(closure: { (progress) in
                        print("print progress \(progress.fractionCompleted)");
                        self.delegate?.progressChangedwith(value: Float(progress.fractionCompleted))
                    })
                    .responseJSON { (response) in
                        print("response from upload image \(response)");
                        if response.response?.statusCode == HttpResponseCodes.success.rawValue{
                            PostsRestManager.shared.getSignedURL(name: imageName) { (url, statusCode) in
                                let content = ContentToUplaod()
                                content.mediaType = "IMAGE"
                                content.lresId = url
                                content.hresId = url
                                content.descriptionField = descriptionFieldText
                                let newPost = NewPost()
                                newPost.contents = []
                                newPost.contents?.append(content)
                                PostsRestManager.shared.uploadPostToMentorzServer(userId: /MentorzPostViewer.shared.dataSource?.getUserId(), newPost: newPost) { (newPost, statusCode) in
                                    self.getUploadedPost(postId: "\(/newPost?.postId)") { (newUploadedPost,statusCode) in
                                        if statusCode == HttpResponseCodes.success.rawValue{
                                            handler(newUploadedPost,statusCode)
                                        }else{
                                            handler(nil,HttpResponseCodes.SomethingWentWrong.rawValue)
                                        }
                                    }
                                }
                            }
                        }
                        else{
                            handler(nil,HttpResponseCodes.SomethingWentWrong.rawValue)
                        }
                }
                
            }else{
            handler(nil,HttpResponseCodes.SomethingWentWrong.rawValue)
        }
    }
    }
    func uploadVideoPost(videoName:String,videoFileURL:NSURL?,mimeType:String,descriptionFieldText:String,handler:@escaping ((Post?,Int)->())){
        PostsRestManager.shared.uploadSessionURI(name: videoName, mime: mimeType) { (googleUrl, statusCode) in
            if googleUrl != ""{
                if let _ = videoFileURL{
                    self.request = Alamofire.upload(videoFileURL as! URL, to: /googleUrl)
                        .uploadProgress(closure: { (progress) in
                            print("print progress \(progress.fractionCompleted)");
                            self.delegate?.progressChangedwith(value: Float(progress.fractionCompleted))
                            
                        })
                        .responseJSON { (response) in
                            print("response from upload image \(response)");
                            if response.response?.statusCode == HttpResponseCodes.success.rawValue{
                                PostsRestManager.shared.getSignedURL(name: videoName) { (url, statusCode) in
                                    let content = ContentToUplaod()
                                    content.mediaType = "VIDEO"
                                    content.lresId = url
                                    content.hresId = url
                                    content.descriptionField = descriptionFieldText
                                    let newPost = NewPost()
                                    newPost.contents = []
                                    newPost.contents?.append(content)
//                                    PostsRestManager.shared.uploadPostToMentorzServer(userId: /MentorzPostViewer.shared.dataSource?.getUserId(), newPost: newPost) { (newPost, statusCode) in
                                        
                                        var mimeTypeOfImage = ""
                                        var imageNameFromVideo = "png"
                                        var imageDataToBeUploaded = Data()
                                        if let image = (videoFileURL as? URL){
                                            imageNameFromVideo = image.lastPathComponent + "THUMB"
                                        }
                                        let selectedImage = self.getVideoThumbnail(filePathLocal: /videoFileURL?.absoluteString)
                                        imageDataToBeUploaded = (selectedImage!).pngData()!
                                        self.uploadThumbnail(videoFileUrl: videoFileURL as! URL, uploadedVideoUrl: /url, postText: descriptionFieldText) { (newPost, statusCode) in
                                            self.getUploadedPost(postId: "\(/newPost?.postId)") { (newpost, statusCode) in
                                                handler(newpost,statusCode)
                                            }
                                        }
//                                    }
                                }
                            }else{
                                handler(nil,HttpResponseCodes.SomethingWentWrong.rawValue)
                            }
                    }
                }
            }else{
            handler(nil,HttpResponseCodes.SomethingWentWrong.rawValue)
        }
        }}
    func uploadTextPost(descriptionFieldText:String,handler:@escaping ((Post?,Int)->())){
        let content = ContentToUplaod()
        content.mediaType = "TEXT"
        content.lresId = ""
        content.hresId = ""
        content.descriptionField = descriptionFieldText
        let newPost = NewPost()
        newPost.contents = []
        newPost.contents?.append(content)
        PostsRestManager.shared.uploadPostToMentorzServer(userId: /MentorzPostViewer.shared.dataSource?.getUserId(), newPost: newPost) { (newPost, statusCode) in
            self.delegate?.progressChangedwith(value: 1.0)
            self.getUploadedPost(postId: "\(/newPost?.postId)") { (newUploadedPost,statusCode) in
                if statusCode == HttpResponseCodes.success.rawValue{
                    handler(newUploadedPost,statusCode)
                }else{ handler(nil,HttpResponseCodes.SomethingWentWrong.rawValue)
                }
            }
        }
    }
    
    func uploadThumbnail(videoFileUrl : URL,uploadedVideoUrl: String,postText:String?,handler:@escaping ((Post?,Int)->())){
        let mimeType = "png"
        var selectedImage : UIImage?
        var imageName : String?
        var imageDataToBeUploaded : Data?
        selectedImage = self.getVideoThumbnail(filePathLocal: videoFileUrl.absoluteString)
        if let image = (videoFileUrl as? URL){
            imageName = image.lastPathComponent + "THUMB"
        }
        if mimeType == "png" {
            imageDataToBeUploaded = (selectedImage!).pngData()!;
        } else {
            imageDataToBeUploaded = (selectedImage!).jpegData(compressionQuality: 1)!;
        }
        PostsRestManager.shared.uploadSessionURI(name: /imageName, mime: /mimeType) { (googleUrl, statusCode) in
            if let url = googleUrl{
                self.request = Alamofire.upload(imageDataToBeUploaded!, to: url, method: .put, headers: nil)
                    .uploadProgress(closure: { (progress) in
                        print("print progress \(progress.fractionCompleted)");
                    })
                    .responseJSON { (response) in
                        print("response from upload image \(response)");
                        if response.response?.statusCode == 200{
                            PostsRestManager.shared.getSignedURL(name: /imageName) { (url, statusCode) in
                                let content = ContentToUplaod()
                                content.mediaType = "VIDEO"
                                content.lresId = url
                                content.hresId = uploadedVideoUrl
                                content.descriptionField = /postText
                                let newPost = NewPost()
                                newPost.contents = []
                                newPost.contents?.append(content)
                                PostsRestManager.shared.uploadPostToMentorzServer(userId: /MentorzPostViewer.shared.dataSource?.getUserId(), newPost: newPost) { (newPost, statusCode) in
                                    if let _ = newPost{
                                    handler(newPost,statusCode)
                                    }else{
                                        handler(nil,statusCode)
                                    }
                                }
                            }
                        }else{
                            handler(nil,HttpResponseCodes.SomethingWentWrong.rawValue)
                        }
                }
            }
        }
    }
    public func cancelUploading(){
        request?.cancel()
        request = nil
    }
}
