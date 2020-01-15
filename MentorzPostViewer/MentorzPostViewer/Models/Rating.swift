//
//  Rating.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 03/12/19.
//  Copyright © 2019 Nishit Mishra. All rights reserved.
//

import Foundation
import ObjectMapper

class Rating : NSObject, Mappable{

    var rating:Double?
    
    override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        
    }
    
    func mapping(map: Map)
    {
        rating <- map["rating"]
        
    }
}
