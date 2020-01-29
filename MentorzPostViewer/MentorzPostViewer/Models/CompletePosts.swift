//
//  CompletePosts.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 04/12/19.
//  Copyright © 2019 Nishit Mishra. All rights reserved.
//

import Foundation
import SDWebImage
import LinkPreviewKit
class CompletePost:NSObject{
    var post:Post?
    var comments : [CompleteComment]? = []
    var isImageFromText = true
    override init(){
        super.init()
    }
    public init(post:Post){
        super.init()
        self.post = post
    }
    
    func getRating(handler:@escaping ((Double?,Int?)->())){
        PostsRestManager.shared.getUserRating(userId: "\(/post?.userId)") { (rating, statusCode) in
            handler(rating?.rating,statusCode)
        }
    }
    func getProfileImage(handler:@escaping ((UIImage?)->())){
        PostsRestManager.shared.getProfileImageWith(userId: "\(/post?.userId)") { (profileImage, statusCode) in
            //            handler(profileImage?.hresId,statusCode)
            SDWebImageManager.shared.loadImage(with: URL(string: /profileImage?.lresId?.stringByAddingPercentEncodingForRFC3986()), options: .continueInBackground, progress: nil) { (image, data, error, cache, download, url) in
                handler(image)
            }
        }
    }
    func getURLEmbeddedInPost() -> NSTextCheckingResult?{
        if /post?.content?.hresId?.count <= 2{
            do{
                let dataDetector = try NSDataDetector.init(types: NSTextCheckingResult.CheckingType.link.rawValue)
                let firstMatch = dataDetector.firstMatch(in: /post?.content?.postText, options: [], range: NSRange(location: 0, length: /post?.content!.postText?.utf16.count))
                return firstMatch
            }
            catch {
                print("No Links")
            }
            return nil
        }
        return nil
    }
    func likedPost(handler: @escaping ((Bool)->()) ){
        PostsRestManager.shared.userLikedThePost(postId: "\(/post?.postId)", userId: /MentorzPostViewer.shared.dataSource?.getUserId()) { (done) in
            handler(done)
        }
    }
    func unLikePost(handler: @escaping ((Bool)->()) ){
        PostsRestManager.shared.userUnlikedThePost(postId: "\(/post?.postId)", userId: /MentorzPostViewer.shared.dataSource?.getUserId()) { (done) in
            handler(done)
        }
    }
    func userReportedAPostWith(type: String, handler: @escaping ((Bool)->()) ) {
        PostsRestManager.shared.reportPost(userId: /MentorzPostViewer.shared.dataSource?.getUserId(), postId: "\(/post?.postId)", type: type){ (statusCode) in
            if statusCode == HttpResponseCodes.NoContent.rawValue{
                handler(true)
            }else{
                handler(false)
                MentorzPostViewer.shared.delegate?.handleErrorMessage(error: "Something Went Wrong \(statusCode!)")
            }
            
        }
    }
    func sharePost(handler:@escaping ((Bool)->())){
        PostsRestManager.shared.sharePost(postId: "\(/self.post?.postId)") { (statusCode) in
            if statusCode == HttpResponseCodes.NoContent.rawValue{
                self.post?.shareCount = (self.post?.shareCount ?? 0) + 1
                handler(true)
            }else{
                handler(false)
            }
        }
    }
    
    func getFullName()->String{
        return (/self.post?.name) + (/self.post?.lastName)
    }
    
    func setURLLinkPreview(url:URL,cellDelegate:PostTableViewCellDelegate?,indexPath:IndexPath){
        LKLinkPreviewReader.linkPreview(from: url) { (preview,error) in
            if self.isImageFromText && /self.post?.content?.lresId?.count < 2 &&  /self.post?.content?.hresId?.count < 2{
                if preview != nil{
                    if ((preview?.first as! LKLinkPreview).imageURL != nil){
                        
                        print("\(self.post?.postId)  preview download Done")
                        self.post?.content?.lresId = (preview?.first as! LKLinkPreview).imageURL?.absoluteString
                        self.post?.content?.hresId = (preview?.first as! LKLinkPreview).imageURL?.absoluteString
                        self.isImageFromText = false
                        cellDelegate?.reloadTableView(indexPath: indexPath)
                    }
                }
            }
        }
    }
}
