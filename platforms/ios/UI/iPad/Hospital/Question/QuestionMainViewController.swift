//
//  QuestionMainViewController.swift
//  meim
//
//  Created by jimmy on 2017/6/14.
//
//

import UIKit

class QuestionMainViewController: UIViewController
{
    @IBOutlet weak var noLabel : UILabel!  //题目序号
    @IBOutlet weak var questionLabel : UILabel!  //题目

    var answerList : [CDQuestion] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.reloadData()
        
        self.registerNofitification(forMainThread: kFetchQuestionResponse)
    }
    
    @IBAction func didYesButtonPressed(_ sender : UIButton)
    {
        if let currentQuestion = self.answerList.last
        {
            if let nextID = currentQuestion.yes_question_id
            {
                if nextID == 0
                {
                    //go finshis
                }
                else
                {
                    if let nextQuestion = BSCoreDataManager.current().fetchQuestion(withQuestionID: nextID)
                    {
                        self.answerList.append(nextQuestion)
                        self.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func didNoButtonPressed(_ sender : UIButton)
    {
        
    }
    
    @IBAction func didCloseButtonPressed(_ sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didReceiveNotificationOnMainThread(_ notification : NSNotification)
    {
        if ( notification.name.rawValue == kFetchQuestionResponse )
        {
            self.reloadData()
        }
    }
    
    func reloadData()
    {
        if self.answerList.count == 0
        {
            if let question = BSCoreDataManager.current().fetchFirstQuestion()
            {
                self.noLabel.text = question.question_no
                self.questionLabel.text = question.question
                self.answerList.append(question)
            }
            else
            {
                self.noLabel.text = ""
                self.questionLabel.text = ""
            }
        }
        else
        {
            if let question = self.answerList.last
            {
                self.noLabel.text = question.question_no
                self.questionLabel.text = question.question
            }
        }
    }
}
