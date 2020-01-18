//
//  Post.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 26/11/19.
//  Copyright © 2019 Nishit Mishra. All rights reserved.
//

import Foundation
import ObjectMapper


class Post : NSObject, Mappable{

    var commentCount : Int?
    var content : PostContent?
    var contents : [PostContent]?
    var lastName : String?
    var likeCount : Int?
    var liked : Bool?
    var name : String?
    var postId : Int?
    var shareCount : Int?
    var shareTime : Int?
    var userId : Int?
    var viewCount : Int?

    override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        
    }

    public func mapping(map: Map)
    {
        commentCount <- map["comment_count"]
        content <- map["content"]
        contents <- map["contents"]
        lastName <- map["last_name"]
        likeCount <- map["like_count"]
        liked <- map["liked"]
        name <- map["name"]
        postId <- map["post_id"]
        shareCount <- map["share_count"]
        shareTime <- map["share_time"]
        userId <- map["user_id"]
        viewCount <- map["view_count"]
        
    }
    var fullName : String{
        get{
            return /(/name + " " + /lastName).removingPercentEncoding
        }
    }
}
