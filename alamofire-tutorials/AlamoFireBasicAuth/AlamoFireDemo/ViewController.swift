//
//  ViewController.swift
//  AlamoFireDemo
//
//  Created by Mars on 2/11/16.
//  Copyright © 2016 Boxue. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    @IBOutlet weak var progress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let user = "11@boxue.io"
        let pw = "boxue"
        let requestUrl = "https://apidemo.boxue.io/alamofire"
        let credential = URLCredential(user: user, password: pw, persistence: .forSession)

        // 1. use the authenticate method
//        Alamofire.request(requestUrl, method: .post)
////            .authenticate(user: user, password: pw)
//            .authenticate(usingCredential: credential)
//            .responseJSON(completionHandler: { response in
//                debugPrint(response)
//            })

        // 2. Construct a HTTP header manually
        // user:pw
        let credentialData = "\(user):\(pw)".data(using: String.Encoding.utf8)!
        // base64 encoding
        let base64Credentials = credentialData.base64EncodedString(options: [])
        // construct a header like POSTMAN
        let header = ["Authorization": "Basic \(base64Credentials)"]
        
        Alamofire.request(requestUrl, method: .post, headers: header)
            .responseJSON(completionHandler: { response in
                debugPrint(response)
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



















