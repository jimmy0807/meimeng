import { Component } from '@angular/core';
import { NavController, NavParams, ToastController, ViewController } from 'ionic-angular';
import { ConsumerData } from '../../providers/consumer-data';


@Component({
  selector: 'page-user-permitshop',
  templateUrl: 'user-permitshop.html'
})
export class UserPermitshopPage {
  shops = [];
  shop_id;
  shopLists = [];
  sid: number = 0;
  mode = "";
  constructor(public navCtrl: NavController,
    public toastCtrl: ToastController,
    public viewCtrl: ViewController,
    public consumerData: ConsumerData,
    public navParams: NavParams) {
    this.shops = navParams.data[0];
    this.shopLists = navParams.data[1];
    this.shop_id = navParams.data[2];
    this.mode = navParams.data[3];
    // console.log("shops1", this.shops);
    // console.log("shops2", this.shopLists);
    //this.sid = AppGlobal.getInstance().sid;
    // console.log("ShopLists", this.shopLists);
    // console.log("id", this.shopLists[0].id);
    if (this.shops != undefined && this.shops.length>0) {
      this.shopLists.forEach(id_a => {
        this.shops.every(id_b => {
          if (id_a.id == id_b.id) {
            id_a.active = true;
            return false;
          }
          else
            id_a.active = false;
          return true;
        });
      });
    }


  }

  ionViewDidLoad() {
    console.log('ionViewDidLoad UserPermitshopPage');
    // this.get_shopLists();

  }

  save_shoplists() {

    // console.log(this.shopLists);

    let selected: any = []
    this.shopLists.forEach(function (e) {
      if (e.active) {
        selected.push(e)
      }
      e.active = false;
    });
    // console.log(selected.length);
    if (selected.length <= 0) {
      return;
    }
    //  let ids = [];
    // this.shopLists.forEach(function (e) {
    //   if (e.active == true) {
    //     ids.push(e.id);
    //   }
    // });
    // this.shops = ids;
    // console.log(this.shops);
    this.viewCtrl.dismiss(selected);
  }
  showToastWithCloseButton(errcmsg) {
    const toast = this.toastCtrl.create({
      message: errcmsg,
      duration: 3000
    });
    toast.present();
  }
  dismiss() {

    this.viewCtrl.dismiss();
  }
}
