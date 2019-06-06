//
//  ZixunLeftLongView.swift
//  meim
//
//  Created by jimmy on 2017/6/10.
//
//

import UIKit

class ZixunLeftLongView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var zixunContentRightImageView : UIImageView!
    @IBOutlet weak var zixunHistoryRightImageView : UIImageView!
    @IBOutlet weak var zixunContentView : UIView!
    @IBOutlet weak var zixunHistoryView : UIView!
    @IBOutlet weak var designerLabel : UILabel!
    @IBOutlet weak var directorLabel : UILabel!
    @IBOutlet weak var detailInfoView : ZixunDetailLeftInfoView!
    
    var didContentButtonPressed : ((Void)->Void)?
    var didHistoryButtonPressed : ((Void)->Void)?
    var didAvatarButtonPressed : ((Void)->Void)?

    var selectVC : SeletctListViewController?
    var checkPhotoView : UIView!
    var photoCollectionView : UICollectionView!
    var imageUrlArray:[String]! = []
    var uploadStatusArray:[Bool]! = []
    var zixunId : NSNumber?
    var zixun : CDZixun?
    {
        didSet
        {
            self.detailInfoView.zixun = zixun
            self.designerLabel.text = "设计师:" + (self.zixun?.designer_name ?? "")
            self.directorLabel.text = "设计总监:" + (self.zixun?.director_name ?? "")
            self.zixunId = self.zixun?.zixun_id
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.didContentViewPressed(nil)
        self.setUpCollectionView()
    }
    
    @IBAction func didAvatarViewPressed(_ sender : UIButton?)
    {
        self.didAvatarButtonPressed?()
    }
    
    @IBAction func didContentViewPressed(_ sender : UIButton?)
    {
        self.didContentButtonPressed?()
        self.zixunContentView.backgroundColor = RGB(r: 239, g: 242, b: 242)
        self.zixunHistoryView.backgroundColor = UIColor.white
        self.zixunContentRightImageView.isHidden = false
        self.zixunHistoryRightImageView.isHidden = true
    }
    
    @IBAction func didHistoryViewPressed(_ sender : UIButton)
    {
        self.didHistoryButtonPressed?()
        self.zixunHistoryView.backgroundColor = RGB(r: 239, g: 242, b: 242)
        self.zixunContentView.backgroundColor = UIColor.white
        self.zixunHistoryRightImageView.isHidden = false
        self.zixunContentRightImageView.isHidden = true
    }
    
    @IBAction func didShejishiButtonPressed(_ sender : UIButton)
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
            self?.zixun?.designer_name = staff.name
            self?.zixun?.designer_id = staff.staffID
            self?.designerLabel.text = "设计师:" + (self?.zixun?.designer_name ?? "")
        }
        
        UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
        self.selectVC?.showWithAnimation();
    }
    
    @IBAction func didShejizongjianButtonPressed(_ sender : UIButton)
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
            self?.zixun?.director_name = staff.name
            self?.zixun?.director_id = staff.staffID
            self?.directorLabel.text = "设计总监:" + (self?.zixun?.director_name ?? "")
        }
        
        UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
        self.selectVC?.showWithAnimation();
    }
    
    /// 一张图片的格式 @后面是判断是否是写字本图片
    /// http://devimg.we-erp.com/a3ab90888b52ecff47f64bc5a9b4e1c3@t
    func dealImageUrl(imageUrlArray:[String]) -> [String] {
        var tmpImageUrlArray = [String]()
        ///处理图片url
        for pictureUrl in imageUrlArray {
            let substringArry = pictureUrl.components(separatedBy: "@")
            
            if substringArry.last == "f" {
                tmpImageUrlArray.append(substringArry[1])
            }
        }
        
        return tmpImageUrlArray
    }
    
    @IBAction func didCheckPhotoButtonPressed(_ sender : UIButton)
    {
        checkPhotoView = UIView(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
        checkPhotoView.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.3)
        if imageUrlArray.count == 0 {
            if zixun?.image_urls == "" {
                imageUrlArray = []
            }
            else
            {
                imageUrlArray = zixun?.image_urls?.components(separatedBy: ",") ?? []
                imageUrlArray = dealImageUrl(imageUrlArray: imageUrlArray)
                //print("处理后的图片url=\(imageUrlArray)")
            }
        }
        uploadStatusArray.removeAll()
        if (imageUrlArray?.count ?? 0) > 0 {
            for _ in imageUrlArray! {
                uploadStatusArray.append(true)
            }
        }
        
        photoCollectionView.reloadData()
        checkPhotoView.addSubview(photoCollectionView)
        
        let naviBackImageView = UIImageView(frame: CGRect(x: 152, y: 0, width: 720, height: 75))
        naviBackImageView.image = #imageLiteral(resourceName: "pad_navi_background.png")
        checkPhotoView.addSubview(naviBackImageView)
        
        let closeButton = UIButton(frame: CGRect(x: 153, y: 0, width: 75, height: 75))
        closeButton.setImage(#imageLiteral(resourceName: "pad_navi_close_h.png"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeCheckPhoto), for: .touchUpInside)
        checkPhotoView.addSubview(closeButton)
        
        let titleLabel = UILabel(frame: CGRect(x: 362, y: 25, width: 301, height: 25))
        titleLabel.text = "查看照片"
        titleLabel.textAlignment = .center
        checkPhotoView.addSubview(titleLabel)
        
        let saveButton = UIButton(frame: CGRect(x: 801, y: 0, width: 72, height: 72))
        saveButton.backgroundColor = RGB(r: 82, g: 203, b: 201)
        saveButton.setTitle("保存", for: .normal)
        saveButton.addTarget(self, action: #selector(savePhoto), for: .touchUpInside)
        checkPhotoView.addSubview(saveButton)
                
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(checkPhotoView)
    }
    
    func closeCheckPhoto(){
        checkPhotoView.removeFromSuperview()
    }
    
    func savePhoto(){
        let request = HZixunUpdate()
        request.params["advisory_id"] = self.zixun?.zixun_id ?? self.zixunId
        let imageStr = imageUrlArray.joined(separator: ",")
        request.params["image_urls"] = imageStr
        request.execute()
        checkPhotoView.removeFromSuperview()

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
        photoCollectionView = UICollectionView(frame:  CGRect(x: 153, y: 72, width: 720, height: 696), collectionViewLayout: flowLayout)
        photoCollectionView.backgroundColor = UIColor.white
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.register(UICollectionViewCell.self,                                 forCellWithReuseIdentifier: "PhotoCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (imageUrlArray?.count ?? 0) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as UICollectionViewCell
        for view in cell.subviews
        {
            view.removeFromSuperview()
        }
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 185, height: 137))
        if (indexPath.row == (imageUrlArray?.count ?? 0))
        {
            imageView.image = #imageLiteral(resourceName: "yimei_camera.png")
        }
        else
        {
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
            return
        }
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
        alert.popoverPresentationController?.sourceView = collectionView.cellForItem(at: indexPath)
        alert.popoverPresentationController?.sourceRect = (collectionView.cellForItem(at: indexPath)?.bounds)!
        let rect = collectionView.convert((collectionView.cellForItem(at: indexPath)?.frame)!, to: self)
        let y = rect.origin.y
        if (y > 400){
            alert.popoverPresentationController?.permittedArrowDirections = .down
        }
        else{
            alert.popoverPresentationController?.permittedArrowDirections = .up
        }
        print(alert.view)
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
}
