//
//  ViewController.swift
//  EnglishWords
//
//  Created by Nazar Prysiazhnyi on 3/11/19.
//  Copyright © 2019 Nazar Prysiazhnyi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var leftButtonCollection: [UIButton]!
    @IBOutlet var rightButtonCollection: [UIButton]!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var tryBtn: UIButton!
    @IBOutlet weak var seeAnswersBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    
    @IBAction func leftButtonAction(_ sender: UIButton) {
        print(#function, sender.tag, sender.frame.maxX, sender.frame.maxY)
    }
    
    
    @IBAction func rightButtonAction(_ sender: UIButton) {
        print(#function, sender.tag)
    }
    
    @IBAction func resetAction(_ sender: UIButton) {
        print(#function, sender.tag)
    }
    
    
    @IBAction func checkAction(_ sender: UIButton) {
        print(#function, sender.tag)
    }
    
    @IBAction func tryAgainAction(_ sender: UIButton) {
        print(#function, sender.tag)
    }
    
    @IBAction func seeAnswersActon(_ sender: UIButton) {
        print(#function, sender.tag)
    }
    
    
}

