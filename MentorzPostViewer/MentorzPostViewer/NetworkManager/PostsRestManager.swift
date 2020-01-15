//
//  PostsRestManager.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 26/11/19.
//  Copyright © 2019 Nishit Mishra. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper
import LinkPreviewKit


class PostsRestManager:NSObject{
    let cache = NSCache<NSString, ProfileImage>()
    let ratingCache = NSCache<NSString, Rating>()

    static var shared = PostsRestManager()
    private var postProvider = MoyaProvider<ApiCollection>()
    func getPosts(userId:String,pageNumber:Int,handler: @escaping ((PostList?,Int)->(Void))){
        postProvider.request(.getMyBoardPost(userId: userId, pageNumber: pageNumber)) { (response) in
            print(response)
            switch response{
            case .success( let result):
                do{
                    let responseString = try result.mapString()
                    print("Done")
                    let postlist = PostList(JSONString: responseString)
                    handler(postlist,result.statusCode)
                }
                catch{
                    print("Not Done")
                    handler(nil,result.statusCode)
                }
                
            case .failure( _):
                MentorzPostViewer.shared.delegate?.handleUnsportedStatusCode(statusCode: /response.error?.response?.statusCode)
                handler(nil,response.error?.response?.statusCode ?? HttpResponseCodes.SomethingWentWrong.rawValue)
            }
        }
    }
    
    func getMyPost(userId:String,pageNumber:Int,handler:@escaping ((PostList?,Int)->(Void))){
        postProvider.request(.getMyPosts(userId: userId, pageNumber: pageNumber)) { (response) in
            print(response)
            switch response{
            case .success( let result):
                do{
                    let responseDic = try JSONSerialization.jsonObject(with: result.data, options: []) as? [String:Any]
                    handler(PostList(JSON: responseDic ?? [:]),result.statusCode)
                }
                catch{
                    
                    handler(nil,result.statusCode)
                }
                
            case .failure(let error):
                MentorzPostViewer.shared.delegate?.handleUnsportedStatusCode(statusCode: /response.error?.response?.statusCode)
                handler(nil,error.response?.statusCode ?? HttpResponseCodes.SomethingWentWrong.rawValue)
            }
        }
        
    }
    
    
    func getOtherUserPost(userId:String,otherId:String,pageNumber:Int,handler:@escaping ((PostList?,Int)->(Void))){
        postProvider.request(.getPostByID(userId: userId, otherId: otherId,pageNumber:pageNumber)) { (response) in
            print(response)
            switch response{
            case .success( let result):
                do{
                    let responseDic = try JSONSerialization.jsonObject(with: result.data, options: []) as? [String:Any]
                    handler(PostList(JSON: responseDic ?? [:]),result.statusCode)
                }
                catch{
                    
                    handler(nil,result.statusCode)
                }
                
            case .failure(let error):
                MentorzPostViewer.shared.delegate?.handleUnsportedStatusCode(statusCode: /response.error?.response?.statusCode)
                handler(nil,error.response?.statusCode ?? HttpResponseCodes.SomethingWentWrong.rawValue)
            }
        }
        
    }
    func userLikedThePost(postId:String,userId:String,handler:@escaping ((Bool)->())){
        
        postProvider.request(.likeAPost(postId: postId, userId: userId)) { (response) in
            switch response{
            case .success(let result):
                if result.response?.statusCode == HttpResponseCodes.NoContent.rawValue{
                    handler(true)
                }else{
                    handler(false)
                }
            case .failure(let _):
                MentorzPostViewer.shared.delegate?.handleUnsportedStatusCode(statusCode: /response.error?.response?.statusCode)
                handler(false)
            }
        }
    }
    
    func userUnlikedThePost(postId:String,userId:String,handler:@escaping ((Bool)->())){
        postProvider.request(.unlikeAPost(postId: postId, userId: userId)) { (response) in
            switch response{
            case .success(let result):
                if result.response?.statusCode == HttpResponseCodes.NoContent.rawValue{
                    handler(true)
                }else{
                    handler(false)
                }
            case .failure(let error):
                MentorzPostViewer.shared.delegate?.handleUnsportedStatusCode(statusCode: /response.error?.response?.statusCode)
                handler(false)
            }
        }
    }
    
    func userCommentedOnAPost(userId:String,postId:String,comment:String,handler:@escaping ((Int)->())){
        postProvider.request(.commentOnAPost(postId: postId, userId: userId, comment: comment)) { (response) in
            switch response{
            case .success(let result):
                handler(result.statusCode)
            case .failure(let error):
                MentorzPostViewer.shared.delegate?.handleUnsportedStatusCode(statusCode: /response.error?.response?.statusCode)
                handler(/response.error?.response?.statusCode)
            }
        }
    }
    func getPostByPostId(userId:String,postId:String,handler:@escaping ((Post?,Int)->())){
        postProvider.request(.getPostByPostId(userId: userId, postId: postId)) { (response) in
            switch response{
            case .success(let result):
                do{
                    let responseString = try result.mapString()
                    let rating = Post(JSONString: responseString)
                    handler(rating,result.statusCode)
                }catch{
                    handler(nil,result.statusCode)
                }
            case .failure(let error):
                MentorzPostViewer.shared.delegate?.handleUnsportedStatusCode(statusCode: /response.error?.response?.statusCode)
                handler(nil,/error.response?.statusCode)
            }
        }
    }
    func getPostOnUserInterest(userId:String,interestString:String,pageNumber:Int,handler:@escaping (PostList?,Int)->(Void)){
        
        postProvider.request(.getPostByInterest(userId: userId, interestString: interestString, pageNumber: pageNumber)) { (response) in
            switch response{
            case .success( let result):
                do{
                    let responseDic = try JSONSerialization.jsonObject(with: result.data, options: []) as? [String:Any]
                    print("Done")
                    handler(PostList(JSON: responseDic ?? [:]),result.statusCode)
                }
                catch{
                    print("Not Done")
                    handler(nil,result.statusCode)
                }
                
            case .failure(let error):
                MentorzPostViewer.shared.delegate?.handleUnsportedStatusCode(statusCode: /response.error?.response?.statusCode)
                handler(nil,/error.response?.statusCode)
            }
        }
    }
    
    func reportPost(userId: String, postId: String, type: String,handler:@escaping ((Int?)->())){
        postProvider.request(.reportAbuse(userId: userId, postId: postId, type: type)) { (response) in
            print(response)
            switch response{
            case .success( let result):
                handler(/result.statusCode)
            case .failure(let error):
                MentorzPostViewer.shared.delegate?.handleUnsportedStatusCode(statusCode: /response.error?.response?.statusCode)
                
                handler(/error.response?.statusCode)
            }
        }
    }
    
    func updatePostViewCount(userId: String, postId: String,handler:@escaping ((Int?)->())){
        postProvider.request(.viewPost(userId: /userId, postId: /postId)) { (response) in
            switch response{
            case .success( let result):
                handler(/result.statusCode)
            case .failure(let error):
                MentorzPostViewer.shared.delegate?.handleUnsportedStatusCode(statusCode: /response.error?.response?.statusCode)
                handler(/error.response?.statusCode)
            }
        }
    }
    
    func getUserRating(userId:String?,handler:@escaping ((Rating?,Int?)->())){
        if let rating = ratingCache.object(forKey: "ratingCache"){
            print("Rating From Cache")
            handler(rating,HttpResponseCodes.success.rawValue)
            return
        }
        postProvider.request(.getUserRating(userId: /userId)) { (response) in
            switch response{
            case .success(let result):
                do{
                    let responseString = try result.mapString()
                    let rating = Rating(JSONString: responseString)
                    if let ratingReceived = rating{
                        self.ratingCache.setObject(ratingReceived, forKey: "ratingCache")
                    }
                    handler(rating ?? Rating(),result.statusCode)
                }catch{
                    handler(nil,result.statusCode)
                }
            case .failure(let error):
                MentorzPostViewer.shared.delegate?.handleUnsportedStatusCode(statusCode: /response.error?.response?.statusCode)
                handler(nil,/error.response?.statusCode)
            }
        }
    }
    
    func getProfileImageWith(userId:String,handler:@escaping ((ProfileImage?,Int?)->())){
        
        if let profileImage = self.cache.object(forKey: userId as NSString){
            print("Image from cache")
            handler(profileImage, HttpResponseCodes.success.rawValue)
            return
        }
        postProvider.request(.getProfileImage(userId: userId)) { (response) in
            switch response{
            case .success(let result):
                do{
                    let responseString = try result.mapString()
                    let profileImage = ProfileImage(JSONString: responseString)
                    if let profileImg = profileImage{
                        self.cache.setObject(profileImg, forKey: userId as NSString)
                    }
                    handler(profileImage,result.statusCode)
                }catch{
                    handler(nil,HttpResponseCodes.SomethingWentWrong.rawValue)
                }
            case .failure(let error):
                MentorzPostViewer.shared.delegate?.handleUnsportedStatusCode(statusCode: /response.error?.response?.statusCode)
                
                handler(nil,error.response?.statusCode)
            }
        }
    }
    func getCommentsforPostId(userId: String?, postId: String?, pageNumber: Int,handler:@escaping ((CommentList?,Int?)->())){
        postProvider.request(.getCommentList(userId: /userId, postId: /postId, pageNumber: pageNumber)) { (response) in
            switch response{
            case .success(let result):
                do{
                    let responseString = try result.mapString()
                    let commentList = CommentList(JSONString: responseString)
                    handler(commentList,result.statusCode)
                }catch{
                    handler(nil,HttpResponseCodes.SomethingWentWrong.rawValue)
                }
            case .failure(let error):
                MentorzPostViewer.shared.delegate?.handleUnsportedStatusCode(statusCode: /response.error?.response?.statusCode)
                
                handler(nil,error.response?.statusCode)
            }
        }
    }
    
    func deleteCommentWith(userId:String,postId:String,commentId:String,handler:@escaping ((Int?)->())){
        postProvider.request(.userDeletedComment(userId: userId, postId: postId, commentId: commentId)) { (response) in
            switch response{
            case .success(let result):
                handler(result.statusCode)
            case .failure(let error):
                MentorzPostViewer.shared.delegate?.handleUnsportedStatusCode(statusCode: /response.error?.response?.statusCode)
                
                handler(error.response?.statusCode)
            }
        }
    }
    
    func uploadSessionURI(name:String,mime:String,handler:@escaping ((String?,Int?)->())){
        postProvider.request(.getUploadSessionURI(name: name, mime: mime)) { (response) in
            switch response{
            case .success(let result) :
                do{
                    let responseString = try result.mapString()
                    let googleUrl = GoogleURL(JSONString: responseString)
                    handler(/googleUrl?.value,result.statusCode)
                }catch{
                    handler("",HttpResponseCodes.SomethingWentWrong.rawValue)
                }
            case .failure(let error) :
                MentorzPostViewer.shared.delegate?.handleUnsportedStatusCode(statusCode: /response.error?.response?.statusCode)
                handler("",error.response?.statusCode)
            }
        }
    }
    func getSignedURL(name:String,handler:@escaping ((String?,Int?)->())){
        postProvider.request(.getSignedURL(contentName: name)) { (response) in
            switch response{
            case .success(let result) :
                do{
                    let responseString = try result.mapString()
                    let googleUrl = GoogleURL(JSONString: responseString)
                    handler(/googleUrl?.value,result.statusCode)
                }catch{
                    handler("",HttpResponseCodes.SomethingWentWrong.rawValue)
                }
            case .failure(let error) :
                MentorzPostViewer.shared.delegate?.handleUnsportedStatusCode(statusCode: /response.error?.response?.statusCode)
                handler("",error.response?.statusCode)
            }
        }
    }
    func uploadPostToMentorzServer(userId:String,newPost:NewPost,handler:@escaping ((Post?,Int)->())){
        postProvider.request(.uploadPost(userId: userId, newPost: newPost)) { (response) in
            switch response{
            case .success(let result) :
                do{
                    let responseString = try result.mapString()
                    let post = Post(JSONString: responseString)
                    handler(post!,result.statusCode)
                }catch{
                    handler(Post(),HttpResponseCodes.SomethingWentWrong.rawValue)
                }
            case .failure(let error) :
                MentorzPostViewer.shared.delegate?.handleUnsportedStatusCode(statusCode: /response.error?.response?.statusCode)
                handler(Post(),/error.response?.statusCode)
            }
        }
    }
    
    func sharePost(postId:String,handler:@escaping ((Int)->())){
        postProvider.request(.sharePost(postId: postId)) { (response) in
            switch response{
            case .success(let result): print("Success")
            handler(result.statusCode)
            case .failure(let error): print("Failure")
            MentorzPostViewer.shared.delegate?.handleUnsportedStatusCode(statusCode: /response.error?.response?.statusCode)
            handler(/error.response?.statusCode)
            }
        }
    }
}
