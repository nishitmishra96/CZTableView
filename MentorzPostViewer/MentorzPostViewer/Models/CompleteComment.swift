//
//  CompleteComment.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 06/12/19.
//  Copyright © 2019 Nishit Mishra. All rights reserved.
//

import Foundation
public class CompleteComment:NSObject{
    public var comment:Comment?    
    init(comment:Comment?){
        self.comment = comment
    }
    override init(){
        super.init()
    }
}
