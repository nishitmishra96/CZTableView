//
//  TableViewCell.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 07/01/20.
//  Copyright © 2020 Nishit Mishra. All rights reserved.
//

import UIKit

class UploadProgressCell: UITableViewCell {
    
    @IBOutlet weak var percentageCompleted: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var currentProgress: UIProgressView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var closeButton: UIButton!
    var delegate : PostTableViewCellDelegate?
    var indexPath:IndexPath = IndexPath()
    
    @IBAction func close(_ sender: Any) {
        UploadPostManager.shared.cancelUploading()
        delegate?.shouldRemoveCell(indexPath: indexPath)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.percentageCompleted.text = "0 %"
        self.currentProgress.progress = 0.0
        self.activityIndicator.isHidden = true
        UploadPostManager.shared.delegate = self
        UploadPostManager.shared.uploadCompleted = {
            self.activityIndicator.isHidden = false
            UploadPostManager.shared.request = nil
            self.delegate?.shouldRemoveCell(indexPath: self.indexPath)
            self.closeButton.isHidden = true
            self.activityIndicator.startAnimating()
        }
    }
    func setUpView(){
        self.view.backgroundColor = UIColor.appColor
        self.containerView.layer.borderWidth = 1
        self.containerView.layer.borderColor = UIColor.borderColor.cgColor
    }
}
extension UploadProgressCell:UploadPostProgressDelegate{
    func progressChangedwith(value: Float) {
        self.currentProgress.progress = value
        self.percentageCompleted.text = "\(String(Substring(("\(value*100)".prefix(5))))) %"
    }
}
