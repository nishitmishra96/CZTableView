//
//  Protocols.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 26/11/19.
//  Copyright © 2019 Nishit Mishra. All rights reserved.
//

import Foundation
import UIKit
protocol DataForBoard {
    func reloadTableView()
    func newPostsAppended(oldList:[CompletePost],newList:[CompletePost])
    func newCommentAppended(oldList:[CompleteComment],newList:[CompleteComment])
}


protocol UserActivities{
    func userCommented(postId:Int)
    func userDeletedComment(completeComment:CompleteComment)
    func userPressedReadButton(post:CompletePost?)
    func reloadTableView(forPost:CompletePost?)
}

protocol ImagePickerDelegate {
    func donePressed()
    func imagePickerDissmissed()
}

protocol UploadPostProgressDelegate{
    func progressChangedwith(value:Float)
}

protocol PostUploadCancelled{
    func uploadCancelled()
}
