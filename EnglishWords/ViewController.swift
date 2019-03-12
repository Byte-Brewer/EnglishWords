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

let castomLayer = "one"

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
    
    var isCheckAnswer = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func leftButtonAction(_ sender: UIButton) {
        sender.setImage(UIImage(named: orangeButtonSelect), for: UIControl.State.normal)
        startPosition = sender
    }
    
    @IBAction func rightButtonAction(_ sender: UIButton) {
        if let btn = startPosition {
            let marker = String(btn.tag)
            
            // check and delete Redundant Line
            deleteRedundantLine(startPosition: btn)
            let layer = drawLine(from: btn, to: sender, color: isCheckAnswer ? UIColor.blue : UIColor.gray)
            
            // add layer marker
            layer.name?.append(marker)
            
            // save user answer
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
        isCheckAnswer = true
        for button in leftButtonCollection {
            startPosition = button
            let key = answerModel.rightAnswer[button.tag]
            let secondButton = rightButtonCollection.first(where: {$0.tag == key})
            rightButtonAction(secondButton!)
        }
    }
    
    /// draw line between picture and word
    private func drawLine(from: UIButton, to: UIButton, color: UIColor = .gray) -> CAShapeLayer {
        // find position in contentView
        guard let frameStart = from.superview?.convert(from.frame, to: contentView) else { return CAShapeLayer() }
        guard let frameFinish = to.superview?.convert(to.frame, to: contentView) else { return CAShapeLayer() }
        
        let line = UIBezierPath()
        line.move(to: CGPoint(x: frameStart.maxX, y: frameStart.midY))
        line.addLine(to: CGPoint(x: frameFinish.minX, y: frameFinish.midY))
        
        //design path in layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = line.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 5.0
        shapeLayer.name = castomLayer
        
        return shapeLayer
    }
    
    
    ///  delete Redundant line
    private func deleteRedundantLine(startPosition: UIButton) {
        let marker = castomLayer + String(startPosition.tag)
        if let layer = contentView.layer.sublayers?.filter({$0.name == marker }) {
            layer.forEach({$0.removeFromSuperlayer()})
        }
    }
    
    /// remove all users line and answers
    private func reset() {
        isCheckAnswer = false
        answerLayerDict.removeAll()
        if let layersOne = contentView.layer.sublayers?.filter({$0.name?.hasPrefix(castomLayer) != nil}) {
            layersOne.forEach({$0.removeFromSuperlayer()})
        }
        leftButtonCollection.forEach({$0.setImage(UIImage(named: orangeButtonStart), for: UIControl.State.normal)})
        rightButtonCollection.forEach({$0.setImage(UIImage(named: blueButtonLock), for: UIControl.State.normal)})
    }
    
    /// check user answers
    private func check() {
        for result in answerLayerDict {
            answerLayerDict[result.key]?.1.strokeColor = answerModel.checkAnswer(answer: (result.key, result.value.0)) ? UIColor.green.cgColor : UIColor.red.cgColor
        }
    }
}

