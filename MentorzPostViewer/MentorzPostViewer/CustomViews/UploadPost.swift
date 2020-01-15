//
//  UploadPost.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 31/12/19.
//  Copyright © 2019 Nishit Mishra. All rights reserved.
//

import UIKit

class UploadPost: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var descriptionImage: UIImageView!
    @IBOutlet weak var textCount: UILabel!
    var delegate : UploadPostDelegate?
    @IBAction func UploadContent(_ sender: Any) {
    }
    @IBAction func CloseButtonPressed(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        self.removeFromSuperview()
    }
    @IBAction func GalleryButtonPressed(_ sender: Any) {
        delegate?.openGallery()
    }
    @IBAction func MakeVideo(_ sender: Any) {
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.descriptionImage.isHidden = true
//        self.contentView.alpha = 0.2
//    }
//    init() {
//        super.init()
//        self.descriptionImage.isHidden = true
//        self.contentView.alpha = 0.2
//    }
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.descriptionImage.isHidden = true
//        self.contentView.alpha = 0.2
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
