//
//  RestDataSource.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 11/01/20.
//  Copyright © 2020 Nishit Mishra. All rights reserved.
//

import Foundation
protocol RestDataSource {
    func getPost(forPage:Int,handler: @escaping (([CompletePost]?,Int)->()) )
}
class profileDataSource:RestDataSource{
    private var userid:String
    private var otherUserID:String?
    init(user id:String){
        self.userid = id
    }
    convenience init(userId:String,otherUserID:String){
        self.init(user:userId)
        self.otherUserID = otherUserID
    }
    func getPost(forPage: Int, handler: @escaping (([CompletePost]?, Int) -> ())) {
        PostsRestManager.shared.getMyPost(userId: /self.userid ,pageNumber:forPage) { (postList, statusCode) -> (Void) in
        var responseList = [CompletePost]()
        for post in postList?.posts ?? []{
            let completepost = CompletePost(post: post)
            responseList.append(completepost)
        }
        handler(responseList,statusCode)
        }
    }
    func getPostOfOtherUser(forPage: Int, handler: @escaping (([CompletePost]?, Int) -> ())) {
        
        PostsRestManager.shared.getOtherUserPost(userId: userid, otherId: /self.otherUserID, pageNumber: forPage, handler: { (postList, statusCode) -> (Void) in
            var responseList = [CompletePost]()
            for post in postList?.posts ?? []{
                let completepost = CompletePost(post: post)
                responseList.append(completepost)
            }
            handler(responseList,statusCode)
        })
    }
}
//
//class OtherUserProfile:NSObject{
//    private var userid:String
//    private var otherUserId:String
//    init(userId:String,otherUserId:String){
//        self.userid = userId
//        self.otherUserId = otherUserId
//    }
//    func getPost(forPage: Int, handler: @escaping ((PostList?,[CompletePost]?, Int) -> ())) {
//        PostsRestManager.shared.getOtherUserPost(userId: userid, otherId: otherUserId, pageNumber: forPage, handler: { (postList, statusCode) -> (Void) in
//            var responseList = [CompletePost]()
//            for post in postList?.posts ?? []{
//                let completepost = CompletePost(post: post)
//                responseList.append(completepost)
//            }
//            handler(postList,responseList,statusCode)
//        })
//    }
//}
class BoardPost:RestDataSource{
    private var userid:String?
    init(user id:String) {
        self.userid = id
    }
    func getPost(forPage: Int,handler: @escaping (([CompletePost]?,Int)->()) ) {
        PostsRestManager.shared.getPosts(userId: /self.userid , pageNumber: forPage) { (postList, statusCode) -> (Void) in
            var responseList = [CompletePost]()
            for post in postList?.posts ?? []{
                let completepost = CompletePost(post: post)
                responseList.append(completepost)
            }
            handler(responseList,statusCode)
        }
    }
}
class InterestDataSource:RestDataSource{
    private var userid:String?
    private var interestList:[Int]
    init(user id:String,InterestList:[Int]) {
        self.interestList = InterestList
        self.userid = id
    }
    func getPost(forPage: Int,handler: @escaping (([CompletePost]?,Int)->()) ) {
        var queryparams = "?"
        for value in self.interestList{
            queryparams = queryparams+"interest=\(value)&"
        }
        PostsRestManager.shared.getPostOnUserInterest(userId: /self.userid, interestString: queryparams, pageNumber: forPage) { (postList, statusCode) -> (Void) in
            var responseList = [CompletePost]()
            for post in postList?.posts ?? []{
                let completepost = CompletePost(post: post)
                responseList.append(completepost)
            }
            handler(responseList,statusCode)
        }
    }
}

class SinglePostDataSource:RestDataSource{
    private var postid:String
    init(postId:String){
        self.postid = postId
    }
    func getPost(forPage: Int, handler: @escaping (([CompletePost]?, Int) -> ())) {
        PostsRestManager.shared.getPostByPostId(userId: /MentorzPostViewer.shared.dataSource?.getUserId(), postId: self.postid) { (postReceived, statusCode) in
            if let post = postReceived{
            handler([CompletePost(post: post)],statusCode)
            }else{
                handler(nil,statusCode)
            }
        }
    }
}
