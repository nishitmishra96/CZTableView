//
//  NewPost.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 20/12/19.
//  Copyright © 2019 Nishit Mishra. All rights reserved.
//

import Foundation
import ObjectMapper


class NewPost : NSObject, Mappable{
    var contents : [ContentToUplaod]?

    override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        
    }

    func mapping(map: Map)
    {
        contents <- map["contents"]
    }
}
