//
//  String.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 25/11/19.
//  Copyright © 2019 Nishit Mishra. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        return ceil(boundingBox.width)
    }
    func estimatedLabelHeight(text: String, width: CGFloat, font: UIFont) -> CGFloat {
        
        let size = CGSize(width: width, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: font]
        let rectangleHeight = String(text).boundingRect(with: size, options: options, attributes: attributes, context: nil).height
        return rectangleHeight
    }
    
    func encode(_ s: String) -> String {
        let data = s.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    
    func decode(_ s: String) -> String? {
        let data = s.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII)
    }
    
    func stringByAddingPercentEncodingForRFC3986() -> String? {
        if contains("https://storage.googleapis.com/mentorz_content") {
            let strings = components(separatedBy: "&Signature=")
            var lastPath = strings.last
            let unreserved = "-._~/?"
            var allowed = CharacterSet.alphanumerics
            allowed.insert(charactersIn: unreserved)
            lastPath = lastPath?.addingPercentEncoding(withAllowedCharacters: allowed)
            var url = strings.first
            url = /url + ("&Signature=")
            url = /url + (/lastPath)
            return url
        } else {
            return self
        }

    }
}


extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
    
}

@propertyWrapper
class UTFEncodeAndDecode{
    private var text : String?
    var wrappedValue: String? {
        get {if let text = text{
            return String().decode(text)
        }else{
            return nil
            }
        }
        set {
            if let value = newValue{
                text = String().encode(value).removingPercentEncoding
            }else {
                text = nil
            }
        }
        
    }
}

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}
