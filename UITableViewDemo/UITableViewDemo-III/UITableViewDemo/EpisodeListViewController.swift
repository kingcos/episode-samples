//
//  ViewController.swift
//  UITableViewDemo
//
//  Created by Mars on 4/2/16.
//  Copyright © 2016 Boxue. All rights reserved.
//

import UIKit

class EpisodeListViewController: UITableViewController {
    var episodeListItems: [EpisodeListItem] = []
    
    func getEpisodeListItemData() {
        for i in 0..<10 {
            let e = EpisodeListItem()
            e.title = "Episode \(i)"
            e.finished = i % 2 == 0 ? true : false
            
            episodeListItems.append(e)
        }
    }
    
    func documentsDirectory() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return urls[0]
    }
    
    func fileUrl(_ fileName: String) -> URL {
        let documentUrl = self.documentsDirectory().appendingPathComponent(fileName)
        
        return documentUrl
    }
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "EpisodeItem", for: indexPath)
        
        let label = cell.viewWithTag(1024) as! UILabel
        
        let title = self.episodeListItems[indexPath.row].title
        label.text = title
        
        cell.accessoryType = self.episodeListItems[indexPath.row].finished ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func saveEpisodeListItems() {
        // 1. Create a NSMutableData object
        let data = NSMutableData()
        // 2. Create a NSKeyedArchiver for data
        let archiver = NSKeyedArchiver(forWritingWith: data)
        // 3. Encode EpisodeListItems array
        archiver.encode(episodeListItems, forKey: "EpisodeListItems")
        archiver.finishEncoding()
        // 4. Save data to plist file
        let plistUrl = fileUrl("EpisodeList.plist")
        data.write(to: plistUrl, atomically: true)
    }
    
    func loadEpisodeListItems() {
        let plistUrl = fileUrl("EpisodeList.plist")
        
        let fileExists = (plistUrl as NSURL).checkResourceIsReachableAndReturnError(nil)
        
        if fileExists {
            // 1. Create a NSData by plistUrl
            let data = try? Data(contentsOf: plistUrl)
            
            if data != nil {
                // 2. Create a NSKeyedUnarchiver
                let unarchiver = NSKeyedUnarchiver(forReadingWith: data!)
                
                // 3. Decode the object with key EpisodeListItems
                episodeListItems = unarchiver.decodeObject(forKey: "EpisodeListItems") as! [EpisodeListItem]
                unarchiver.finishDecoding()
            }
        }
        else {
            getEpisodeListItemData()
            saveEpisodeListItems()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadEpisodeListItems()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
    
        let documentsDirUrl = documentsDirectory()
        let plistUrl = fileUrl("EpisodeList.plist")
        
        print("Documents dir url: \(documentsDirUrl)")
        print("Plist file url: \(plistUrl)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

