//
//  EpisodeListItem.swift
//  UITableViewDemo
//
//  Created by Mars on 4/8/16.
//  Copyright © 2016 Boxue. All rights reserved.
//

import Foundation

class EpisodeListItem: NSObject, NSCoding {
    var title = ""
    var finished = false
    
    // Methods in NSCoding
    // How to encode EpisodeListItem attributes
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "Title")
        aCoder.encode(finished, forKey: "Finished")
    }
    
    required init?(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: "Title") as! String
        finished = aDecoder.decodeBool(forKey: "Finished")
        super.init()
    }
    
    override init() {
        super.init()
    }
}
