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

    lazy var defManager: SessionManager = {
        // Step 1 Get additional HTTP header
        var defHeaders = Alamofire.SessionManager.default.session.configuration.httpAdditionalHeaders ?? [:]
        
        // Step 2 Set a NSURLSessionConfiguration
        let conf = URLSessionConfiguration.default
        conf.httpAdditionalHeaders = defHeaders
        
        // Step 3 Generate a manager
        return Alamofire.SessionManager(configuration: conf)
    }()
    
    lazy var backgroundManager: SessionManager = {
        // Step 1 Get additional HTTP header
        var defHeaders = Alamofire.SessionManager.default.session.configuration.httpAdditionalHeaders ?? [:]
        
        // Step 2 Set a NSURLSessionConfiguration
        let conf = URLSessionConfiguration.background(withIdentifier: "io.boxue.api.background")
        conf.httpAdditionalHeaders = defHeaders
        
        // Step 3 Generate a manager
        return Alamofire.SessionManager(configuration: conf)
    }()
    
    lazy var ephemeralManager: SessionManager = {
        // Step 1 Get additional HTTP header
        var defHeaders = Alamofire.SessionManager.default.session.configuration.httpAdditionalHeaders ?? [:]
        
        // Step 2 Set a NSURLSessionConfiguration
        let conf = URLSessionConfiguration.ephemeral
        conf.httpAdditionalHeaders = defHeaders
        
        // Step 3 Generate a manager
        return Alamofire.SessionManager(configuration: conf)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let requestUrl = "https://apidemo.boxue.io/alamofire"
        
        let manager = Alamofire.SessionManager.default
        defManager.request(requestUrl, method: .get)
            .responseString(completionHandler: { response in
                switch response.result {
                case .success(let str):
                    print("Response String: =================")
                    print("\(str)")
                case .failure(let error):
                    print("\(error)")
                }
            })


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
