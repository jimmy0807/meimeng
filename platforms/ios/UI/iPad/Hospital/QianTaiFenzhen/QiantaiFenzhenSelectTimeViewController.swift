//
//  QiantaiFenzhenSelectTimeViewController.swift
//  meim
//
//  Created by jimmy on 2017/6/2.
//
//

import UIKit

class QiantaiFenzhenSelectTimeViewController: ICTableViewController {

    struct SelectInfo
    {
        var state : String?
        var date : String?
        var shejishi : Int?
        var shejizongjian : Int?
    }
    
    var selectVC : SeletctListViewController?
    var selectInfo : SelectInfo = SelectInfo()
    
    var book : CDZixunBook?
    {
        didSet
        {
            if let book = self.book
            {
                if let designer_name = book.designer_name
                {
                    self.shejishiTextField.text = designer_name
                    self.selectInfo.shejishi = book.designer_id as? Int
                }
                
                if let director_name = book.director_name
                {
                    self.shejizongjianTextField.text = director_name
                    self.selectInfo.shejizongjian = book.director_id as? Int
                }
                
                self.stateTextField.text = "初诊"
                self.selectInfo.state = "new"
            }
        }
    }
    
    @IBOutlet weak var stateTextField : UITextField!
    @IBOutlet weak var dateTextField : UITextField!
    @IBOutlet weak var shejishiTextField : UITextField!
    @IBOutlet weak var shejizongjianTextField : UITextField!
    @IBOutlet weak var dateCancelButton : UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    func clear()
    {
        selectInfo = SelectInfo()
        self.stateTextField.text = ""
        self.dateTextField.text = ""
        self.shejishiTextField.text = ""
        self.shejizongjianTextField.text = ""
    }
    
    @IBAction func didStateButtonPressed(_ sender: UIButton)
    {
        self.selectVC = SeletctListViewController(nibName: "SeletctListViewController", bundle: nil)
        let stateStringArray = ["初诊","复诊","复查","再消费"]
        let stateKeyArray = ["new","referral","review","consume"]
        self.selectVC?.countOfTheList = {
            return stateStringArray.count
        }
        
        self.selectVC?.nameAtIndex = { index in
            return stateStringArray[index]
        }
        
        self.selectVC?.selectAtIndex = {[weak self] index in
            let state = stateStringArray[index]
            let statekey = stateKeyArray[index]
            
            self?.stateTextField.text = state
            self?.selectInfo.state = statekey
        }
        
        UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
        self.selectVC?.showWithAnimation();
    }
    
    @IBAction func didDateButtonPressed(_ sender: UIButton)
    {
        let v = PadDatePickerView()
        v.datePickerMode = .dateAndTime;
        
        v.selectFinished = {[weak self] (date) in
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = dateFormat.string(from: date!)
            self?.dateTextField.text = dateString + ":00"
            self?.selectInfo.date = self?.dateTextField.text
            self?.dateCancelButton.isHidden = false
        }
        
        UIApplication.shared.keyWindow?.addSubview(v)
    }
    
    @IBAction func didShejishiButtonPressed(_ sender: UIButton)
    {
        self.selectVC = SeletctListViewController(nibName: "SeletctListViewController", bundle: nil)
        let shejishiArray = BSCoreDataManager.current().fetchShejishiStaffs(withShopID: PersonalProfile.current().bshopId);
        
        self.selectVC?.countOfTheList = {
            return shejishiArray.count
        }
        
        self.selectVC?.nameAtIndex = { index in
            let staff = shejishiArray[index]
            
            return staff.name
        }
        
        self.selectVC?.selectAtIndex = {[weak self] index in
            let staff = shejishiArray[index]
            self?.shejishiTextField.text = staff.name
            self?.selectInfo.shejishi = staff.staffID as? Int
        }
        
        UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
        self.selectVC?.showWithAnimation();
    }
    
    @IBAction func didShejizongjianButtonPressed(_ sender: UIButton)
    {
        self.selectVC = SeletctListViewController(nibName: "SeletctListViewController", bundle: nil)
        let shejishiArray = BSCoreDataManager.current().fetchShejizongjianStaffs(withShopID: PersonalProfile.current().bshopId);
        
        self.selectVC?.countOfTheList = {
            return shejishiArray.count
        }
        
        self.selectVC?.nameAtIndex = { index in
            let staff = shejishiArray[index]
            
            return staff.name
        }
        
        self.selectVC?.selectAtIndex = {[weak self] index in
            let staff = shejishiArray[index]
            self?.shejizongjianTextField.text = staff.name
            self?.selectInfo.shejizongjian = staff.staffID as? Int
        }
        
        UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
        self.selectVC?.showWithAnimation();
    }
    
    @IBAction func didDateCancelButtonPressed(_ sender: UIButton)
    {
        self.dateTextField.text = ""
        self.selectInfo.date = ""
        sender.isHidden = true
    }
}
