//
//  UploadTaskManager.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 07/01/20.
//  Copyright © 2020 Nishit Mishra. All rights reserved.
//

import Foundation
import Alamofire
import MobileCoreServices
import Photos

public class UploadTaskManager:NSObject{
    var request : UploadRequest?
    
    func getUploadedPost(postId:String,handler:@escaping ((Post?,Int)->())){
        PostsRestManager.shared.getPostByPostId(userId: /MentorzPostViewer.shared.dataSource?.getUserId(), postId: postId) { (post, statusCode) in
            if let uploadedPost = post{
                handler(uploadedPost,statusCode)
            }else{
                handler(nil,statusCode)
            }
        }
    }
    
    func uploadContent(localPost:LocalPost?,handler: @escaping((Post?,Int)->())) {
        switch localPost{
        case is ImageTypeLocalPost:
            PostsRestManager.shared.uploadSessionURI(name: /localPost?.imageName, mime: /localPost?.mimeType) { (googleUrl, statusCode) in
                if let url = googleUrl{
                    self.request = Alamofire.upload((localPost?.imageDataToBeUploaded!)!, to: url, method: .put, headers: nil)
                        .uploadProgress(closure: { (progress) in
                            print("print progress \(progress.fractionCompleted)");
                            localPost?.delegate?.progressChangedwith(value: Float(progress.fractionCompleted))
                        })
                        .responseJSON { (response) in
                            print("response from upload image \(response)");
                            if response.response?.statusCode == HttpResponseCodes.success.rawValue{
                                PostsRestManager.shared.getSignedURL(name: /localPost?.imageName) { (url, statusCode) in
                                    let content = ContentToUplaod()
                                    content.mediaType = "IMAGE"
                                    content.lresId = url
                                    content.hresId = url
                                    content.descriptionField = localPost?.descriptionFieldText
                                    let newPost = NewPost()
                                    newPost.contents = []
                                    newPost.contents?.append(content)
                                    PostsRestManager.shared.uploadPostToMentorzServer(userId: /MentorzPostViewer.shared.dataSource?.getUserId(), newPost: newPost) { (newPost, statusCode) in
                                        self.getUploadedPost(postId: "\(/newPost?.postId)") { (newUploadedPost,statusCode) in
                                            if statusCode == HttpResponseCodes.success.rawValue{
                                                handler(newUploadedPost,statusCode)
                                            }else{ handler(nil,HttpResponseCodes.SomethingWentWrong.rawValue)
                                            }
                                        }
                                    }
                                }
                            }else{
                                handler(nil,HttpResponseCodes.SomethingWentWrong.rawValue)
                            }
                    }
                    
                }
            }
        case is VideoTypeLocalPost:
            PostsRestManager.shared.uploadSessionURI(name: /localPost?.imageName, mime: /localPost?.mimeType) { (googleUrl, statusCode) in
                if let url = googleUrl{
                    if let _ = localPost?.videoFileURL{
                        self.request = Alamofire.upload(localPost?.videoFileURL as! URL, to: url)
                            .uploadProgress(closure: { (progress) in
                                print("print progress \(progress.fractionCompleted)");
                                localPost?.delegate?.progressChangedwith(value: Float(progress.fractionCompleted))
                                
                            })
                            .responseJSON { (response) in
                                print("response from upload image \(response)");
                                if response.response?.statusCode == 200{
                                    PostsRestManager.shared.getSignedURL(name: /localPost?.imageName) { (url, statusCode) in
                                        let content = ContentToUplaod()
                                        content.mediaType = "VIDEO"
                                        content.lresId = url
                                        content.hresId = url
                                        content.descriptionField = localPost?.descriptionFieldText
                                        let newPost = NewPost()
                                        newPost.contents = []
                                        newPost.contents?.append(content)
                                        PostsRestManager.shared.uploadPostToMentorzServer(userId: /MentorzPostViewer.shared.dataSource?.getUserId(), newPost: newPost) { (newPost, statusCode) in
                                            self.uploadThumbnail(localPost:localPost,videoFileUrl: localPost?.videoFileURL as! URL,uploadedVideoUrl: /url){(newPost,statusCode) in
                                                self.getUploadedPost(postId: "\(/newPost?.postId)") { (newUploadedPost,statusCode) in
                                                    if statusCode == HttpResponseCodes.success.rawValue{
                                                        handler(newUploadedPost,statusCode)
                                                    }else{ handler(nil,HttpResponseCodes.SomethingWentWrong.rawValue)
                                                    }
                                                }
                                            }
                                            print("post Sucessfully uploaded")
                                        }
                                    }
                                }else{
                                    handler(nil,HttpResponseCodes.SomethingWentWrong.rawValue)
                                }
                        }
                    }
                }
            }
        case is TextTypeLocalPost:
            let content = ContentToUplaod()
            content.mediaType = "TEXT"
            content.lresId = ""
            content.hresId = ""
            content.descriptionField = localPost?.descriptionFieldText
            let newPost = NewPost()
            newPost.contents = []
            newPost.contents?.append(content)
            PostsRestManager.shared.uploadPostToMentorzServer(userId: /MentorzPostViewer.shared.dataSource?.getUserId(), newPost: newPost) { (newPost, statusCode) in
                localPost?.delegate?.progressChangedwith(value: Float(1))
                self.getUploadedPost(postId: "\(/newPost?.postId)") { (newUploadedPost,statusCode) in
                    if statusCode == HttpResponseCodes.success.rawValue{
                        handler(newUploadedPost,statusCode)
                    }else{ handler(nil,HttpResponseCodes.SomethingWentWrong.rawValue)
                    }
                }
            }
            
        case .none:
            break
        case .some(_):
            break
        }
    }
    func uploadThumbnail(localPost:LocalPost?,videoFileUrl : URL,uploadedVideoUrl : String,handler:@escaping ((Post?,Int)->())){
        var mimeType : String?
        var selectedImage : UIImage?
        var imageName : String?
        var imageDataToBeUploaded : Data?
        selectedImage = self.getVideoThumbnail(filePathLocal: videoFileUrl.absoluteString)
        if let image = (videoFileUrl as? URL){
            mimeType = image.pathExtension.lowercased()
            imageName = image.lastPathComponent + "THUMB"
        }
        
        if /mimeType == "png" {
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
                                content.descriptionField = /localPost?.descriptionFieldText
                                let newPost = NewPost()
                                newPost.contents = []
                                newPost.contents?.append(content)
                                PostsRestManager.shared.uploadPostToMentorzServer(userId: /MentorzPostViewer.shared.dataSource?.getUserId(), newPost: newPost) { (newPost, statusCode) in
                                    handler(newPost,statusCode)
                                }
                            }
                        }else{
                            handler(nil,HttpResponseCodes.SomethingWentWrong.rawValue)
                        }
                }
            }
        }
    }
    func getVideoThumbnail(filePathLocal: String) -> UIImage? {
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
}

extension UploadTaskManager : PostUploadCancelled{
    func uploadCancelled() {
        self.request?.cancel()
    }
}
