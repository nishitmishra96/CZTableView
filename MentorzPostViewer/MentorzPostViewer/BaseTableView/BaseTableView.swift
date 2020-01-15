//
//  BaseTableView.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 28/11/19.
//  Copyright © 2019 Nishit Mishra. All rights reserved.
//

import UIKit
import PagingTableView

public class BaseTableView: PagingTableView {
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    override public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setUp()
    }

    open override func awakeFromNib() {
        setUp()
    }
    
    private func setUp(){
        self.register(UINib.init(nibName: "PostTableViewCell", bundle: Bundle.init(identifier: "com.craterzone.MentorzPostViewer")), forCellReuseIdentifier: "PostTableViewCell")
        self.register(UINib.init(nibName: "UploadProgressCell", bundle: Bundle.init(identifier: "com.craterzone.MentorzPostViewer")), forCellReuseIdentifier: "UploadProgressCell")
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        self.allowsSelection = false
        self.estimatedRowHeight = UITableView.automaticDimension
        self.rowHeight = UITableView.automaticDimension
        self.separatorStyle = .none
    }
    
    @objc func didPullToRefresh(){
        self.refreshControl?.beginRefreshing()
    }
    
    func updateTableViewForNewAppendedData(oldList: Int, newList: Int) {
        self.beginUpdates()
        var indexes = [IndexPath]()
        for count in 0..<(newList - oldList){
            let indexpath = IndexPath(row: (oldList - 1) + count, section: 0)
            indexes.append(indexpath)
        }
        self.insertRows(at: indexes, with: .none)
        self.endUpdates()
    }
}
