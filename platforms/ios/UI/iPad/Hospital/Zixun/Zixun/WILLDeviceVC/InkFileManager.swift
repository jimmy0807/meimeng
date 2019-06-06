//
//  InkFileManager.swift
//  meim
//
//  Created by 刘伟 on 2017/12/7.
//

import Foundation

class InkFileManager: NSObject {
    
    open static let shared: InkFileManager = InkFileManager()
    
    ///delete
    func removeDownLoadOffLineImage(imgUrl : String) {
        if UserDefaults.standard.array(forKey: "downOffLineImgDate") != nil {
            var downImageDateArr = UserDefaults.standard.array(forKey: "downOffLineImgDate") as! [String]
            for downImgDate in downImageDateArr {
                if UserDefaults.standard.array(forKey: downImgDate) != nil {
                    var imgUrlArr = UserDefaults.standard.array(forKey: downImgDate) as! [String]
                    
                    for (index,imgUrlStr) in imgUrlArr.enumerated(){
                        
                        if index >= imgUrlArr.count {
                            break
                        }
                        if imgUrl == imgUrlStr {
                            imgUrlArr.remove(at: index)
                            
                            ///保存一下 当删除最后一个 这时dateStr对应的数组为nil 所以删除该dateStr
                            if imgUrlArr.count == 0 {
                                print("删到最后一个了")
                                UserDefaults.standard.removeObject(forKey: downImgDate)
                                UserDefaults.standard.synchronize()
                                
                                ///移出日期Str
                                for (index,dateStr) in downImageDateArr.enumerated() {
                                    if downImgDate == dateStr {
                                        downImageDateArr.remove(at: index)
                                    UserDefaults.standard.set(downImageDateArr,forKey: "downOffLineImgDate")
                                        UserDefaults.standard.synchronize()
                                        
                                        
                                    }
                                }

                                
                            } else {
                                UserDefaults.standard.set(imgUrlArr, forKey: downImgDate)
                                UserDefaults.standard.synchronize()
                            }
                            
                        }
                    }
                }

            }
        }
    }
    
    func saveImgCreatDate() {
        ///保存下载日期的临时数组
        var newDownImageDateArr : [String] = NSMutableArray() as! [String]
        
        //print("专门保存日期数组\(UserDefaults.standard.array(forKey: "downOffLineImgDate"))")
        /// 如果是 [] 怎么办？
        /// 如果没有 就新创建一个 这个数组专门保存日期
        if UserDefaults.standard.array(forKey: "downOffLineImgDate") != nil {
            
            var downImageDateArr = UserDefaults.standard.array(forKey: "downOffLineImgDate") as! [String]
            if downImageDateArr.count == 0 {
                newDownImageDateArr.append(getNowDateString())
                
            }
            else {
                print("downImageDateArr = \(downImageDateArr)")
                ///删除重复的日期
                let se = Set(downImageDateArr)
                downImageDateArr = Array(se)
                downImageDateArr = downImageDateArr.filter({ (str) -> Bool in
                    return str != ""
                })
                print("删除重复的日期 = \(downImageDateArr)")

                if !downImageDateArr.contains(getNowDateString()) {
                   
                    newDownImageDateArr.append(getNowDateString())

                }
                for oldDatestr in downImageDateArr {
                    newDownImageDateArr.append(oldDatestr)
                }
            }
            ///存入UserDefault 一个date 一个date对应N个图片地址
            UserDefaults.standard.set(newDownImageDateArr, forKey: "downOffLineImgDate")
            UserDefaults.standard.synchronize()
            newDownImageDateArr.removeAll()
            
            
        }   //专门保存日期Arr == nil
        else {
            ///UserDefault中没有数组 新创建
            newDownImageDateArr.append(getNowDateString())
            ///存入UserDefault 一个date 一个date对应N个图片地址
            UserDefaults.standard.set(newDownImageDateArr, forKey: "downOffLineImgDate")
            UserDefaults.standard.synchronize()
            newDownImageDateArr.removeAll()
        }
    }

    ///add
    func saveDownLoadOffLineImage(bezierPathArr : [UIBezierPath]) {
        ///1.存下载日期
        /**
         key : "downOffLineImgDate"
         value : newDownImageDateArr
         */
        saveImgCreatDate()
        
        ///2.存日期对应的url
        /**
         key : 2017年12月11日
         value : imgUrlArr
         */
        let cellImg = creatCellImage(bezierPathsArr: bezierPathArr)
        
        ///将图片传给后台获取后台生成的url 并将图片缓存到本地
        let v = UploadPicToZimg()
        v.uploadPic(cellImg, finished: { (ret, urlString) in
            print("离线图片获取url ：ret = \(ret) - url = \(urlString!)")
            
            if ret {
                let list = urlString!.split(separator: "/")
                let tag = list.last
                //let tag = urlString!.subString(start: 25, length: 32)
                let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
                var filePath = path+"/BezierPath"
                if tag != nil
                {
                    filePath = filePath+"-\(tag!)"
                }
                //归档
                NSKeyedArchiver.archiveRootObject(bezierPathArr, toFile: filePath)
                ///保存图片creatDate
                UserDefaults.standard.set(self.getNowDateString(), forKey: "imgCreatDate-\(urlString!)")
                UserDefaults.standard.synchronize()
                
                SDWebImageManager.shared().saveImage(toCache: cellImg, for: URL.init(string: urlString!))
                
                self.saveImgUrlForOneDate(imgUrl: urlString!)
            }
        })
        
    }
    
    func saveImgUrlForOneDate(imgUrl : String) {
        
        let downImageDateArr2 = UserDefaults.standard.object(forKey: "downOffLineImgDate") as! [String]
        if downImageDateArr2.count>0
        {
            for dateStr in downImageDateArr2 {
                ///当前日期和存储的某个日期一样 代表都是同一天下载的
                var imgUrlTmpArr = [String]()
                if getNowDateString() == dateStr{
                    
                    if UserDefaults.standard.array(forKey: dateStr) as? [String] != nil {
                        
                        let imgUrlArr = UserDefaults.standard.array(forKey: dateStr) as! [String]
                        //print("imgUrlArr = \(imgUrlArr.count)")
                        
                        if imgUrlArr.count != 0 {
                            imgUrlTmpArr.append(imgUrl)
                            for imgUrlStr in imgUrlArr {
                                imgUrlTmpArr.append(imgUrlStr)
                            }
                            UserDefaults.standard.set(imgUrlTmpArr, forKey: dateStr)
                            UserDefaults.standard.synchronize()
                            
                        }
                        else {
                            imgUrlTmpArr.append(imgUrl)
                            
                            UserDefaults.standard.set(imgUrlTmpArr, forKey: dateStr)
                            UserDefaults.standard.synchronize()
                            
                        }
                        
                    }
 
                    else {
                        imgUrlTmpArr.append(imgUrl)
                        UserDefaults.standard.set(imgUrlTmpArr, forKey: dateStr)
                        UserDefaults.standard.synchronize()
                        
                    }
                    imgUrlTmpArr.removeAll()
                }
                else {
//                    ///反之代表不是同一天下载的
//                    var imgUrlTmpArr = [String]()
//                    let imgUrlArr = UserDefaults.standard.object(forKey: dateStr) as! [String]
//                    if imgUrlArr.count > 0 {
//                        imgUrlTmpArr.append(imgUrl)
//                        for imgUrlStr in imgUrlArr {
//                            imgUrlTmpArr.append(imgUrlStr)
//                        }
//                        UserDefaults.standard.set(imgUrlTmpArr, forKey: getNowDateString())
//                        UserDefaults.standard.synchronize()
//                        imgUrlTmpArr.removeAll()
//                    }
//                    else {
//                        imgUrlTmpArr.append(imgUrl)
//                        UserDefaults.standard.set(imgUrlTmpArr, forKey: getNowDateString())
//                        UserDefaults.standard.synchronize()
//                        imgUrlTmpArr.removeAll()
//                    }
//                    
//                    ///更新date-downOffLineImgDate 存日期数组
//                    var newDownImageDateArr2 : [String] = NSMutableArray() as! [String]
//                    let downImageDateArr2 = UserDefaults.standard.object(forKey: "downOffLineImgDate") as! [String]
//                    newDownImageDateArr2.append(getNowDateString())
//                    for downImgDate in downImageDateArr2 {
//                        newDownImageDateArr2.append(downImgDate)
//                    }
//                    ///存入UserDefault 一个date 一个date对应N个图片地址
//                    UserDefaults.standard.set(newDownImageDateArr2, forKey: "downOffLineImgDate")
//                    UserDefaults.standard.synchronize()
//                    newDownImageDateArr2.removeAll()
                }//end 不是同一天
            }
        }
        
        ///通知CloundVC刷新界面
        let offLineImgDownLoadFinished = Notification.Name.init(rawValue: "offLineImgDownLoadFinished")
        NotificationCenter.default.post(name: offLineImgDownLoadFinished, object: self, userInfo: nil)
        
    }
    
    func getNowDateString() -> String {
        //获取当前时间
        let now = NSDate()
        
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日"
        //print("当前日期时间：\(dformatter.string(from: now as Date))")
        return dformatter.string(from: now as Date)
        
    }
    
    func creatCellImage(bezierPathsArr : [UIBezierPath]) -> UIImage {
        
        ///绘制手写本内容: 因为这里下载的是大图尺寸 所以先画到一个UIImageView上 再缩放成小图添加到cell上
        let bigImageView:UIImageView = UIImageView.init(frame: CGRect.init(x: 270, y: 80, width: 490, height: 693))
        bigImageView.image = UIImage.init(named: "ink_moban2.jpg")
        ///把写字板里的笔迹放到UIView上
        if let sublayers = bigImageView.layer.sublayers {
            for l in sublayers {
                if l is CAShapeLayer {
                    l.removeFromSuperlayer()
                }
            }
        }
        //let currentBezierPathsArr = FileTransferManger.shared.filetotalArr[indexPath.row]
        for bezPath in bezierPathsArr {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = bezPath.cgPath
            shapeLayer.position = CGPoint.zero
            shapeLayer.fillColor = UIColor.black.cgColor
            shapeLayer.strokeColor = UIColor.clear.cgColor
            bigImageView.layer.addSublayer(shapeLayer)
        }
        
        ///UIView转UIImage
        UIGraphicsBeginImageContextWithOptions(bigImageView.bounds.size, false, 0.0 )
        bigImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        
        return img
    }
    
    ///从“咨询内容”移出到“离线区” 也意味着从后台删除
    func removeImgFromZixunContent(selectedImgArr : [String]) {
        //取对应一张图片的creatDate
        for imgUrl in selectedImgArr {
            
            let imgCreatDateStr = UserDefaults.standard.string(forKey: "imgCreatDate-\(imgUrl)")
            
            //print("从“咨询内容”移出到“离线区”imgCreatDateStr =\(imgCreatDateStr)")//nil

            ///TODO: imgCreatDateStr不能完全保证有值 ??也不是根本办法
            findRemovedImgDate(dateString: imgCreatDateStr ?? "")
            
            //imgUrl存入日期key对应的value
            saveRemovedImgUrlForOneDate(imgUrl: imgUrl, imgCreatDate: imgCreatDateStr ?? "")
            
        }
        
    }
    
    func findRemovedImgDate(dateString : String) {
        ///保存下载日期的临时数组
        var newDownImageDateArr : [String] = NSMutableArray() as! [String]
        
        print("专门保存日期数组\(UserDefaults.standard.array(forKey: "downOffLineImgDate"))")
        
        /// 如果是 [] 怎么办？
        ///如果没有 就新创建一个 这个数组专门保存日期
        if UserDefaults.standard.array(forKey: "downOffLineImgDate") != nil {
            
            var downImageDateArr = UserDefaults.standard.array(forKey: "downOffLineImgDate") as! [String]
            
            if downImageDateArr.count == 0 {
                newDownImageDateArr.append(dateString)
                
            }
            else {
                ///删除重复的日期
                let se = Set(downImageDateArr)
                downImageDateArr = Array(se)
                downImageDateArr = downImageDateArr.filter({ (str) -> Bool in
                    return str != ""
                })
                print("删除重复的日期 = \(downImageDateArr)")
                
                ///getNowDateString()表示当前日期
                for downImgDate in downImageDateArr {
                    if downImgDate != dateString {
                        newDownImageDateArr.append(dateString)
                    }
                }
                for oldDatestr in downImageDateArr {
                    newDownImageDateArr.append(oldDatestr)
                }
            }
            //删除重复的日期
            let se = Set(newDownImageDateArr)
            newDownImageDateArr = Array(se)
            newDownImageDateArr = newDownImageDateArr.filter({ (str) -> Bool in
                return str != ""
            })
            print("删除重复的日期2 = \(newDownImageDateArr)")
            ///存入UserDefault 一个date 一个date对应N个图片地址
            UserDefaults.standard.set(newDownImageDateArr, forKey: "downOffLineImgDate")
            UserDefaults.standard.synchronize()
            newDownImageDateArr.removeAll()
            
        }//专门保存日期Arr == nil
        else {
            ///UserDefault中没有数组 新创建
            newDownImageDateArr.append(dateString)
            ///存入UserDefault 一个date 一个date对应N个图片地址
            UserDefaults.standard.set(newDownImageDateArr, forKey: "downOffLineImgDate")
            UserDefaults.standard.synchronize()
            newDownImageDateArr.removeAll()
        }
    }
    
    func saveRemovedImgUrlForOneDate(imgUrl : String, imgCreatDate : String) {
        
        print(imgUrl,imgCreatDate)
        
        let downImageDateArr2 = UserDefaults.standard.object(forKey: "downOffLineImgDate") as! [String]
        if downImageDateArr2.count>0
        {
            for dateStr in downImageDateArr2 {
                ///当前日期和存储的某个日期一样 代表都是同一天下载的
                var imgUrlTmpArr = [String]()
                if imgCreatDate == dateStr {
                    
                                if UserDefaults.standard.array(forKey: dateStr) as? [String] != nil {
                                    
                                    let imgUrlArr = UserDefaults.standard.array(forKey: dateStr) as! [String]
                                    //print("imgUrlArr = \(imgUrlArr.count)")
                                    if imgUrlArr.count != 0 {
                                        imgUrlTmpArr.append(imgUrl)
                                        for imgUrlStr in imgUrlArr {
                                            imgUrlTmpArr.append(imgUrlStr)
                                        }
                                        UserDefaults.standard.set(imgUrlTmpArr, forKey: dateStr)
                                        UserDefaults.standard.synchronize()
                                        imgUrlTmpArr.removeAll()
                                    }
                                    else {
                                        imgUrlTmpArr.append(imgUrl)
                                        
                                        UserDefaults.standard.set(imgUrlTmpArr, forKey: dateStr)
                                        UserDefaults.standard.synchronize()
                                        imgUrlTmpArr.removeAll()
                                    }
                                }
                                    
                                else {
                                    imgUrlTmpArr.append(imgUrl)
                                    UserDefaults.standard.set(imgUrlTmpArr, forKey: dateStr)
                                    UserDefaults.standard.synchronize()
                                    imgUrlTmpArr.removeAll()
                                }
                
                }//end if imgCreatDate == dateStr
                
            }//end for dateStr in downImageDateArr2
            
        }//end if downImageDateArr2.count>0
        
     }//end func
    
}//end class
