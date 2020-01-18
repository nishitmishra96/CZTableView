//
//  CommentViewVC.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 04/12/19.
//  Copyright © 2019 Nishit Mishra. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
class CommentViewVC: UIViewController {
   
    @IBOutlet weak var tableView: CommentTableView!
    @IBOutlet weak var CommentTextField: UITextField!
    @IBOutlet weak var commentTitleLabel: UILabel!
    @IBOutlet weak var messegeLabel: UILabel!
    var refreshCellCommentCount:((Int)->())?
    var dataSource : CommentTableViewDataSource?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib.init(nibName: "CommentViewCell", bundle: Bundle.init(identifier: "com.craterzone.MentorzPostViewer")), forCellReuseIdentifier: "CommentViewCell")
        UIApplication.shared.statusBarUIView?.backgroundColor = UIColor.redThemeColor
        self.commentTitleLabel.font = UIFont.appFont(font: Fonts.regular, size: FontSize.largeTextFont)
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
        MentorzPostViewer.shared.delegate?.handleProgressHUD(shouldShow: true)
        PostsRestManager.shared.userCommentedOnAPost(userId: /MentorzPostViewer.shared.dataSource?.getUserId(), postId: /self.tableView.dataSourceTableView?.postId, comment: /self.CommentTextField.text) { (statusCode) in
            MentorzPostViewer.shared.delegate?.handleProgressHUD(shouldShow: false)
            if statusCode == HttpResponseCodes.success.rawValue{
                self.CommentTextField.text = ""
                self.tableView.dataSourceTableView?.getCommentForPost(tableView: self.tableView, to: self.tableView.currentPage)
            }
        }
        
    }
}
extension UIApplication {
var statusBarUIView: UIView? {

    if #available(iOS 13.0, *) {
        let tag = 3848245

        let keyWindow = UIApplication.shared.connectedScenes
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows.first

        if let statusBar = keyWindow?.viewWithTag(tag) {
            return statusBar
        } else {
            let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
            let statusBarView = UIView(frame: height)
            statusBarView.tag = tag
            statusBarView.layer.zPosition = 999999

            keyWindow?.addSubview(statusBarView)
            return statusBarView
        }

    } else {

        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
    }
    return nil
  }
}
