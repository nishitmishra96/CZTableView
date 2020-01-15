//
//  URLManager.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 26/11/19.
//  Copyright © 2019 Nishit Mishra. All rights reserved.
//

import Foundation

class URLGenerator:NSObject{
    static var shared = URLGenerator()
    var isStaging = false
    
    var baseUrl : String{
        get{
            if isStaging{
                return "http://stgapp.mentorz.com:8080"
            }else{
                return "https://core.mentorz.com:8443"
            }
        }
    }
    
    var postUrl:String{
        get{
            return "https://mentorz.com/stories/"
        }
    }
}
