//
//  CommentTableViewDataSource.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 04/12/19.
//  Copyright © 2019 Nishit Mishra. All rights reserved.
//

import Foundation
import UIKit
import PagingTableView
class CommentTableViewDataSource:NSObject, UITableViewDataSource,UITableViewDelegate{
    var postId:String?
    var userId : String?
    var delegate : DataForBoard?
    var allComments : [CompleteComment]?
    override init(){}
    convenience init(userId:String,postId:String,comments:[CompleteComment]?){
        self.init()
        self.userId = userId
        self.postId = postId
        self.allComments = []
    }
    deinit {
        self.postId = nil
        self.userId = nil
        self.allComments?.removeAll()
    }
    func getCommentForPost(tableView: PagingTableView? = nil, to pageNumber: Int) {
        PostsRestManager.shared.getCommentsforPostId(userId: /self.userId, postId: /self.postId, pageNumber: pageNumber) { (commentList, statusCode) in
            if /commentList?.commentList?.count > 0{
                tableView?.isHidden = false
            }else{
                tableView?.isHidden = true
            }
            tableView?.refreshControl?.endRefreshing()
            if pageNumber == 0 && /self.allComments?.count > 0{
                    self.allComments?.removeAll()
                }
            if statusCode == HttpResponseCodes.success.rawValue{
                    if let listData = commentList{
                        for comment in listData.commentList ?? []{
                        self.allComments?.append(CompleteComment(comment: comment))
                        }
                    }
                }
                tableView?.isLoading = false
            }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return /self.allComments?.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentViewCell") as! CommentViewCell
        cell.delegate = (tableView as? UserActivities)
        cell.layoutIfNeeded()
        cell.setData(comment: self.allComments?[indexPath.row],postId:/self.postId,userId:/self.userId)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension CommentTableViewDataSource:PagingTableViewDelegate{
    func paginate(_ tableView: PagingTableView, to page: Int) {
        tableView.isLoading = true
        self.getCommentForPost(tableView: tableView, to: page)
    }
}
