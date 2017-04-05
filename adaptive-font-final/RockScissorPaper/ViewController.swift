//
//  ViewController.swift
//  RockScissorPaper
//
//  Created by Mars on 12/30/15.
//  Copyright © 2015 Boxue. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var doraChoice: UIImageView!
    @IBOutlet weak var yourChoice: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var choices = ["rock", "scissor", "paper"]
    
    func getResult(_ myChoiceIndex: Int) -> String {
        if myChoiceIndex == 0 {
            return "Equal"
        }
        else if myChoiceIndex == 1 {
            return "Dora wins!"
        }
        else {
            return "You Win!"
        }
    }
    
    @IBAction func gameBegin(_ sender: UIButton) {
        let title = "Game result"
    
        self.doraChoice.image = UIImage(named: "rock")
        
        let randomIndex = Int(arc4random()) % 3
        let message = self.getResult(randomIndex)
        self.yourChoice.image = UIImage(named: choices[randomIndex])
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }

}


















