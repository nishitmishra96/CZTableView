////
////  uploadPostManager.swift
////  MentorzPostViewer
////
////  Created by Nishit Mishra on 12/01/20.
////  Copyright © 2020 Nishit Mishra. All rights reserved.
////
//
//import Foundation
//import UIKit
//import Alamofire
//import Photos
//
//enum UploadTypes:String{
//    case video = "VIDEO"
//    case image = "IMAGE"
//}
//
//public class PostUploader:NSObject{
//    var request:UploadRequest?
//    var delegate:UploadPostProgressDelegate?
//    var uploadCompleted: (()->())?
//
//    func uploadImagePostToAlamofire(imageName:String,imageDataToBeUploaded:Data,mimeType:String,handler:@escaping ((String,Int)->())){
//        PostsRestManager.shared.uploadSessionURI(name: imageName, mime: mimeType) { (googleUrl, statusCode) in
//            if let url = googleUrl{
//                self.request = Alamofire.upload(imageDataToBeUploaded, to: url, method: .put, headers: nil)
//                    .uploadProgress(closure: { (progress) in
//                        print("print progress \(progress.fractionCompleted)");
//                        self.delegate?.progressChangedwith(value: Float(progress.fractionCompleted))
//                    })
//                    .responseJSON { (response) in
//                        print("response from upload image \(response)");
//                        if response.response?.statusCode == HttpResponseCodes.success.rawValue{
//                            handler(url,/statusCode)
//                        }else{
//                            handler("",HttpResponseCodes.SomethingWentWrong.rawValue)
//                        }
//                }
//            }
//        }
//    }
//    func uploadImagePostToMentorzServer(fileName:String,type:String,postText:String,handler:@escaping ((Post?,Int)->())){
//        PostsRestManager.shared.getSignedURL(name: fileName) { (url, statusCode) in
//            let content = ContentToUplaod()
//            content.mediaType = type
//            content.lresId = url
//            content.hresId = url
//            content.descriptionField = postText
//            let newPost = NewPost()
//            newPost.contents = []
//            newPost.contents?.append(content)
//            PostsRestManager.shared.uploadPostToMentorzServer(userId: /MentorzPostViewer.shared.dataSource?.getUserId(), newPost: newPost) { (newPost, statusCode) in
//                self.getUploadedPost(postId: "\(/newPost?.postId)") { (newUploadedPost,statusCode) in
//                    self.uploadCompleted?()
//                    if statusCode == HttpResponseCodes.success.rawValue{
//                        handler(newUploadedPost,statusCode)
//                    }else{
//                        handler(nil,HttpResponseCodes.SomethingWentWrong.rawValue)
//                    }
//                }
//            }
//        }
//    }
//    func uploadVideoThroughAlamofire(videoName:String,videoFileURL:NSURL?,mimeType:String,descriptionFieldText:String,handler:@escaping ((String?,Int)->())){
//        PostsRestManager.shared.uploadSessionURI(name: videoName, mime: mimeType) { (googleUrl, statusCode) in
//            if let url = googleUrl{
//                if let _ = videoFileURL{
//                    self.request = Alamofire.upload(videoFileURL as! URL, to: url)
//                        .uploadProgress(closure: { (progress) in
//                            print("print progress \(progress.fractionCompleted)");
//                            self.delegate?.progressChangedwith(value: Float(progress.fractionCompleted))
//
//                        })
//                        .responseJSON { (response) in
//                            print("response from upload image \(response)");
//                            if response.response?.statusCode == 200{
//                                PostsRestManager.shared.getSignedURL(name: videoName) { (url, statusCode) in
//                                    if statusCode == HttpResponseCodes.success.rawValue{
//                                        handler(/url,/statusCode)
//                                    }else{
//                                        handler(nil,HttpResponseCodes.SomethingWentWrong.rawValue)
//                                    }
//                                }
//                            }
//                    }
//                }
//            }}}
//
//    func uploadVideoPostToMentorzServer(fileName:String,videoFileURL:NSURL?,mimeType:String,postText:String,handler:@escaping ((Post?,Int)->())){
//        PostsRestManager.shared.getSignedURL(name: fileName) { (url, statusCode) in
//            let content = ContentToUplaod()
//            content.mediaType = "VIDEO"
//            content.lresId = url
//            content.hresId = url
//            content.descriptionField = postText
//            let newPost = NewPost()
//            newPost.contents = []
//            newPost.contents?.append(content)
//            PostsRestManager.shared.uploadPostToMentorzServer(userId: /MentorzPostViewer.shared.dataSource?.getUserId(), newPost: newPost) { (newPost, statusCode) in
//                if statusCode == HttpResponseCodes.success.rawValue{
//                    var mimeTypeOfImage = ""
//                    var imageNameFromVideo = ""
//                    var imageDataToBeUploaded = Data()
//                    if let image = (videoFileURL as? URL){
//                        mimeTypeOfImage = image.pathExtension.lowercased()
//                        imageNameFromVideo = image.lastPathComponent + "THUMB"
//                    }
//                    let selectedImage = self.getVideoThumbnail(filePathLocal: /videoFileURL?.absoluteString)
//                    if /mimeType == "png" {
//                        imageDataToBeUploaded = (selectedImage!).pngData()!;
//                    } else {
//                        imageDataToBeUploaded = (selectedImage!).jpegData(compressionQuality: 1)!;
//                    }
//                    self.uploadImagePostToAlamofire(imageName: imageNameFromVideo, imageDataToBeUploaded: imageDataToBeUploaded, mimeType: mimeTypeOfImage) { (url,statusCode) in
//                        if url != ""{
//                            self.uploadImagePostToMentorzServer(fileName: imageNameFromVideo, type: UploadTypes.image.rawValue, postText: postText) { (newUploadPost, statusCode) in
//                                if let _ = newUploadPost{
//                                    handler(newUploadPost,statusCode)
//                                }else{
//                                    handler(nil,HttpResponseCodes.SomethingWentWrong.rawValue)
//                                }
//                            }
//                        }else{
//                            handler(nil,HttpResponseCodes.SomethingWentWrong.rawValue)
//                        }
//                    }
//                }
//                print("post Sucessfully uploaded")
//            }
//        }
//    }
//    func uploadTextPost(descriptionFieldText:String,handler:@escaping ((Post?,Int)->())){
//        let content = ContentToUplaod()
//        content.mediaType = "TEXT"
//        content.lresId = ""
//        content.hresId = ""
//        content.descriptionField = descriptionFieldText
//        let newPost = NewPost()
//        newPost.contents = []
//        newPost.contents?.append(content)
//        PostsRestManager.shared.uploadPostToMentorzServer(userId: /MentorzPostViewer.shared.dataSource?.getUserId(), newPost: newPost) { (newPost, statusCode) in
//            self.delegate?.progressChangedwith(value: 1.0)
//            self.getUploadedPost(postId: "\(/newPost?.postId)") { (newUploadedPost,statusCode) in
//                self.uploadCompleted?()
//                if statusCode == HttpResponseCodes.success.rawValue{
//                    handler(newUploadedPost,statusCode)
//                }else{ handler(nil,HttpResponseCodes.SomethingWentWrong.rawValue)
//                }
//            }
//        }
//    }
//    func getUploadedPost(postId:String,handler:@escaping ((Post?,Int)->())){
//        PostsRestManager.shared.getPostByPostId(userId: /MentorzPostViewer.shared.dataSource?.getUserId(), postId: postId) { (post, statusCode) in
//            if let uploadedPost = post{
//                handler(uploadedPost,statusCode)
//            }else{
//                handler(nil,statusCode)
//            }
//        }
//    }
//
//    public func getVideoThumbnail(filePathLocal: String) -> UIImage? {
//        let vidURL = URL(fileURLWithPath:filePathLocal as String)
//        let asset = AVURLAsset(url: vidURL)
//        let generator = AVAssetImageGenerator(asset: asset)
//        generator.appliesPreferredTrackTransform = true
//        let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
//        do {
//            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
//            return UIImage(cgImage: imageRef)
//        }
//        catch let error as NSError
//        {
//            print("Image generation failed with error \(error)")
//            return nil
//        }
//    }
//    public func cancelUploading(){
//        request?.cancel()
//        request = nil
//    }
//}
