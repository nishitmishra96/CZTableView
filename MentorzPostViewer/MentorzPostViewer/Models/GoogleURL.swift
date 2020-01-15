//
//  GoogleURL.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 18/12/19.
//  Copyright © 2019 Nishit Mishra. All rights reserved.
//

import Foundation
import ObjectMapper
class GoogleURL:NSObject, Mappable{

    var value:String?

    override init() {
        super.init()
    }

    required public init?(map: Map) {
        
    }

    func mapping(map: Map)
    {
        value <- map["value"]
        
    }
}
