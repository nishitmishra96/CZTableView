//
//  TableViewForComments.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 05/12/19.
//  Copyright © 2019 Nishit Mishra. All rights reserved.
//
import UIKit
import PagingTableView
import ExpandableLabel
open class CommentTableView:PagingTableView {
    var dataSourceTableView : CommentTableViewDataSource?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setUp()
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    func setUp(){
        self.register(UINib.init(nibName: "CommentViewCell", bundle: Bundle.init(identifier: "com.craterzone.MentorzPostViewer")), forCellReuseIdentifier: "CommentViewCell")
        self.allowsSelection = false
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = UITableView.automaticDimension
        self.separatorStyle = .none
    }

    
    public func getCommentList(userId:String,postId:String,comments:[CompleteComment]?){
        self.dataSourceTableView = CommentTableViewDataSource(userId: userId, postId: postId,comments:comments)
        dataSourceTableView?.delegate = self
        pagingDelegate = dataSourceTableView
        self.dataSource = dataSourceTableView
        self.delegate = dataSourceTableView
    }
}

extension CommentTableView:DataForBoard{
    func newCommentAppended(oldList: [CompleteComment], newList: [CompleteComment]) {
        self.beginUpdates()
        var indexes = [IndexPath]()
        for count in 0..<(newList.count - oldList.count){
            let indexpath = IndexPath(row: (oldList.count - 1) + count, section: 0)
            indexes.append(indexpath)
        }
        self.insertRows(at: indexes, with: .none)
        self.endUpdates()
//        self.beginUpdates()
//        self.cellForRow(at: indexes.first ?? IndexPath())?.layoutIfNeeded()
//        self.endUpdates()

    }
    
    func newPostsAppended(oldList: [CompletePost], newList: [CompletePost]) {
    }
    
   @objc func reloadTableView() {
        self.reloadData()
    }
    
    func removeCell(){
        
    }

}

extension CommentTableView: UserActivities{
    func reloadTableView(forPost: CompletePost?) {
        
    }
    
    func userPressedReadButton(post:CompletePost?) {
        
    }
    

    
    func userDeletedComment(completeComment:CompleteComment) {
        let index = self.dataSourceTableView?.allComments?.firstIndex(of: completeComment)
        self.dataSourceTableView?.allComments?.remove(at: index!)
        let indexPath = IndexPath(row: /index, section: 0)
        self.beginUpdates()
        self.deleteRows(at: [indexPath], with: .automatic)
        self.endUpdates()
    }

    
    func userCommented(postId: Int) {
//        self.userCommented(postId: postId)
    }
}
