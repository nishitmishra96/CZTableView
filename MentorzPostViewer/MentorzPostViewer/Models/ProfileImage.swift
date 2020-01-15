//
//  ProfileImage.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 04/12/19.
//  Copyright © 2019 Nishit Mishra. All rights reserved.
//

import Foundation
import ObjectMapper


class ProfileImage : NSObject,Mappable{

    var birthDate : Int?
    var chargePrice : Int?
    var followers : Int?
    var following : Int?
    var hresId : String?
    var lresId : String?
    var mentees : Int?
    var mentors : Int?
    var noofpost : Int?
    var requests : Int?


      override init() {
          super.init()
      }
      
      required public init?(map: Map) {
          
      }

    func mapping(map: Map)
    {
        birthDate <- map["birth_date"]
        chargePrice <- map["charge_price"]
        followers <- map["followers"]
        following <- map["following"]
        hresId <- map["hres_id"]
        lresId <- map["lres_id"]
        mentees <- map["mentees"]
        mentors <- map["mentors"]
        noofpost <- map["noofpost"]
        requests <- map["requests"]
        
    }

}
