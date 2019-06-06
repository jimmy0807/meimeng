import { Component } from '@angular/core';
import { NavController, NavParams, ToastController,ViewController } from 'ionic-angular';

import { ShopData } from '../../providers/shop-data';

/*
  Generated class for the ShopManagerDetail page.

  See http://ionicframework.com/docs/v2/components/#navigation for more info on
  Ionic pages and navigation.
*/
@Component({
  selector: 'page-shop-manager-detail',
  templateUrl: 'shop-manager-detail.html'
})
export class ShopManagerDetailPage {

  shop : any;
  mEditState : string;
  finishCallback : any

  constructor(public navCtrl: NavController,
              public navParams: NavParams,
              public shopData: ShopData,
              public viewCtrl: ViewController,
              public toastCtrl: ToastController) {
    this.shop = navParams.data.shop;
    this.finishCallback = navParams.data.finishCallback;

    if ( this.shop.id > 0 )
    {
      this.mEditState = 'create';
    }
    else
    {
      this.mEditState = 'edit';
    }
  }

  showToastWithCloseButton(errcmsg) {
    const toast = this.toastCtrl.create({
      message: errcmsg,
      duration: 3000
    });
    toast.present();
  }

  ionViewDidLoad()
  {
    if ( this.shop.id > 0 )
    {
      this.shopData.getShopDetail(this.shop.id).then(
        info => {
          let data: any = info;
          if (data.errcode == 0) {
            this.shop = data.data;
          } else {
            this.showToastWithCloseButton(data.errmsg);
          }
        },
        error => {
          this.showToastWithCloseButton("系统繁忙")
        }
      )
    }
    else
    {
      this.shop = {}
    }
  }

  saveShopData()
  {
    if ( this.shop.id > 0 )
    {
      this.shopData.updateShopData(this.shop).then(
        info => {
          let data: any = info;
          if (data.errcode == 0) {
            this.showToastWithCloseButton("修改成功");
            this.finishCallback(this.shop);
            this.navCtrl.pop();
          } else {
            this.showToastWithCloseButton(data.errmsg);
          }
        },
        error => {
          this.showToastWithCloseButton("系统繁忙")
        }
      )
    }
    else
    {
      this.shopData.createShopData(this.shop).then(
        info => {
          let data: any = info;
          if (data.errcode == 0) {
            this.finishCallback(this.shop);
            this.navCtrl.pop();
            this.showToastWithCloseButton("创建成功");
          } else {
            this.showToastWithCloseButton(data.errmsg);
          }
        },
        error => {
          this.showToastWithCloseButton("系统繁忙")
        }
      )
    }
  }
}
