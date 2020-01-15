//
//  BoardPostController.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 11/01/20.
//  Copyright © 2020 Nishit Mishra. All rights reserved.
//

import UIKit
import Foundation
import PagingTableView
protocol BasePostController:UITableViewDataSource,UITableViewDelegate,PagingTableViewDelegate {
    var userID:String {get set}
    var tableView:BaseTableView? {get set}
    var boardPostOriginal:[CompletePost] {get set}
    var postToShowOnUI:[CompletePost]{get set}
    var filterPostString:String? {get set}
    func getPost(forPage:Int)
}
protocol RegularPostController:BasePostController{
    var restDataSource:RestDataSource? {get set}
}

class PostController: NSObject,RegularPostController {

    internal var userID:String
    internal weak var tableView:BaseTableView?
    internal var boardPostOriginal:[CompletePost] = []
    internal var postToShowOnUI:[CompletePost] = []
    private var interest : [Int] = []
    internal var restDataSource:RestDataSource?
//    private var otherUserProfile:OtherUserProfile?
    var filterPostString:String?{
        didSet{
            if /filterPostString == ""{
                self.postToShowOnUI = boardPostOriginal
            }else{
                self.postToShowOnUI = boardPostOriginal.filter({ (post) -> Bool in
                    return /post.post?.content?.postText?.lowercased().contains(/filterPostString?.lowercased()) || /post.post?.name?.lowercased().contains(/filterPostString?.lowercased())  || /post.post?.lastName?.lowercased().contains(/filterPostString?.lowercased())
                })
            }
        }
    }
    init(foruserProfile userid:String, base tableView:BaseTableView){
        self.userID = userid
        self.tableView = tableView
        super.init()
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.restDataSource = profileDataSource(user: self.userID)
        self.getPost(forPage: 0)
    }
    init(foruserProfile userid:String,otherUserId:String, base tableView:BaseTableView){
            self.userID = userid
            self.tableView = tableView
            super.init()
            self.tableView?.dataSource = self
            self.tableView?.delegate = self
            self.restDataSource = profileDataSource(userId: userid, otherUserID: otherUserId)
        self.getPostOfOtherUser(forPage: 0)
        }
    init(userid:String,base tableView:BaseTableView){
        self.userID = userid
        self.tableView = tableView
        super.init()
        self.restDataSource = BoardPost(user: userid)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.getPost(forPage: 0)
    }
    init(userid:String,base tableView:BaseTableView,interestList:[Int]) {
        self.userID = userid
        self.tableView = tableView
        self.interest = interestList
        self.restDataSource = InterestDataSource(user: userid, InterestList: interestList)
        super.init()
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.getPost(forPage: 0)
    }
    init(userid:String,postid:String,base tableView:BaseTableView)
    {
        self.userID = userid
        self.tableView = tableView
        self.restDataSource = SinglePostDataSource(postId: postid)
        super.init()
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.getPost(forPage: 0)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
//            return /uploadPostManager?.currentlyUploadPost.count
            return UploadPostManager.shared.request != nil ? 1 : 0
        }
        return self.postToShowOnUI.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "UploadProgressCell", for: indexPath) as! UploadProgressCell
            cell.indexPath = indexPath
            cell.delegate = self
            UploadPostManager.shared.delegate = cell
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        cell.cellDelegate = self
        cell.indexPath =  indexPath
        cell.setData(cellPost: postToShowOnUI[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if UploadPostManager.shared.request == nil && indexPath.section == 1{
            PostsRestManager.shared.updatePostViewCount(userId: /MentorzPostViewer.shared.dataSource?.getUserId(), postId: "\(String(describing: /self.postToShowOnUI[indexPath.row].post?.postId))") { (statusCode) in
                if statusCode == HttpResponseCodes.NotFound.rawValue{
                    self.postToShowOnUI[indexPath.row].post?.viewCount = (self.postToShowOnUI[indexPath.row].post?.viewCount ?? 0) + 1
                    (cell as! PostTableViewCell).viewCount.text = (/self.postToShowOnUI[indexPath.row].post?.viewCount > 1) ? "\(/self.postToShowOnUI[indexPath.row].post?.viewCount) views " : "\(/self.postToShowOnUI[indexPath.row].post?.viewCount) view"
                    print("view count increased")
                }else{
                    print("view count not increased")
                }
            }
        }
    }
    public func paginate(_ tableView: PagingTableView, to page: Int) {
        self.getPost(forPage: page)
    }
    public func InsertNewRow(withPost:Post){
        self.tableView?.reloadSections(IndexSet(integersIn: 0...0), with: UITableView.RowAnimation.top)
        self.postToShowOnUI.insert(CompletePost(post: withPost), at: 0)
        self.boardPostOriginal.insert(CompletePost(post: withPost), at: 0)
        self.tableView?.beginUpdates()
        self.tableView?.insertRows(at: [IndexPath(row: 0, section: 1)], with: .bottom)
        self.tableView?.endUpdates()
        }
}
extension PostController{
    public func getPost(forPage:Int){
        self.restDataSource?.getPost(forPage: forPage, handler: { (postList, statusCode) in
            self.tableView?.refreshControl?.endRefreshing()
            if forPage == 0 && /self.boardPostOriginal.count > 0{
                self.boardPostOriginal.removeAll()
                self.tableView?.reloadData()
                self.tableView?.reset()
            }
            if statusCode == 200{
                if let listData = postList{
                    let oldList = self.postToShowOnUI
                    for post in listData {
                        self.boardPostOriginal.append(post)
                    }
//                    self.tableView?.updateTableViewForNewAppendedData(oldList: oldList.count, newList: self.postToShowOnUI.count)
                }
            }
            let str = self.filterPostString
            self.filterPostString = str
            self.tableView?.isLoading = false
            self.tableView?.reloadData()
            (self.tableView as? BoardPostUITableView)?.statusCodeDelegate?.didReceiveForTableViewData(with: statusCode)
            if self.boardPostOriginal.count == 0{
                (self.tableView as? BoardPostUITableView)?.label?.isHidden = false
            }else{
                (self.tableView as? BoardPostUITableView)?.label?.isHidden = true

              }
        })
    }
    public func getPostOfOtherUser(forPage:Int){
        (self.restDataSource as? profileDataSource)?.getPostOfOtherUser(forPage: forPage, handler: { (postList, statusCode) in
               self.tableView?.refreshControl?.endRefreshing()
               if forPage == 0 && /self.boardPostOriginal.count > 0{
                   self.boardPostOriginal.removeAll()
                   self.tableView?.reloadData()
                   self.tableView?.reset()
               }
               if statusCode == 200{
                   if let listData = postList{
                       let oldList = self.postToShowOnUI
                       for post in listData {
                           self.boardPostOriginal.append(post)
                       }
                       self.tableView?.updateTableViewForNewAppendedData(oldList: oldList.count, newList: self.postToShowOnUI.count)
                   }
               }
               let str = self.filterPostString
               self.filterPostString = str
               self.tableView?.isLoading = false
               self.tableView?.reloadData()
               if self.boardPostOriginal.count == 0{
                   (self.tableView as? BoardPostUITableView)?.label?.isHidden = false
               }else{
                   (self.tableView as? BoardPostUITableView)?.label?.isHidden = true

                 }
           })
       }
}
extension PostController:PostTableViewCellDelegate{
    
    func shouldRemoveCell(indexPath: IndexPath) {
        if (indexPath.section != 0){
            self.tableView?.beginUpdates()
            self.boardPostOriginal = self.boardPostOriginal.filter { (post) -> Bool in
                return (post.post?.postId != postToShowOnUI[indexPath.row].post?.postId)
            }
            self.tableView?.deleteRows(at: [indexPath], with: .left)
            self.tableView?.endUpdates()
        }else{
            self.tableView?.beginUpdates()
            self.tableView?.deleteRows(at: [indexPath], with: .automatic)
            self.tableView?.endUpdates()
        }
        let filterDataString = self.filterPostString
        self.filterPostString = filterDataString
    }
    func reloadTableView(indexPath: IndexPath) {
        self.tableView?.reloadRows(at: [indexPath], with: .automatic)
    }
    func updateLayout(indexPath: IndexPath) {
        self.tableView?.beginUpdates()
        tableView?.cellForRow(at: indexPath)?.layoutIfNeeded()
        self.tableView?.endUpdates()
    }
}
//
//
//class OtherUserProfilePostController:NSObject,ProfilePostController{
//    var userID: String
//    var tableView: BaseTableView?
//    var boardPostOriginal: [CompletePost]
//    var postToShowOnUI: [CompletePost]
//    var otherUserProfile: OtherUserProfile?
//    var filterPostString: String?{
//        didSet{
//            if /filterPostString == ""{
//                self.postToShowOnUI = boardPostOriginal
//            }else{
//                self.postToShowOnUI = boardPostOriginal.filter({ (post) -> Bool in
//                    return /post.post?.content?.postText?.lowercased().contains(/filterPostString?.lowercased()) || /post.post?.name?.lowercased().contains(/filterPostString?.lowercased())  || /post.post?.lastName?.lowercased().contains(/filterPostString?.lowercased())
//                })
//            }
//        }
//    }
//
//
//    init(userid:String,otherUserId:String,base tableView:BaseTableView){
//        self.userID = userid
//        self.tableView  = tableView
//        self.otherUserProfile = OtherUserProfile(userId: userid, otherUserId: otherUserId)
//        self.tableView?.dataSource = self
//        self.tableView?.delegate = self
//    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0{
////            return /uploadPostManager?.currentlyUploadPost.count
//            return UploadPostManager.shared.request != nil ? 1 : 0
//        }
//        return self.postToShowOnUI.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "UploadProgressCell", for: indexPath) as! UploadProgressCell
//            cell.indexPath = indexPath
//            cell.delegate = self
//            UploadPostManager.shared.delegate = cell
//            return cell
//        }
//        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
//        cell.cellDelegate = self
//        cell.indexPath =  indexPath
//        cell.setData(cellPost: postToShowOnUI[indexPath.row])
//        return cell
//    }
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if UploadPostManager.shared.request == nil && indexPath.section == 1{
//            PostsRestManager.shared.updatePostViewCount(userId: /MentorzPostViewer.shared.dataSource?.getUserId(), postId: "\(String(describing: /self.postToShowOnUI[indexPath.row].post?.postId))") { (statusCode) in
//                if statusCode == HttpResponseCodes.NotFound.rawValue{
//                    self.postToShowOnUI[indexPath.row].post?.viewCount = (self.postToShowOnUI[indexPath.row].post?.viewCount ?? 0) + 1
//                    (cell as! PostTableViewCell).viewCount.text = (/self.postToShowOnUI[indexPath.row].post?.viewCount > 1) ? "\(/self.postToShowOnUI[indexPath.row].post?.viewCount) views " : "\(/self.postToShowOnUI[indexPath.row].post?.viewCount) view"
//                    print("view count increased")
//                }else{
//                    print("view count not increased")
//                }
//            }
//        }
//    }
//    public func paginate(_ tableView: PagingTableView, to page: Int) {
//        self.getPost(forPage: page){(statusCode) in
//        }
//    }
//    public func InsertNewRow(withPost:Post){
//        self.tableView?.reloadSections(IndexSet(integersIn: 0...0), with: UITableView.RowAnimation.top)
//        self.postToShowOnUI.insert(CompletePost(post: withPost), at: 0)
//        self.boardPostOriginal.insert(CompletePost(post: withPost), at: 0)
//        self.tableView?.beginUpdates()
//        self.tableView?.insertRows(at: [IndexPath(row: 0, section: 1)], with: .bottom)
//        self.tableView?.endUpdates()
//        }
//}
//extension OtherUserProfilePostController{
//    public func getPost(forPage:Int,handler:@escaping ((Int)->())){
//        self.otherUserProfile?.getPost(forPage: forPage, handler: { (postList, statusCode) in
//            self.tableView?.refreshControl?.endRefreshing()
//            if forPage == 0 && /self.boardPostOriginal.count > 0{
//                self.boardPostOriginal.removeAll()
//                self.tableView?.reloadData()
//                self.tableView?.reset()
//            }
//            if statusCode == 200{
//                if let listData = postList{
//                    let oldList = self.postToShowOnUI
//                    for post in listData {
//                        self.boardPostOriginal.append(post)
//                    }
//                    self.tableView?.updateTableViewForNewAppendedData(oldList: oldList.count, newList: self.postToShowOnUI.count)
//                }
//            }
//            let str = self.filterPostString
//            self.filterPostString = str
//            self.tableView?.isLoading = false
//            self.tableView?.reloadData()
//            handler(statusCode)
//            if self.boardPostOriginal.count == 0{
//                (self.tableView as? BoardPostUITableView)?.label?.isHidden = false
//            }else{
//                (self.tableView as? BoardPostUITableView)?.label?.isHidden = true
//
//              }
//        })
//    }
//}
//extension OtherUserProfilePostController:PostTableViewCellDelegate{
//
//    func shouldRemoveCell(indexPath: IndexPath) {
//        if (indexPath.section != 0){
//            self.tableView?.beginUpdates()
//            self.boardPostOriginal = self.boardPostOriginal.filter { (post) -> Bool in
//                return (post.post?.postId != postToShowOnUI[indexPath.row].post?.postId)
//            }
//            self.tableView?.deleteRows(at: [indexPath], with: .left)
//            self.tableView?.endUpdates()
//        }else{
//            self.tableView?.beginUpdates()
//            self.tableView?.deleteRows(at: [indexPath], with: .automatic)
//            self.tableView?.endUpdates()
//        }
//        let filterDataString = self.filterPostString
//        self.filterPostString = filterDataString
//    }
//    func reloadTableView(indexPath: IndexPath) {
//        self.tableView?.reloadRows(at: [indexPath], with: .automatic)
//    }
//    func updateLayout(indexPath: IndexPath) {
//        self.tableView?.beginUpdates()
//        tableView?.cellForRow(at: indexPath)?.layoutIfNeeded()
//        self.tableView?.endUpdates()
//    }
//}
