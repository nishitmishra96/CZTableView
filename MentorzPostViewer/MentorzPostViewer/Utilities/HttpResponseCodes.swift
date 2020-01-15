//
//  ResponseCodes.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 04/12/19.
//  Copyright © 2019 Nishit Mishra. All rights reserved.
//

import Foundation

enum HttpResponseCodes:Int{
    case success = 200
    case NoContent = 204
    case NotModified = 304
    case Unauthorised = 401
    case Forbidden = 403
    case NotFound = 404
    case SomethingWentWrong = 700
}
