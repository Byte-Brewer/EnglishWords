//
//  ViewController.swift
//  EnglishWords
//
//  Created by Nazar Prysiazhnyi on 3/11/19.
//  Copyright © 2019 Nazar Prysiazhnyi. All rights reserved.
//

import UIKit

let orangeButtonSelect = "orangeButtonSelect"
let orangeButtonStart = "orangeButtonStart"
let blueButtonLock = "blueButtonLock"
let blueButtonSelect = "blueButtonSelect"

class ViewController: UIViewController {
    
    
    @IBOutlet var leftButtonCollection: [UIButton]!
    @IBOutlet var rightButtonCollection: [UIButton]!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var tryBtn: UIButton!
    @IBOutlet weak var seeAnswersBtn: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    
    let answerModel = AnswersModel()
    var answerLayerDict: [Int:(Int,CAShapeLayer)] = [:]
    
    var startPosition : UIButton? {
        didSet {
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func leftButtonAction(_ sender: UIButton) {
        sender.setImage(UIImage(named: orangeButtonSelect), for: UIControl.State.normal)
        startPosition = sender
    }
    
    @IBAction func rightButtonAction(_ sender: UIButton) {
        if let btn = startPosition {
            let layer = drawLine(from: btn, to: sender)
            deleteRedundantLine(startPosition: btn, endPosition: sender)
            self.answerLayerDict[btn.tag] = (sender.tag, layer)
            self.contentView.layer.addSublayer(layer)
            sender.setImage(UIImage(named: blueButtonLock), for: UIControl.State.normal)
            startPosition = nil
        }
    }
    
    @IBAction func resetAction(_ sender: UIButton) {
        reset()
    }
    
    
    @IBAction func checkAction(_ sender: UIButton) {
        check()
    }
    
    @IBAction func tryAgainAction(_ sender: UIButton) {
        print(#function, sender.tag)
    }
    
    @IBAction func seeAnswersActon(_ sender: UIButton) {
        reset()
        for button in leftButtonCollection {
            startPosition = button
            let key = answerModel.rightAnswer[button.tag]
            let secondButton = rightButtonCollection.first(where: {$0.tag == key})
            rightButtonAction(secondButton!)
        }
    }
    
    /// draw line between picture and word
    private func drawLine(from: UIButton, to: UIButton) -> CAShapeLayer {
        // find position in contentView
        guard let frameStart = from.superview?.convert(from.frame, to: contentView) else { return CAShapeLayer() }
        guard let frameFinish = to.superview?.convert(to.frame, to: contentView) else { return CAShapeLayer() }
        
        let line = UIBezierPath()
        line.move(to: CGPoint(x: frameStart.maxX, y: frameStart.midY))
        line.addLine(to: CGPoint(x: frameFinish.minX, y: frameFinish.midY))
        
        //design path in layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = line.cgPath
        shapeLayer.strokeColor = UIColor.gray.cgColor
        shapeLayer.lineWidth = 5.0
        shapeLayer.name = "one"
        
        return shapeLayer
    }
    
    
    /// try delete Redundant line
    private func deleteRedundantLine(startPosition: UIButton, endPosition: UIButton) {
        
        let line = drawLine(from: startPosition, to: endPosition)
        if let layer = contentView.layer.sublayers?.filter({$0.name == "one"}) {
            print("delete")
            for i in layer {
                if i == line {
                    i.removeFromSuperlayer()
                }
            }
        }
    }
    
    /// remove all users line and answers
    private func reset() {
        answerLayerDict.removeAll()
        _ = contentView.layer.sublayers?.compactMap({$0.name == "one" ? $0.removeFromSuperlayer() : print("NO")})
        leftButtonCollection.forEach({$0.setImage(UIImage(named: orangeButtonStart), for: UIControl.State.normal)})
        rightButtonCollection.forEach({$0.setImage(UIImage(named: blueButtonLock), for: UIControl.State.normal)})
    }
    
    private func check() {
        for result in answerLayerDict {
            answerLayerDict[result.key]?.1.strokeColor = answerModel.checkAnswer(answer: (result.key, result.value.0)) ? UIColor.green.cgColor : UIColor.red.cgColor
        }
    }
}

