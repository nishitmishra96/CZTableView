//
//  Comment.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 04/12/19.
//  Copyright © 2019 Nishit Mishra. All rights reserved.
//

import Foundation
import ObjectMapper


public class Comment : NSObject, Mappable{

    @UTFEncodeAndDecode var comment : String?
    var commentId : Int?
    var commentTime : Int?
    var hresId : String?
    var lastName : String?
    var lresId : String?
    @UTFEncodeAndDecode var name : String?
    var userId : Int?
    @UTFEncodeAndDecode var userName : String?

    var fullName : String{
        get{
            return /(/name + " " + /lastName).removingPercentEncoding
        }
    }
    override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        
    }

    public func mapping(map: Map)
    {
        comment <- map["comment"]
        commentId <- map["comment_id"]
        commentTime <- map["comment_time"]
        hresId <- map["hres_id"]
        lastName <- map["last_name"]
        lresId <- map["lres_id"]
        name <- map["name"]
        userId <- map["user_id"]
        userName <- map["user_name"]
        
    }
}
