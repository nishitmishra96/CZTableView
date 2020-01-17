//
//  MentorzPostViewer.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 10/01/20.
//  Copyright © 2020 Nishit Mishra. All rights reserved.
//

import UIKit
@objc public protocol MentorzPostViewerDelegates{
    @objc  func handleUnsportedStatusCode(statusCode:Int)
    @objc  func showSucessMessage(message:String)
    @objc  func handleErrorMessage(error:String)
    @objc  func handleProgressHUD(shouldShow:Bool)
}
@objc public protocol MentorzPostViewerDatasource{
    @objc func authToken()->String
    @objc func getUserId()->String
    @objc func getUserAgent()->String
    @objc func getEnvironmentStatus()->Bool
}

@objc public protocol MentorzUserActivitiesDelegates{
    @objc func profileImageClicked(userId:String!,username:String!)
    @objc func askShareOnFacebook(postText:String!,url:String!)
    @objc func trackShareEvent(pstId:String,withActivityType:String)
}
@objc public  class MentorzPostViewer: NSObject {
    @objc public static var shared = MentorzPostViewer()
    /// Always use it with single instance with higest level of abstarction like: Appdelegate or Any manager which actually have direct access to the Data
    @objc public var dataSource:MentorzPostViewerDatasource?
    @objc public var userActivitiesDelegate : MentorzUserActivitiesDelegates?
    
    /// Always use it with single instance with higest level of abstarction like: Appdelegate or Any manager which actually have direct access to handle Error display and showing Progress Hud which are blocking by its nature unless activity is finished
    @objc public var delegate:MentorzPostViewerDelegates?
    private override init() {
        super.init()
    }
    @objc public func setEnvironment(isStaging:Bool){
        URLGenerator.shared.isStaging = isStaging
    }
}
