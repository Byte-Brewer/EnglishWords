//
//  AnswersModel.swift
//  EnglishWords
//
//  Created by Nazar Prysiazhnyi on 3/12/19.
//  Copyright © 2019 Nazar Prysiazhnyi. All rights reserved.
//

import Foundation

struct AnswersModel {
    let rightAnswer: [Int: Int] = [0:2, 1:6, 2:1, 3:7, 4:0, 5:4, 6:5, 7:3]
    func checkAnswer(answer: (Int,Int)) -> Bool {
        return rightAnswer[answer.0] == answer.1
    }
}
