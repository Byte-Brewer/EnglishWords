//
//  ViewController.swift
//  EnglishWords
//
//  Created by Nazar Prysiazhnyi on 3/11/19.
//  Copyright © 2019 Nazar Prysiazhnyi. All rights reserved.
//

import UIKit

let castomLayer = "one"

class ViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet var leftButtonCollection: [UIButton]!
    @IBOutlet var rightButtonCollection: [UIButton]!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var tryBtn: UIButton!
    @IBOutlet weak var seeAnswersBtn: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    // MARK: - properties
    private let answerModel = AnswersModel()
    private var answerLayerDict: [Int:(Int,CAShapeLayer)] = [:]
    
    private var startPosition : UIButton?
    private var isCheckAnswer = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - action
    @IBAction func leftButtonAction(_ sender: UIButton) {
        sender.setImage(#imageLiteral(resourceName: "orangeButtonSelect"), for: UIControl.State.normal)
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
            sender.setImage( #imageLiteral(resourceName: "blueButtonLock"), for: UIControl.State.normal)
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
            if let secondButton = rightButtonCollection.first(where: {$0.tag == key}) {
                rightButtonAction(secondButton)
            }
        }
    }
    
    
    // MARK: - custom function
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
        leftButtonCollection.forEach({$0.setImage(#imageLiteral(resourceName: "orangeButtonStart"), for: UIControl.State.normal)})
        rightButtonCollection.forEach({$0.setImage(#imageLiteral(resourceName: "blueButtonSelect"), for: UIControl.State.normal)})
    }
    
    /// check user answers
    private func check() {
        for result in answerLayerDict {
            answerLayerDict[result.key]?.1.strokeColor = answerModel.checkAnswer(answer: (result.key, result.value.0)) ? #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1) : #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
    }
}

