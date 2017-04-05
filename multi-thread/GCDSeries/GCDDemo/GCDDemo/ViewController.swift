//
//  ViewController.swift
//  GCDDemo
//
//  Created by Mars on 1/30/16.
//  Copyright © 2016 Boxue. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    
    let imageUrls = [
        "https://dn-boxueio.qbox.me/image1-big.jpg",
        "https://dn-boxueio.qbox.me/image2-big.jpg",
        "https://dn-boxueio.qbox.me/image3-big.jpg",
        "https://dn-boxueio.qbox.me/image4-big.jpg"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clearDownload(_ sender: UIButton) {
        self.image1.image = nil
        self.image2.image = nil
        self.image3.image = nil
        self.image4.image = nil
        
        URLCache.shared.removeAllCachedResponses()
    }

    @IBAction func downloadImages(_ sender: UIButton) {
        // Create serial queue
        let serialQueue1 = DispatchQueue(label: "com.boxueio.images", attributes: [])
        // Add task
        serialQueue1.async(execute: {
            let img1 = Downloader.downloadImageWithURL(self.imageUrls[0])
            DispatchQueue.main.async(execute: {
                self.image1.image = img1
                self.image1.clipsToBounds = true
            })
            
            
            let img3 = Downloader.downloadImageWithURL(self.imageUrls[2])
            DispatchQueue.main.async(execute: {
                self.image3.image = img3
                self.image3.clipsToBounds = true
            })
            
        })
        let serialQueue2 = DispatchQueue(label: "com.boxueio.images1", attributes: [])
        
        serialQueue2.async(execute: {
            let img2 = Downloader.downloadImageWithURL(self.imageUrls[1])
            DispatchQueue.main.async(execute: {
                self.image2.image = img2
                self.image2.clipsToBounds = true
            })
            
            let img4 = Downloader.downloadImageWithURL(self.imageUrls[3])
            DispatchQueue.main.async(execute: {
                self.image4.image = img4
                self.image4.clipsToBounds = true
            })
        })

    }
}

