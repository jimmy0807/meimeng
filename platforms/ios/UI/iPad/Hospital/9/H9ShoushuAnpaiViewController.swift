//
//  H9ShoushuAnpaiViewController.swift
//  meim
//
//  Created by jimmy on 2017/8/1.
//
//

import UIKit

class H9ShoushuAnpaiViewController: ICCommonViewController
{
    @IBOutlet weak var monthLabel : UILabel!
    @IBOutlet weak var leftMonthView : H9AnPaiLeftView!
    @IBOutlet weak var rightMonthView : H9AnPaiRightEventView!
    var searchVC : H9ShoushuAnpaiSearchViewController?
    
    lazy var createVC : HPatientCreateShoushuLineContainerViewController =
    {
        return self.storyboard?.instantiateViewController(withIdentifier: "create_shoushu_line") as! HPatientCreateShoushuLineContainerViewController
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.leftMonthView.didSelectItem = {[weak self] (year_month_day) in
            self?.rightMonthView.year_month_day = year_month_day
            print("Year_Month_Day:\(String(describing: year_month_day))")
        }
        
        self.rightMonthView.didEditEventButtonPressed = {[weak self] event in
            self?.goSoushuView(event)
        }
        
        self.rightMonthView.didEventItemButtonPressed = {[weak self] event in
            self?.goPatientView(event)
        }
        
        self.searchVC?.didSelectItem = {[weak self] (year_month_day) in
            print((year_month_day?.date(with: "yyyy-MM-dd"))!)
            if (year_month_day != "") {
                self?.setDateToDay((year_month_day?.date(with: "yyyy-MM-dd"))!)
                self?.leftMonthView.didSelectItem!(year_month_day)
            }
        }
        
        setDate(Date())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        self.searchVC = segue.destination as? H9ShoushuAnpaiSearchViewController
    }
    
    func goPatientView(_ event : CDH9SSAPEvent)
    {
        if let memberID = event.member_id
        {
            CBLoadingView.share().show()
            
            let request = FetchHOnePatientRequest()
            request.memberID = memberID
            request.execute()
            request.finished = { [weak self](params) in
                CBLoadingView.share().hide()
                if let result = params?["rc"] as? Int, result == 0
                {
                    self?.goMember(memberID as! Int)
                }
                else
                {
                    CBMessageView(title: params?["rm"] as! String).show()
                }
            }
        }
    }
    
    func goMember(_ memberID : Int)
    {
        let tableViewStoryboard = UIStoryboard(name: "HPatientBoard", bundle: nil)
        if let member = BSCoreDataManager.current().findEntity("CDMember", withValue: memberID, forKey: "memberID") as? CDMember
        {
            let vc = tableViewStoryboard.instantiateViewController(withIdentifier: "binglika") as! HPatientBinglikaViewController
            vc.member = member
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func goSoushuView(_ event : CDH9SSAPEvent)
    {
        CBLoadingView.share().show()
        let request = FetchHShoushuLineRequest(shoushuID: [event.operate_line_id ?? 0])!
        request.execute()
        request.finished = { [weak self](params) in
            CBLoadingView.share().hide()
            if let _ = params?["rm"] as? String
            {
                CBMessageView(title: params?["rm"] as! String).show()
            }
            else
            {
                self?.createVC.shoushuLine = BSCoreDataManager.current().findEntity("CDHShoushuLine", withValue: event.operate_line_id!, forKey: "line_id") as? CDHShoushuLine
                if let view = self?.createVC.view
                {
                    self?.view.addSubview(view)
                }
            }
        }
    }
    
    @IBAction func didLeftMonthButtonPressed(_ sender : UIButton)
    {
        if let date = self.monthLabel.text?.date(with: "yyyy-MM")
        {
            if let last = date.lastMonth()
            {
                setDate(last)
            }
        }
    }
    
    @IBAction func didRightMonthButtonPressed(_ sender : UIButton)
    {
        if let date = self.monthLabel.text?.date(with: "yyyy-MM")
        {
            if let last = date.nextMonth()
            {
                setDate(last)
            }
        }
    }
    
    @IBAction func didMenuButtonPressed(_ sender : UIButton)
    {
        self.mm_drawerController.toggle(.left, animated: true, completion: nil)
    }
    
    @IBAction func didThisMonthButtonPressed(_ sender : UIButton)
    {
        setDate(Date())
    }
    
    func setDate(_ date : Date)
    {
        self.monthLabel.text = date.dateTo("yyyy-MM")
        reloadData(with: date)
    }
    
    func setDateToDay(_ date : Date)
    {
        self.monthLabel.text = date.dateTo("yyyy-MM")
        reloadDataToDay(with: date)
    }
    
    func reloadData(with date : Date)
    {
        self.leftMonthView.reloadData(with: date)
    }
    
    func reloadDataToDay(with date : Date)
    {
        self.leftMonthView.reloadDataToDay(with: date)
    }
    
    @IBAction func didSearchButtonPressed(_ sender : UIButton)
    {
        if let superView = self.searchVC?.view.superview
        {
            superView.isHidden = false
        }
    }
}
