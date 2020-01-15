//
//  Storyboards.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 04/12/19.
//  Copyright © 2019 Nishit Mishra. All rights reserved.
//

import Foundation
import UIKit
enum Storyboard: String {
    //    Normal App StoryBoards
    case home = "home"
    var instance: UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: Bundle(identifier: "com.craterzone.MentorzPostViewer"))
    }
    
    func instanceOf<T: UIViewController>(viewController: T.Type) -> T? {
        let x = String(describing: viewController.self)
        return instance.instantiateViewController(withIdentifier: x) as? T
    }
}
