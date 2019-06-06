//
//  QuestionMainView.swift
//  meim
//
//  Created by jimmy on 2017/6/14.
//
//

import UIKit

class QuestionMainView: UIView, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var noLabel : UILabel!  //题目序号
    @IBOutlet weak var questionLabel : UILabel!  //题目
    
    @IBOutlet weak var questionView : UIView!
    @IBOutlet weak var finishView : UIView!
    @IBOutlet weak var preButton : UIButton!
    
    @IBOutlet weak var tableView : UITableView!
    
    var answerList : [CDQuestion] = []
    var questionResult : CDQuestionResult?
    var selectedIndexSet : Set<Int> = Set()
    
    @IBOutlet weak var resultNameLabel : UILabel!  //题目序号
    @IBOutlet weak var resultRecommendLabel : UILabel!  //题目
    
    var zixun : CDZixun?
    var questionViewFinished : (() -> Void)?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.registerNofitification(forMainThread: kFetchQuestionResponse)
    }
    
    @IBAction func didYesButtonPressed(_ sender : UIButton)
    {
        if let currentQuestion = self.answerList.last
        {
            self.preButton.isHidden = false
            currentQuestion.result = true
            if let nextID = currentQuestion.yes_question_id
            {
                if nextID == 0
                {
                    self.questionResult = BSCoreDataManager.current().fetchQuestionResult(with: currentQuestion.yes_result_id!)
                    self.tableView.reloadData()
                    self.resultNameLabel.text = self.questionResult?.name
                    self.resultRecommendLabel.text = self.questionResult?.recommend
                    
                    self.questionView.isHidden = true
                    self.finishView.isHidden = false
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
        if let currentQuestion = self.answerList.last
        {
            self.preButton.isHidden = false
            currentQuestion.result = false
            if let nextID = currentQuestion.no_question_id
            {
                if nextID == 0
                {
                    self.questionResult = BSCoreDataManager.current().fetchQuestionResult(with: currentQuestion.no_result_id!)
                    self.tableView.reloadData()
                    self.resultNameLabel.text = self.questionResult?.name
                    self.resultRecommendLabel.text = self.questionResult?.recommend
                    
                    self.questionView.isHidden = true
                    self.finishView.isHidden = false
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
    
    @IBAction func didPreButtonPressed(_ sender : UIButton)
    {
        if self.answerList.count > 0
        {
            self.answerList.removeLast()
        }
        
        if self.answerList.count == 0
        {
            self.preButton.isHidden = true
        }
        else
        {
            self.preButton.isHidden = false
        }
        
        self.reloadData()
    }
    
    @IBAction func didCloseButtonPressed(_ sender : UIButton)
    {
        clear()
    }
    
    func clear()
    {
        self.isHidden = true
        self.noLabel.text = ""
        self.questionLabel.text = ""
        self.answerList = []
    }
    
    @IBAction func didOKButtonPressed(_ sender : UIButton)
    {
        if let zixun = self.zixun, let result = self.questionResult
        {
            var resultString : String = ""
            for ( index, question ) in self.answerList.enumerated()
            {
                resultString = resultString + "\(question.question_id!)@\((question.result as! Bool) ? "yes" : "no")"
                if index != self.answerList.count - 1
                {
                    resultString += "_"
                }
            }
            
            let request = ZixunQuestionUploadRequest()
            request.params["company_id"] = result.company_id
            request.params["member_id"] = zixun.member_id
            request.params["advisory_id"] = zixun.zixun_id
            request.params["result_id"] = result.result_id
            request.params["lines"] = resultString
            request.execute()
            
            request.finished = {[weak self] params in
                if let result = params?["rc"] as? Int, result == 0
                {
                    self?.clear()
                }
                else
                {
                    CBMessageView(title: params?["rm"] as! String).show()
                }
            }
            
            if self.selectedIndexSet.count > 0
            {
                var idsArray = [String]()
                var nameArray = [String]()
                for index in self.selectedIndexSet
                {
                    let item = self.questionResult?.items?[index] as! CDQuestionResultItem
                    idsArray.append("\(item.itemID!)")
                    nameArray.append(item.name!)
                }
                
                self.zixun?.product_ids = idsArray.joined(separator: ",")
                self.zixun?.product_names = nameArray.joined(separator: ",")
                self.questionViewFinished?()
                BSCoreDataManager.current().save()
            }
        }
        else
        {
            clear()
        }
    }
    
    func didReceiveNotificationOnMainThread(_ notification : NSNotification)
    {
        if ( notification.name.rawValue == kFetchQuestionResponse )
        {
            self.answerList = []
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

    func show(_ questionID : Int)
    {
        self.isHidden = false
        self.finishView.isHidden = true
        self.questionView.isHidden = false
        
        let request = FetchZixunQuestionRequest()
        request.filterID = questionID
        request.execute()
        
        self.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.questionResult?.items?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionResultTableViewCell") as! QuestionResultTableViewCell
        cell.item = self.questionResult?.items?[indexPath.row] as? CDQuestionResultItem
        cell.iconImageView.isHighlighted = selectedIndexSet.contains(indexPath.row)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 46
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if selectedIndexSet.contains(indexPath.row)
        {
            selectedIndexSet.remove(indexPath.row)
        }
        else
        {
            selectedIndexSet.insert(indexPath.row)
        }
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
