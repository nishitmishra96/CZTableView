//
//  CommentViewCell.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 04/12/19.
//  Copyright © 2019 Nishit Mishra. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import SDWebImage
class CommentViewCell: UITableViewCell {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var commentMessage: TTTAttributedLabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var deleteButton : UIButton!
    @IBOutlet weak var deleteButtonImage : UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    var comment:CompleteComment?
    var postId : String?
    var userId : String?
    var delegate : UserActivities?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func deleteComment(_ sender: Any) {
        MentorzPostViewer.shared.delegate?.handleProgressHUD(shouldShow: true)
        PostsRestManager.shared.deleteCommentWith(userId: "\(/comment?.comment?.userId)", postId: "\(/self.postId)", commentId: "\(/self.comment?.comment?.commentId)"){(statusCode) in
            MentorzPostViewer.shared.delegate?.handleProgressHUD(shouldShow: false)
            if statusCode == HttpResponseCodes.success.rawValue{
                self.delegate?.userDeletedComment(completeComment: self.comment ?? CompleteComment())
            }else{
                MentorzPostViewer.shared.delegate?.handleErrorMessage(error: "Something Went Wrong \(/statusCode)")
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(comment:CompleteComment?,postId:String?,userId:String){
        guard let newComment = comment else { return }
        self.postId = postId
        self.userId = userId
        self.comment = newComment
        self.userName.text = /comment?.comment?.userName
        self.commentMessage.text = /comment?.comment?.comment
        self.setProfileImageWith(urlString:comment?.comment?.lresId)
        self.date.text = dateTimeUtil.getTimeForComment(forComment: "\(/comment?.comment?.commentTime)")
        if !(/self.userId?.elementsEqual("\(/comment?.comment?.userId)")) {
            self.deleteButton.isHidden = true
            self.deleteButtonImage.isHidden = true
        }
    }
    
    func setProfileImageWith(urlString:String?){
        if let url = urlString{
            self.profileImage.sd_setImage(with: URL(string: url)) { (image, error, cache, url) in
                self.profileImage.image = image
            }
        }else{
            self.profileImage.image = UIImage(named:"default_avt_square")
        }
    }
    
}
