//
//  NewPost.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 20/12/19.
//  Copyright © 2019 Nishit Mishra. All rights reserved.
//

import Foundation
import ObjectMapper


class ContentToUplaod : NSObject, Mappable{

    @UTFEncodeAndDecode var descriptionField : String?
    var hresId : String?
    var lresId : String?
    var mediaType : String?


    override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        
    }

    func mapping(map: Map)
    {
        descriptionField <- map["description"]
        hresId <- map["hres_id"]
        lresId <- map["lres_id"]
        mediaType <- map["media_type"]
    }
}
