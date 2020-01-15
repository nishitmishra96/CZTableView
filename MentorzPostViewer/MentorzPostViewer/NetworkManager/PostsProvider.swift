//
//  PostsProvider.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 26/11/19.
//  Copyright © 2019 Nishit Mishra. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper

enum ApiCollection{
    case getMyBoardPost(userId:String,pageNumber:Int)
    case getPostByID(userId:String,otherId:String,pageNumber:Int)
    case getPostByPostId(userId:String,postId:String)
    case likeAPost(postId:String,userId:String)
    case unlikeAPost(postId:String,userId:String)
    case commentOnAPost(postId:String,userId:String,comment:String)
    case getMyPosts(userId:String,pageNumber:Int)
    case getUserPost(userId:String,otherId:String)
    case getPostByInterest(userId:String,interestString:String,pageNumber:Int)
    case reportAbuse(userId:String,postId:String,type:String)
    case viewPost(userId:String,postId:String)
    case getUserRating(userId:String)
    case getProfileImage(userId:String)
    case getCommentList(userId:String,postId:String,pageNumber:Int)
    case userDeletedComment(userId:String,postId:String,commentId:String)
    case getUploadSessionURI(name:String,mime:String)
    case getSignedURL(contentName:String)
    case uploadPost(userId:String,newPost:NewPost)
    case sharePost(postId:String)
}
extension ApiCollection:TargetType{
    var headers: [String : String]? {
        switch self{
        case .getUploadSessionURI(_,let mime):
            return ["Accept":"application/json","Content-Type":"image/\(mime)","user-agent":/MentorzPostViewer.shared.dataSource?.getUserAgent()]
        default: return ["Accept":"application/json","Content-Type":"application/json","user-agent":/MentorzPostViewer.shared.dataSource?.getUserAgent(),"oauth-token":MentorzPostViewer.shared.dataSource?.authToken() ?? ""]
        }
        
    }
    
    var baseURL: URL {
        switch self {
        case .getPostByInterest(userId: let userid, interestString: let interestString, pageNumber: let pagenumber):
            return URL(string: URLGenerator.shared.baseUrl + "/mentorz/api/v3/\(userid)/post/search\(interestString)pageNo=\(pagenumber)" )!

        default:
            return URL(string: URLGenerator.shared.baseUrl )!
        }
    }
    
    var path: String {
        switch self {
        case .getMyBoardPost(let userID,_):
            return "/mentorz/api/v3/user/\(userID)/board"
        case .getPostByID(let userID,let postId,_):
            return "/mentorz/api/v3/\(userID)/post/friend/\(postId)"
        case .likeAPost(let postId,let userId):
            return "/mentorz/api/v3/\(userId)/post/\(postId)/like"
        case .commentOnAPost(let postId,let userId,_):
            return "/mentorz/api/v3/\(userId)/post/\(postId)/comment"
        case .getMyPosts(let userId,_):
            return "/mentorz/api/v3/\(userId)/post/friend/\(userId)"
        case .getPostByInterest(_, _, _):
            return ""
        case .unlikeAPost(let postId, let userId):
            return "/mentorz/api/v3/\(userId)/post/\(postId)/unlike"
        case .reportAbuse(let userId, let postId, _):
            return "/mentorz/api/v3/\(userId)/post/\(postId)/abuse"
        case .viewPost(let userId, let postId):
            return "/mentorz/api/v3/\(userId)/post/\(postId)/view"
        case .getUserRating(let userId):
            return "/mentorz/api/v3/user/\(userId)/rating"
        case .getProfileImage(let userId):
            return "/mentorz/api/v3/user/\(userId)/profile/image"
        case .getCommentList(let userId,let postId,_):
            return "/mentorz/api/v3/\(userId)/post/\(postId)/comments"
        case .userDeletedComment(let userId,let postId,let commentId):
            return "/mentorz/api/v3/\(userId)/post/\(postId)/comment/\(commentId)"
        case .getUploadSessionURI(let name,_):
            return "/mentorz/api/v3/user/signed/sessionuri/object/\(name)"
        case .getSignedURL(let contentName):
            return "/mentorz/api/v3/user/signed/geturl/object/\(contentName)"
        case .uploadPost(let userId,_):
            return "/mentorz/api/v3/\(userId)/post"
        case .getPostByPostId(let userId, let postId):
            return "/mentorz/api/v3/\(userId)/post/\(postId)"
        case .sharePost(let postId):
            return "/mentorz/api/v3/\(/MentorzPostViewer.shared.dataSource?.getUserId())/post/\(postId)/share"
        case .getUserPost(let userId, let otherId):
            return "/mentorz/api/v3/\(userId)/post/friend/\(otherId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPostByID,.getMyBoardPost,.getMyPosts,.getUserRating,.getPostByInterest,.getProfileImage,.getCommentList,.getUploadSessionURI,.getSignedURL,.getPostByPostId,.getUserPost:
            return .get
        case .likeAPost,.unlikeAPost,.reportAbuse,.viewPost,.sharePost:
            return .post
        case .commentOnAPost,.uploadPost:
            return .put
        case  .userDeletedComment:
            return .delete
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getMyBoardPost(_,let page):
            return .requestCompositeData(bodyData: Data(), urlParameters: ["pageNo":page])
        case .getPostByID(_,_,let page):
            return .requestCompositeData(bodyData: Data(), urlParameters: ["pageNo":page])
        case .likeAPost(_,_):
            return .requestPlain
        case .commentOnAPost(_,_, let comment):
            return .requestCompositeParameters(bodyParameters: ["comment":comment], bodyEncoding: JSONEncoding.default, urlParameters: [:])
        case .getMyPosts(_, let pageNumber):
            return .requestCompositeData(bodyData: Data(), urlParameters: ["pageNo":pageNumber])
        case .getPostByInterest( _, _, _):
            return .requestPlain
        case .unlikeAPost( _, _):
            return .requestPlain
        case .reportAbuse(_, _,let type):
            return .requestParameters(parameters: ["abuse_type":type], encoding: JSONEncoding.default)
        case .viewPost(_,_):
            return .requestPlain
        case .getUserRating(_):
            return .requestPlain
        case .getProfileImage(_):
            return .requestPlain
        case .getCommentList(_, _,let pageNumber):
            return .requestCompositeData(bodyData: Data(), urlParameters: ["pageNo":pageNumber])
        case .userDeletedComment(_, _, _):
            return .requestPlain
        case .getUploadSessionURI(_,_):
            return .requestPlain
        case .getSignedURL(_):
            return .requestPlain
        case .uploadPost(_,let newPost):
            let dict = newPost.toJSON()
            return .requestCompositeParameters(bodyParameters: dict, bodyEncoding: JSONEncoding.default, urlParameters: [:])
        case .getPostByPostId(_, _):
            return .requestPlain
        case .sharePost(_):
            return .requestPlain
        case .getUserPost(let userId, let otherId):
            return .requestPlain
        }
    }
    var validationType: ValidationType {
        return .successCodes
    }
    
}
