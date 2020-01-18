//
//  Fonts.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 10/01/20.
//  Copyright © 2020 Nishit Mishra. All rights reserved.
//

import UIKit
import Foundation
public enum FontSize : Int{
    case largeTextFont = 20
    case midTextFont = 12
    case descriptionFont  = 14
    case ultraSmallTextFont = 10
    case smallTextFont  = 18
    case ultralargeTextFont = 24
}
public struct Fonts {
    private init() {}
   public static let regular  = "MyriadPro-Regular"
   public static let medium  = "MyriadPro-Semibold"
    public static let bold = "MyriadPro-Bold"
    
}
public extension UIFont {
    class func appFont(font:String,size: FontSize) -> UIFont{
        return UIFont(name: font, size: CGFloat(size.rawValue))!
    }
}
