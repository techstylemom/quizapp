//
//  ViewController.swift
//  QuizApp
//
//  Created by Irish on 12/28/20.
//  Copyright © 2020 Irish. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var model = QuizModel()
    var questions = [Question]()
    var currentQuestionIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        model.getQuestions()
    }
}

//MARK: - Quiz Protocol Methods
extension ViewController: QuizProtocol {
    
    func questionsRetrieved(_ questions: [Question]) {
        print("questions retrieved from model")
    }
    
}
