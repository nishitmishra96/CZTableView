//
//  UploadPost.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 04/01/20.
//  Copyright © 2020 Nishit Mishra. All rights reserved.
//

import Foundation
import UIKit
class LocalPost:NSObject{
    var mimeType : String?
    var selectedImage : UIImage?
    var imageName : String?
    var imageDataToBeUploaded : Data?
    var isImage = false
    var videoFileURL : NSURL?
//    var isUploading = false
    var descriptionFieldText : String?
    var delegate : UploadPostProgressDelegate?
}
class ImageTypeLocalPost:LocalPost{
}

class VideoTypeLocalPost:LocalPost{
}
class TextTypeLocalPost:LocalPost{
}
