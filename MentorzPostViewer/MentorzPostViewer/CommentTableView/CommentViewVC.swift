//
//  CommentViewVC.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 04/12/19.
//  Copyright © 2019 Nishit Mishra. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SVProgressHUD
class CommentViewVC: UIViewController {
   
    @IBOutlet weak var tableView: CommentTableView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentTitleLabel: UILabel!
    @IBOutlet weak var commentHeight: NSLayoutConstraint!
    @IBOutlet weak var messegeLabel: UILabel!
    let messageTextViewMaxHeight: CGFloat = 83
    var refreshCellCommentCount:((Int)->())?
    var dataSource : CommentTableViewDataSource?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib.init(nibName: "CommentViewCell", bundle: Bundle.init(identifier: "com.craterzone.MentorzPostViewer")), forCellReuseIdentifier: "CommentViewCell")
        self.commentTitleLabel.font = UIFont.appFont(font: Fonts.regular, size: FontSize.largeTextFont)
        self.navigationItem.title = "Comments"
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.black,
         NSAttributedString.Key.font: UIFont.appFont(font: Fonts.regular, size: FontSize.smallTextFont)]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Back", style: .done, target: self, action: #selector(backButtonPressed))
        commentTextView.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    public func getCommentList(userId:String?,postId:String?,comments:[CompleteComment]?){
        self.tableView.getCommentList(userId: /userId, postId: /postId,comments:comments)
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        let numberOfComments = self.tableView.numberOfRows(inSection: 0)
        refreshCellCommentCount?(numberOfComments)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func postButtonPressed(_ sender: Any) {
        if validations(){
            SVProgressHUD.show()
//        MentorzPostViewer.shared.delegate?.handleProgressHUD(shouldShow: true)
        PostsRestManager.shared.userCommentedOnAPost(userId: /MentorzPostViewer.shared.dataSource?.getUserId(), postId: /self.tableView.dataSourceTableView?.postId, comment: /self.commentTextView.text) { (statusCode) in
//            MentorzPostViewer.shared.delegate?.handleProgressHUD(shouldShow: false)
            SVProgressHUD.dismiss()
            if statusCode == HttpResponseCodes.success.rawValue{
                self.commentTextView.text = ""
                self.textViewDidChange(self.commentTextView)
                self.tableView.dataSourceTableView?.getCommentForPost(tableView: self.tableView, to: self.tableView.currentPage)
            }
        }
        }
        
    }
 
    func validations()->Bool{
        if commentTextView.text == ""{
            return false
        }else{
            return true
        }
    }
}

extension CommentViewVC:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView)
       {
        if textView.contentSize.height >= self.messageTextViewMaxHeight
        {
            textView.isScrollEnabled = true
        }
        else
            {
                commentHeight.constant = textView.contentSize.height
            textView.isScrollEnabled = false // textView.isScrollEnabled = false for swift 4.0
        }
       }
}
