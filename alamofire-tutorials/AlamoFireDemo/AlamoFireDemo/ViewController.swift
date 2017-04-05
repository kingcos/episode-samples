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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Alamofire.request("https://httpbin.org/get", method: .get)
            .response { response in
                print(response.request ?? "nil")
                print(response.response ?? "nil")
                print(response.data ?? "nil")
                print(type(of: response.data))
                print(response.error ?? "nil")
                print(type(of: response.error))
            }
            .responseString(completionHandler: { response in
                print("String ===============")
                
                switch response.result {
                case .success(let str):
                    print("\(type(of: str))")
                    print("\(str)")
                case .failure(let error):
                    print("\(error)")
                }
            })
            .responseJSON(completionHandler: { response in
                print("JSON ================")
                
                switch response.result {
                case .success(let json):
                    let dict = json as! Dictionary<String, Any>
                    let origin = dict["origin"] as! String
                    let headers = dict["headers"] as! Dictionary<String, String>
                    
                    print("origin: \(origin)")
                    let ua = headers["User-Agent"] ?? "nil"
                    print("UA: \(ua)")
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










