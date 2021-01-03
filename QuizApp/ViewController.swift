//
//  ViewController.swift
//  QuizApp
//
//  Created by Irish on 12/28/20.
//  Copyright © 2020 Irish. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var model = QuizModel()
    var questions = [Question]()
    var currentQuestionIndex = 0
    var numCorrect = 0
    
    var resultDialog: ResultViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the result dialog
        resultDialog = storyboard?.instantiateViewController(identifier: "ResultVC") as? ResultViewController
        resultDialog?.modalPresentationStyle = .overCurrentContext
        resultDialog?.delegate = self
        
        // Set self as the delegate and datasource for the tableview
        tableView.delegate = self
        tableView.dataSource = self
        
        // Dynamic row heights
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        // Setup the model
        model.delegate = self
        model.getQuestions()
    }
    
    func displayQuestion() {
        
        // Check if there are questions and check that the currentQuestionIndex is not out of bounds
        guard questions.count > 0 && currentQuestionIndex < questions.count else {
            return
        }
        
        // Display the question text
        questionLabel.text = questions[currentQuestionIndex].question
        
        // Reload the tableview
        tableView.reloadData()
    }
}

//MARK: - TableView Delegate and Datasource Methods
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Make sure that the questions array actually contains a question
        guard questions.count > 0 else {
            return 0
        }
        // return the number of answers to the questions
        let currentQuestion = questions[currentQuestionIndex]
        if currentQuestion.answers != nil {
            return currentQuestion.answers!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath)
        
        let label = cell.viewWithTag(1) as? UILabel
        
        if label != nil {
            
            let question = questions[currentQuestionIndex]
            
            if question.answers != nil && indexPath.row < question.answers!.count {
                // Set the answer text for the label
                label!.text = question.answers![indexPath.row]
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var titleText = ""
        // User has a tapped on a row, check if it's the right answer
        let question = questions[currentQuestionIndex]
        
        if question.correctAnswerIndex! == indexPath.row {
            
            // User got it right
            print("User got it right")
            
            titleText = "Correct"
            numCorrect += 1
            
        } else {
            // User got it wrong
            print("User got it wrong")
            
            titleText = "Wrong"
        }
        
        // Show the popup
        if resultDialog != nil {
            
            // Customize the dialog text
            resultDialog!.titleText = titleText
            resultDialog!.feedbackText = question.feedback!
            resultDialog!.buttonText = "Next"
            present(resultDialog!, animated: true, completion: nil)
        }
        
    }
    
}


//MARK: - Quiz Protocol Methods
extension ViewController: QuizProtocol {
    
    func questionsRetrieved(_ questions: [Question]) {
        // Get a reference to the questions
        self.questions = questions
        
        // Display the first question
        displayQuestion()
        // Reload the tableView
        tableView.reloadData()
    }
    
}

//MARK: - ResultViewControllerProtocol Method
extension ViewController: ResultViewControllerProtocol {
    
    func dialogDismissed() {
        
        // Increment the currentQuestionIndex
        currentQuestionIndex += 1
        
        if currentQuestionIndex == questions.count {
            // The use has just answered the last question
            // Show the summary dialog
            if resultDialog != nil {
                // Customize the dialog text
                resultDialog!.titleText = "Summary"
                resultDialog!.feedbackText = "You got \(numCorrect) out of \(questions.count) questions."
                resultDialog!.buttonText = "Restart"
                present(resultDialog!, animated: true, completion: nil)
            }
        } else if  currentQuestionIndex > questions.count {
            // Restart
            numCorrect = 0
            currentQuestionIndex = 0
            displayQuestion()
        } else if currentQuestionIndex < questions.count {
            // There are still more questions to show
            // Display the next question
            displayQuestion()
        }
        
    }
}
