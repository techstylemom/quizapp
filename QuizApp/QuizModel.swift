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
        getRemoteJsonFile()
        
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
            DispatchQueue.main.async {
                self.delegate?.questionsRetrieved(array)
            }
            
            
        } catch {
            // Error: Couldn't download the data at that URL
        }
        
    }
    
    func getRemoteJsonFile() {
        
        // Get a URL object
        let urlString = "https://codewithchris.com/code/QuestionData.json"
        
        let url = URL(string: urlString)
        
        guard url != nil else {
            print("Can't create a URL object")
            return
        }
        
        // Get a URLSession Object
        let session = URLSession.shared
        
        // Get a data task object
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            
            // Check that there wasn't an error
            if error == nil && data != nil {
                
                do {
                    
                    // Create a JSON decoder object
                    let decoder = JSONDecoder()
                    
                    // Parse the JSON
                    let array = try decoder.decode([Question].self, from: data!)
                    
                    // Notify the delegate
                    DispatchQueue.main.async {
                        self.delegate?.questionsRetrieved(array)
                    }
                } catch {
                    print("Couldn't download the data")
                }
   
            }
            
        }
        
        // Call resume on data task
        dataTask.resume()
    }
}
