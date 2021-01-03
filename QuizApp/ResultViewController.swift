//
//  ResultViewController.swift
//  QuizApp
//
//  Created by Irish on 12/28/20.
//  Copyright © 2020 Irish. All rights reserved.
//

import UIKit

protocol ResultViewControllerProtocol {
    func dialogDismissed()
}

class ResultViewController: UIViewController {
    
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
    var titleText = ""
    var feedbackText = ""
    var buttonText = ""
    
    var delegate: ResultViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dialogView.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Now that the elements have loaded, set the the text
        titleLabel.text = titleText
        feedbackLabel.text = feedbackText
        dismissButton.setTitle(buttonText, for: .normal)
        
    }

    @IBAction func dismissTapped(_ sender: UIButton) {
        // Dismiss the popup
        dismiss(animated: true, completion: nil)
        
        // Notify delegate that popup was dismissed
        delegate?.dialogDismissed()
    }
}
