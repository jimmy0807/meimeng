import { Component } from '@angular/core';
import { ToastController, NavParams, NavController, ViewController } from 'ionic-angular';
import { PricelistData, Pricelist, PricelistItem } from '../../providers/pricelist-data';
import { PricelistItemsDetailPage } from '../pricelist-items-detail/pricelist-items-detail';
import { AppGlobal } from '../../app-global';

@Component({
  selector: 'page-pricelist-items',
  templateUrl: 'pricelist-items.html'
})
export class PricelistItemsPage {
  isAdmin = false;
  model: { title?: string } = {};
  pricelist: Pricelist = {};
  pricelistItem: PricelistItem = {};

  constructor(public navCtrl: NavController,
    public navParams: NavParams,
    public pricelistData: PricelistData,
    public toastCtrl: ToastController,
    public viewController: ViewController) {
    this.pricelist = navParams.data;
    let user = AppGlobal.getInstance().user;
    this.isAdmin = user != undefined && user.role == '1';
  }

  ionViewDidLoad() {

  }

  edit(item: PricelistItem) {
    if (!this.isAdmin)
      return;
    item.pricelist_id = this.pricelist.id;
    let data = [item, this.pricelist];
    this.navCtrl.push(PricelistItemsDetailPage, data);
  }

  create() {
    let item: PricelistItem = {};
    item.pricelist_id = this.pricelist.id;
    item.applied_on = "3_global";
    item.sequence = 1000;
    let data = [item, this.pricelist];
    this.navCtrl.push(PricelistItemsDetailPage, data);
  }

  unlink(item: PricelistItem) {
    this.pricelistData.deletePricelistItem(item.id).then(
      (info) => {
        let data: any = info;
        this.showToast(data.errmsg);
        if (data.errcode === 0) {
          let index = this.pricelist.items.indexOf(item);
          this.pricelist.items.splice(index, 1);
        }
      },
      err => this.showToast());
  }

  dismiss() {
    this.viewController.dismiss();
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
