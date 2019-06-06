//
//  CheckDetailViewController.swift
//  meim
//
//  Created by 波恩公司 on 2018/5/9.
//

import UIKit

class CheckDetailViewController: ICCommonViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var xingzuoLabel: UILabel!
    @IBOutlet weak var bloodTypeLabel: UILabel!
    @IBOutlet weak var fundLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var designerLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var checkNameLabel: UILabel!
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var finishView: UIView!

    //@IBOutlet weak var tableView: UITableView!
    var checkDetail = NSDictionary()
    var operateId = NSNumber()
    var checkLineId = NSNumber()
    var activityId = NSNumber()
    var imageUrlArray:[String]! = []
    var uploadStatusArray:[Bool]! = []
    var photoCollectionView : UICollectionView!
    var checkPhotoView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = FetchCheckDetailRequest()
        request.params["operate_id"] = operateId
        request.params["check_line_id"] = checkLineId
        request.execute()
        self.registerNofitification(forMainThread: "CheckDetailFetchResponse")
        self.registerNofitification(forMainThread: "CheckUpdateResponse")
        
    }
    
    func didReceiveNotificationOnMainThread(_ notification : NSNotification)
    {
        if ( notification.name.rawValue == "CheckDetailFetchResponse" )
        {
            print(notification.userInfo!["data"])
            if let dict = notification.userInfo!["data"] as? NSDictionary
            {
                checkDetail = dict
                //statusLabel.text = "\(checkDetail.object(forKey: "customer_state_name") ?? "")"
//                if(statusLabel.text?.lengthOfBytes(using: .utf8) == 0)
//                {
//                    statusLabel.isHidden = true
//                }
                avatarView.sd_setImage(with: URL(string: "\(checkDetail.object(forKey: "member_image_url") ?? "")"), placeholderImage: UIImage(named: "pad_avatar_default"))
                nameLabel.text = "\(checkDetail.object(forKey: "detail_customer_name") ?? "")"
                genderLabel.text = "性别:\(checkDetail.object(forKey: "sex") ?? "")"
                ageLabel.text = "年龄:\(checkDetail.object(forKey: "age") ?? "")"
                //xingzuoLabel.text = "\(checkDetail.object(forKey: "customer_name") ?? "")"
                bloodTypeLabel.text = "血型:\(checkDetail.object(forKey: "blood_type") ?? "")"
                //fundLabel.text = "\(checkDetail.object(forKey: "customer_name") ?? "")"
                //pointLabel.text = "\(checkDetail.object(forKey: "customer_name") ?? "")"
                designerLabel.text = "\(checkDetail.object(forKey: "designers_name") ?? "")"
                directorLabel.text = "\(checkDetail.object(forKey: "director_employee_name") ?? "")"
                checkNameLabel.text = "\(checkDetail.object(forKey: "product_name") ?? "")"
                if "\(checkDetail.object(forKey: "check_state") ?? "")" == "draft" || "\(checkDetail.object(forKey: "check_state") ?? "")" == "waiting"
                {
                    startView.isHidden = false
                    finishView.isHidden = true
                }
                else
                {
                    startView.isHidden = true
                    finishView.isHidden = false
                }
                activityId = checkDetail.object(forKey: "operate_activity_id") as! NSNumber
                let imageArray = checkDetail.object(forKey: "image_ids") as! NSArray
                for image in imageArray
                {
                    imageUrlArray.append((image as! NSArray)[0] as! String)
                    uploadStatusArray.append(true)
                }
                setUpCollectionView()
            }
        }
        else if ( notification.name.rawValue == "CheckUpdateResponse" )
        {
            let request = FetchCheckDetailRequest()
            request.params["operate_id"] = operateId
            request.params["check_line_id"] = checkLineId
            request.execute()
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        uploadPhoto()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startAction(_ sender: Any) {
        let request = CheckUpdateRequest()
        request.params["operate_id"] = operateId
        request.params["check_line_id"] = checkLineId
        request.params["operate_activity_id"] = activityId
        request.params["state"] = "doing"
        request.execute()
    }
    
    @IBAction func finishAction(_ sender: Any) {
        let request = CheckUpdateRequest()
        request.params["operate_id"] = operateId
        request.params["check_line_id"] = checkLineId
        request.params["operate_activity_id"] = activityId
        request.params["image_urls"] = imageUrlArray.joined(separator: ",")
        request.params["state"] = "done"
        request.execute()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "请选择", preferredStyle: .actionSheet)
        let actionTakePhoto = UIAlertAction(title: "拍照", style: .default) { (action) in
            BNCameraView.showinView(UIApplication.shared.keyWindow, takPhoto: {(image : UIImage?) -> () in
                if let newImage = image
                {
                    self.dealPhotoImage(image: newImage)
                }
            })
        }
        alert.addAction(actionTakePhoto)
        let actionAddLibrary = UIAlertAction(title: "相册", style: .default) { (action) in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.delegate = self
            UIApplication.shared.keyWindow?.rootViewController?.present(imagePicker, animated: true, completion: nil)
            
        }
        alert.addAction(actionAddLibrary)
        alert.popoverPresentationController?.sourceView = sender as! UIButton
        alert.popoverPresentationController?.sourceRect = (sender as! UIButton).bounds
        
        alert.popoverPresentationController?.permittedArrowDirections = .down
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        if (picker.allowsEditing)
        {
            image = info["UIImagePickerControllerEditedImage"] as? UIImage
        }
        image = image?.orientation()
        dealPhotoImage(image: image ?? UIImage())
        picker.dismiss(animated: true, completion: nil)
        //        var yimeiImage : CDYimeiImage = BSCoreDataManager.current().insertEntity("CDYimeiImage") as! CDYimeiImage
        //        yimeiImage.url = "\(url)"
        //        yimeiImage.small_url = "\(small_url)"
        //        yimeiImage.zixun = self.zixun
        //        yimeiImage.type = "local"
        //        yimeiImage.status = "prepare"
        //        yimeiImage.take_time = ""
        
    }
    
    func dealPhotoImage(image:UIImage){
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        var imageDestWidth = imageWidth
        var imageDestHeight = imageHeight
        if (imageWidth > CGFloat(1024))
        {
            imageDestWidth = 1024;
            imageDestHeight = (imageDestWidth) * imageHeight / imageWidth;
        }
        if (imageDestHeight > CGFloat(768))
        {
            imageDestWidth = imageDestWidth * 768 / imageDestHeight;
            imageDestHeight = 768;
        }
        var compressedImage = image.scaleToSize(CGSize(width: imageDestWidth, height: imageDestHeight))
        let tag:NSInteger = NSInteger(NSDate().timeIntervalSince1970)
        let url = URL(string: "\(tag)")
        SDWebImageManager.shared().saveImage(toCache: compressedImage, for: url)
        //        imageDestWidth = 200
        //        imageDestHeight = (imageDestWidth) * imageHeight / imageWidth;
        //        compressedImage = image.scaleToSize(CGSize(width: imageDestWidth, height: imageDestHeight))
        //        let small_url = URL(string: "\(tag)")
        //        SDWebImageManager.shared().saveImage(toCache: compressedImage, for: small_url)
        
        imageUrlArray?.append("\(url!)")
        uploadStatusArray.append(false)
        self.photoCollectionView.reloadData()
    }
    
    func uploadPhoto()
    {
        let request = CheckUpdateRequest()
        request.params["operate_id"] = operateId
        request.params["check_line_id"] = checkLineId
        request.params["operate_activity_id"] = activityId
        request.params["image_urls"] = imageUrlArray.joined(separator: ",")
        request.execute()
    }
    
    func setUpCollectionView()
    {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 185, height: 137);
        flowLayout.minimumLineSpacing = 17;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsets(top: 30, left: 70, bottom: 40, right: 70)
        //        flowLayout.headerReferenceSize = CGSize(width: 172, height: 30);
        
        //        photoCollectionView.collectionViewLayout = flowLayout;
        //        self.automaticallyAdjustsScrollViewInsets = NO;
        photoCollectionView = UICollectionView(frame:  CGRect(x: 303, y: 75, width: 720, height: 693), collectionViewLayout: flowLayout)
        photoCollectionView.backgroundColor = UIColor.clear
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.register(UICollectionViewCell.self,                                 forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        self.view.addSubview(photoCollectionView)
        photoCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrlArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as UICollectionViewCell
        for view in cell.subviews
        {
            view.removeFromSuperview()
        }
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 185, height: 137))
        
        imageView.sd_setImage(with: URL(string: imageUrlArray?[indexPath.row] ?? ""))
        if (!uploadStatusArray[indexPath.row])
        {
            let v = UploadPicToZimg()
            v.uploadPic(imageView.image, finished: { (ret, urlString) in
                let cell2 = collectionView.cellForItem(at: indexPath)
                if cell !=  cell2 {
                    print("cell != cell2")
                }
                if (ret) {
                    SDWebImageManager.shared().saveImage(toCache: imageView.image, for: URL(string: urlString!))
                    let key = self.imageUrlArray![indexPath.row]
                    SDWebImageManager.shared().imageCache.removeImage(forKey: key, fromDisk: true)
                    self.imageUrlArray![indexPath.row] = urlString!
                }
            })
        }
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderColor = RGB(r: 186, g: 201, b: 201).cgColor
        imageView.layer.borderWidth = 1
        cell.addSubview(imageView)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 185, height: 137)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.row != imageUrlArray.count)
        {
            checkPhotoView = UIView(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
            checkPhotoView.backgroundColor = UIColor.black
            let photoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
            photoImageView.contentMode = .scaleAspectFit
            photoImageView.sd_setImage(with: URL(string: imageUrlArray[indexPath.row]))
            checkPhotoView.addSubview(photoImageView)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didCheckPhotoTapped))
            checkPhotoView.addGestureRecognizer(tapGesture)
            self.view.addSubview(checkPhotoView)
        }
    }
    
    func didCheckPhotoTapped()
    {
        checkPhotoView.removeFromSuperview()
    }
}

