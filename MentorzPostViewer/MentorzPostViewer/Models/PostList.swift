//
//  Post.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 26/11/19.
//  Copyright © 2019 Nishit Mishra. All rights reserved.
//

import Foundation
import ObjectMapper

class PostList : NSObject, Mappable{

    var posts : [Post]?
    override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        
    }
    func mapping(map: Map)
    {
        posts <- map["post_list"]
        
    }
}
