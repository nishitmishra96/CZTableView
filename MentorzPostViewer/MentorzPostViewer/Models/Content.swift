//
//  Content.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 26/11/19.
//  Copyright © 2019 Nishit Mishra. All rights reserved.
//

import Foundation
import ObjectMapper


class PostContent : NSObject, Mappable{

    var contentId : Int?
    @UTFEncodeAndDecode var postText : String?
    var hresId : String?
    var lresId : String?
    var mediaType : String?
    var title : AnyObject?
    var url : AnyObject?

    override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        
    }

    func mapping(map: Map)
    {
        contentId <- map["content_id"]
        postText <- map["description"]
        hresId <- map["hres_id"]
        lresId <- map["lres_id"]
        mediaType <- map["media_type"]
        title <- map["title"]
        url <- map["url"]
        
    }
}
