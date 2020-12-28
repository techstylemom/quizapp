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
        
        // Fetch the Questions
        getLocalJsonFile()
        
    }
    
    func getLocalJsonFile() {
        
        // Get the path to json file
        let path = Bundle.main.path(forResource: "questionData", ofType: "json")
        
        // Double check if path is not nil
        guard path != nil else {
            print("Couldn't find the json data file")
            return
        }
        
        // Create a URL Object from the path
        let url = URL(fileURLWithPath: path!)
        
        do {
            // Get the data from the url
            let data = try Data(contentsOf: url)
            
            // Try to decode data into objects
            let decoder = JSONDecoder()
            let array = try decoder.decode([Question].self, from: data)
            
            // Notify the delegate of the parsed objects
             delegate?.questionsRetrieved(array)
            
        } catch {
            // Error: Couldn't download the data at that URL
        }
     
    }
    
    func getRemoteJsonFile() {
        
    }
}
