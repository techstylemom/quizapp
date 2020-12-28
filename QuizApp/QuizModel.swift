//
//  QuizModel.swift
//  QuizApp
//
//  Created by Irish on 12/28/20.
//  Copyright © 2020 Irish. All rights reserved.
//

import Foundation

protocol QuizProtocol {
    func questionsRetrieved(_ questions: [Question])
}

class QuizModel {
    
    var delegate:QuizProtocol?
    
    func getQuestions() {
        
        // TODO: Fetch the Questions
        
        // notify the delegate of the retrieved questions
        delegate?.questionsRetrieved([Question]())
    }
}
