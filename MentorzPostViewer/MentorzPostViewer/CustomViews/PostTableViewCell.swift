//
//  PostTableViewself.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 14/11/19.
//  Copyright © 2019 Nishit Mishra. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import SDWebImage
import LinkPreviewKit
import TTTAttributedLabel
import moa
let RATING_ROUNDUP_MIN_VALUE = 0.2
let RATING_ROUNDUP_MAX_VALUE = 0.7

protocol PostTableViewCellDelegate{
    func shouldRemoveCell(indexPath:IndexPath)
    func reloadTableView(indexPath:IndexPath)
    func updateLayout(indexPath:IndexPath)
}
class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var viewWithProfileImage: UIView!
    @IBOutlet weak var userActivitiesView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var postText: ExpandableLabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var timeOfPost: UILabel!
    @IBOutlet weak var mainPostImage: UIImageView!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var viewCount: UILabel!
    @IBOutlet weak var shareCount: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var abuseButton: UIButton!
    @IBOutlet weak var abusePostImage: UIView!
    @IBOutlet weak var firstStar: UIImageView!
    @IBOutlet weak var secondStar: UIImageView!
    @IBOutlet weak var thirdStar: UIImageView!
    @IBOutlet weak var fourthStar: UIImageView!
    @IBOutlet weak var fifthStar: UIImageView!
//    @IBOutlet weak var readMore : UIButton!
    @IBOutlet weak var containerView:UIView!
    @IBOutlet weak var userActivitiesStackView: UIStackView!
    @IBOutlet weak var viewWithImageAndButton: UIView!
    @IBOutlet weak var viewWithImageAndButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
//    @IBOutlet weak var readMoreButtonHeight: NSLayoutConstraint!
    
    var images : [UIImageView] = []
    var didTapOnImageView:((_ imageurl:String)->())?
    var didTapOnVideoPlay:((_ videoUrl:String)->())?
    var delegate : UserActivities?
    var cellDelegate:PostTableViewCellDelegate?
    var indexPath:IndexPath = IndexPath()
    weak var completePost:CompletePost?
    var url : URL?
    var userId : String {
        get {
            return /MentorzPostViewer.shared.dataSource?.getUserId()
        }
    }
////    var readMorePressed = false
//    @IBAction func readMorePressed(_ sender: Any) {
//        if !(self.readMorePressed){
//            self.postText.numberOfLines = 0
//            self.postText.lineBreakMode = .byWordWrapping
//            self.readMore.setTitle("Read Less", for: .normal)
//        }else{
//            self.postText.numberOfLines = 2
//            self.postText.lineBreakMode = .byTruncatingTail
//            self.readMore.setTitle("Read More", for: .normal)
////            delegate?.userPressedReadButton(post:self.completePost)
//        }
//        self.layoutIfNeeded()
////        self.layoutSubviews()
////        super.updateConstraints()
//        cellDelegate?.updateLayout(indexPath: indexPath)
//        self.readMorePressed = !self.readMorePressed
//    }
//
    func setUpCell(){
        self.baseView.backgroundColor = UIColor.appColor
        self.containerView.layer.borderWidth = 1
        self.containerView.layer.borderColor = UIColor.borderColor
        self.containerView.layer.cornerRadius = 5
        self.likeButton.layer.borderWidth = 0.5
        self.likeButton.layer.borderColor = UIColor.borderColor
        self.commentButton.layer.borderWidth = 0.5
        self.commentButton.layer.borderColor = UIColor.borderColor
        self.shareButton.layer.borderWidth = 0.5
        self.shareButton.layer.borderColor = UIColor.borderColor
        self.userActivitiesView.roundCorners(.bottomLeft, radius: 5)
        self.userActivitiesView.roundCorners(.bottomRight, radius: 5)
        self.likeButton.roundCorners(.bottomLeft, radius: 5)
        self.shareButton.roundCorners(.bottomRight, radius: 5)
        self.mainPostImage.layer.borderWidth = 0.5
        self.mainPostImage.layer.borderColor = UIColor.borderColor
        self.postText.textColor = UIColor.postTextColor
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpCell()
        self.abusePostImage.layer.borderColor = UIColor.gray.cgColor
        self.abusePostImage.layer.borderWidth = 1.0
        self.abusePostImage.layer.cornerRadius = 5
        images.append(firstStar)
        images.append(secondStar)
        images.append(thirdStar)
        images.append(fourthStar)
        images.append(fifthStar)
        self.postText.delegate = self
        profileImage.layer.cornerRadius = 25
        self.mainPostImage.image = UIImage(named:"loading_data_logo")
        self.profileImage.image = UIImage(named: "default_avt_square")
        self.postText.numberOfLines = 3
//        postText.enabledTypes = [.url]
//        postText.collapsed = true
//        postText.collapsedAttributedLink = NSAttributedString(string: "Read More")
//        postText.ellipsis = NSAttributedString(string: "...")

    }
    
    override func prepareForReuse() {
//        profileImage.image = nil
//        timeOfPost.text = ""
//        postText.text = nil
//        name.text = ""
//        mainPostImage.image = nil
//        likeCount.text = ""
//        commentCount.text = ""
//        shareCount.text = ""
//        viewCount.text = ""
        self.profileImage.image = UIImage(named: "default_avt_square")
        self.mainPostImage.image = UIImage(named:"loading_data_logo")
//        for rating in 0..<5{
//           self.images[rating].image = UIImage(named: "unselected_rate")
//        }
    }
    func setData(cellPost:CompletePost?){
        guard let newPost = cellPost else { return }
        self.completePost = newPost
        self.setProfieImage(completePost: cellPost!)
        self.setRatingwith(completePost:cellPost!)
        self.postText.text = completePost?.post?.content?.postText
        self.name.text = completePost?.post?.name?.removingPercentEncoding
//        self.readMore.setTitle("Read More", for: .normal)
        if let likeCount = completePost?.post?.likeCount{
            self.likeCount.text = (likeCount > 1) ? "\(likeCount) likes":"\(likeCount) like"
        }
        if completePost?.post?.liked ?? false{
            self.likeButton.setImage(UIImage(named: "selected_like", in: Bundle.init(identifier: "com.craterzone.MentorzPostViewer"), compatibleWith: UITraitCollection(displayScale: 1.0)), for: .normal)
        }else{
            self.likeButton.setImage(UIImage(named: "like", in: Bundle.init(identifier: "com.craterzone.MentorzPostViewer"), compatibleWith: UITraitCollection(displayScale: 1.0)), for: .normal)
        }
        self.commentCount.text = (/completePost?.post?.commentCount > 1) ? "\(/completePost?.post?.commentCount) comments " : "\(/completePost?.post?.commentCount) comment"
        self.viewCount.text = (/completePost?.post?.viewCount > 1) ? "\(/completePost?.post?.viewCount) views " : "\(/completePost?.post?.viewCount) view"
        self.shareCount.text = (/completePost?.post?.shareCount > 1) ? "\(/completePost?.post?.shareCount) shares":"\(/completePost?.post?.shareCount) share"
        if /completePost?.post?.content?.lresId?.count >= 2{
            self.mainPostImage.isHidden = false
            self.playButton.isHidden = false
            self.viewWithImageAndButtonHeight.constant = UIScreen.main.bounds.width - 8
            self.mainPostImage.image = UIImage(named:"loading_data_logo")
            self.mainPostImage.moa.url = /completePost?.post?.content?.lresId
        }else{
            viewWithImageAndButtonHeight.constant = 0
            self.mainPostImage.isHidden = true
            self.playButton.isHidden = true
        }
        if self.completePost?.post?.content?.mediaType == "IMAGE"{
            self.playButton.setImage(nil, for: .normal)
        }else if self.completePost?.post?.content?.mediaType == "VIDEO"{
            self.playButton.setImage(UIImage(named:"play"), for: .normal)
        }else if self.completePost?.post?.content?.mediaType == "TEXT" && /self.completePost?.post?.content?.hresId?.count < 2{
            if let imageURL = self.completePost?.getURLEmbeddedInPost()?.url{
                self.mainPostImage.isHidden = false
                self.setURLLinkPreview(url: imageURL)
            }
        }
        self.timeOfPost.text = dateTimeUtil.getTimeDutation(forPost:"\(/completePost?.post?.shareTime)")
//        if postText.isTruncated || postText.text == nil{
//            self.readMore.isHidden = true
//        }else{
//            self.readMore.isHidden = false
//        }
    }
    private func setURLLinkPreview(url:URL){
            LKLinkPreviewReader.linkPreview(from: url) { (preview,error) in
                if preview != nil{
                    if ((preview?.first as! LKLinkPreview).imageURL != nil){
                        self.completePost?.post?.content?.lresId = (preview?.first as! LKLinkPreview).imageURL?.absoluteString
                        self.completePost?.post?.content?.hresId = (preview?.first as! LKLinkPreview).imageURL?.absoluteString
                        self.cellDelegate?.reloadTableView(indexPath: self.indexPath)
                    }
                }
        }
    }
    func setProfieImage(completePost:CompletePost){
        completePost.getProfileImage { (urlString,statusCode) in
            if statusCode == HttpResponseCodes.success.rawValue{
                self.profileImage.moa.url = urlString
            }else{
                self.profileImage.image = UIImage(named:"default_avt_square")
            }
        }
    }
    
    func setImageForText(url:String){
        self.mainPostImage.isHidden = false
        self.playButton.isHidden = false
        self.mainPostImage.moa.url = url
        viewWithImageAndButtonHeight.constant = self.viewWithImageAndButton.frame.width
    }
    
    func setRatingwith(completePost:CompletePost){
        completePost.getRating() { (rating,statusCode) in
            if statusCode == HttpResponseCodes.success.rawValue{
            if let rating = rating{
                for rating in 0..<Int(/rating){
                    self.images[rating].image = UIImage(named: "selected_rate")
                }
                let rate = /rating - Double(Int(/rating))

                if (rate > RATING_ROUNDUP_MIN_VALUE && rate < RATING_ROUNDUP_MAX_VALUE){
                    self.images[Int(/rating)].image = UIImage(named: "selected_halfRate")
                }
                if rate > RATING_ROUNDUP_MAX_VALUE{
                    self.images[Int(/rating)].image = UIImage(named: "selected_rate")
                }
                }
            }else{
                for rating in 0..<5{
                   self.images[rating].image = UIImage(named: "unselected_rate")
                }
            }
        }
    }

    @IBAction func abuseButtonPressed(_ sender: Any) {
        let alertController = UIAlertController.init(title: "Report Abuse?", message: nil, preferredStyle: .actionSheet)

        let inappropriateContent = UIAlertAction(title: "Inappropriate Content", style: .destructive) { (action) in
            self.completePost?.userReportedAPostWith(type: "InAppropriateContent", handler: { (result) in
                if (result){
                self.cellDelegate?.shouldRemoveCell(indexPath: self.indexPath)
                }
            })
        }
        let spam = UIAlertAction(title: "Spam", style: .destructive) { (action) in
            self.completePost?.userReportedAPostWith(type: "Spam", handler: { (result) in
                if result{
                    self.cellDelegate?.shouldRemoveCell(indexPath: self.indexPath)
                }
            })
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(inappropriateContent)
        alertController.addAction(spam)
        alertController.addAction(cancel)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    @IBAction func didTapOnImage(_ sender: UIButton) {
        if self.completePost?.post?.content?.mediaType == "IMAGE"{
            let imageViewer = Storyboard.home.instanceOf(viewController: ImageViewerVC.self)!
            imageViewer.modalPresentationStyle = .fullScreen
            UIApplication.shared.keyWindow?.rootViewController?.present(imageViewer, animated: true){
                imageViewer.imageView.image = self.mainPostImage.image
            }

        }else if self.completePost?.post?.content?.mediaType == "TEXT" {
            let imageViewer = Storyboard.home.instanceOf(viewController: ImageViewerVC.self)!
            if let _ = self.completePost?.post?.content?.hresId {
                imageViewer.url = URL(string: completePost?.post?.content?.hresId ?? "")
            }
            imageViewer.modalPresentationStyle = .fullScreen
            UIApplication.shared.keyWindow?.rootViewController?.present(imageViewer, animated: true, completion: nil)
        }else if self.completePost?.post?.content?.mediaType == "VIDEO"{
            let videoURL = URL(string: completePost?.post?.content?.hresId ?? "")
            let player = AVPlayer(url: videoURL!)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            UIApplication.shared.keyWindow?.rootViewController?.present(playerViewController, animated: true, completion: {
                playerViewController.player!.play()
            })
        }
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
            if completePost?.post?.liked ?? false{
                self.clickedLikeWhenAlreadyLiked()
                self.completePost?.unLikePost(handler: { (done) in
                    if !done{
                        self.clickedLikeWhenAleadyDisliked()
                    }
                })
            }else{
                self.clickedLikeWhenAleadyDisliked()
                self.completePost?.likedPost(handler: { (done) in
                    if !done{
                        self.clickedLikeWhenAlreadyLiked()
                    }
                })
        }
    }
    
    func clickedLikeWhenAlreadyLiked(){
        if (completePost?.post?.likeCount)! > 0{
            completePost?.post?.likeCount! -= 1
        }
        if let likeCount = completePost?.post?.likeCount{
            self.likeCount.text = (likeCount > 1) ? "\(likeCount) likes":"\(likeCount) like"
        }
        completePost?.post?.liked = false
        self.likeButton.setImage(UIImage(named: "like", in: Bundle.init(identifier: "com.craterzone.MentorzPostViewer"), compatibleWith: UITraitCollection(displayScale: 1.0)), for: .normal)
    }
    
    func clickedLikeWhenAleadyDisliked(){
        completePost?.post?.likeCount! += 1
        if let likeCount = completePost?.post?.likeCount{
           self.likeCount.text = (likeCount > 1) ? "\(likeCount) likes":"\(likeCount) like"
        }
        completePost?.post?.liked = true
           self.likeButton.setImage(UIImage(named: "selected_like", in: Bundle.init(identifier: "com.craterzone.MentorzPostViewer"), compatibleWith: UITraitCollection(displayScale: 1.0)), for: .normal)
    }
    
    @IBAction func commentButtonPressed(_ sender: Any) {
        let commentVC = Storyboard.home.instanceOf(viewController: CommentViewVC.self)!
        commentVC.modalPresentationStyle = .fullScreen
        commentVC.refreshCellCommentCount = { (count) in
            self.commentCount.text = "\(count) comment"
        }
        UIApplication.shared.keyWindow?.rootViewController?.present(commentVC, animated: true, completion:{
            commentVC.getCommentList(userId: self.userId, postId: "\(/self.completePost?.post?.postId)",comments: self.completePost?.comments)
        })
    }
    
    @IBAction func profilePictureTapped(_ sender: Any) {
        MentorzPostViewer.shared.userActivitiesDelegate?.profileImageClicked(userId: "\(/self.completePost?.post?.userId)",username: /completePost?.getFullName().removingPercentEncoding)

    }
    @IBAction func UserNameTapped(_ sender: Any) {
        MentorzPostViewer.shared.userActivitiesDelegate?.profileImageClicked(userId: "\(/self.completePost?.post?.userId)",username: /completePost?.getFullName().removingPercentEncoding)
    }
    @IBAction func shareButtonPressed(_ sender: Any) {
        let url : NSURL?
        let caption:NSString = NSString(string: /self.completePost?.post?.content?.postText)
//        if self.completePost?.post?.content?.mediaType != "TEXT"{
            url = NSURL(string: URLGenerator.shared.postUrl + "\(String(describing: /completePost?.post?.postId))")!
//        }else{
//            url = self.url as NSURL?
//        }
        let objectstoshare = [caption,url]
        let controller = UIActivityViewController(activityItems: objectstoshare, applicationActivities: nil)
        controller.setValue(caption, forKey: "Subject")
        UIApplication.shared.keyWindow?.rootViewController?.present(controller, animated: true, completion: nil)
        controller.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                // User canceled
                return
            }
            self.completePost?.sharePost(handler: { (result) in
                if result{
                self.shareCount.text = (/self.completePost?.post?.shareCount > 1) ? "\(/self.completePost?.post?.shareCount) shares":"\(/self.completePost?.post?.shareCount) share"
                }
            })
        }
    }
    
    func sharePost(){
        let caption:NSString = self.postText?.text as! NSString
        let url = NSURL(string: "google.com")!
        let objectstoshare = [caption,url]
        let controller = UIActivityViewController(activityItems: objectstoshare, applicationActivities: nil)
        controller.excludedActivityTypes = [UIActivity.ActivityType.postToWeibo,
                                            UIActivity.ActivityType.print, UIActivity.ActivityType.copyToPasteboard,
                                            UIActivity.ActivityType.assignToContact, UIActivity.ActivityType.saveToCameraRoll,
                                            UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToFlickr,
                                            UIActivity.ActivityType.postToVimeo, UIActivity.ActivityType.postToTencentWeibo,UIActivity.ActivityType.airDrop]
        controller.setValue(caption, forKey: "Subject")
        controller.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                // User canceled
                return
            }else{
                print("SHared")
            }
        }
        UIApplication.shared.keyWindow?.rootViewController?.present(controller, animated: true, completion: nil)

    }
}

extension PostTableViewCell:ExpandableLabelDelegate{
    func willExpandLabel(_ label: ExpandableLabel) {
        
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        
    }
    
    func didTapOnLink(_ label: ExpandableLabel, link: String) {
        if link != ""{
        if UIApplication.shared.canOpenURL(URL(string: link)!){
            UIApplication.shared.open(URL(string: link)!, options: [:], completionHandler: nil)
        }
        }
    }
    
    
}
