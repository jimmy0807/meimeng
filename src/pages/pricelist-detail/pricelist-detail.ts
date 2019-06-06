import { Component } from '@angular/core';
import { PricelistData, Pricelist } from '../../providers/pricelist-data';
import { ToastController, NavParams, NavController, ViewController } from 'ionic-angular';
import { PricelistItemsPage } from '../pricelist-items/pricelist-items';
import { AppGlobal } from '../../app-global';

@Component({
  selector: 'page-pricelist-detail',
  templateUrl: 'pricelist-detail.html'
})
export class PricelistDetailPage {
  isAdmin = false;
  model: {
    title?: string
    mode?: string
  } = {};
  pricelist: Pricelist = {};
  couponTmpls = [];

  constructor(public navCtrl: NavController,
    public navParams: NavParams,
    public pricelistData: PricelistData,
    public toastCtrl: ToastController,
    public viewController: ViewController, ) {
    if (navParams.data.id > 0) {
      this.pricelist = navParams.data;
      this.model.title = "编辑";
      this.model.mode = 'edit';
    }
    else {
      this.model.title = "新建";
      this.model.mode = 'add';
    }
    let user = AppGlobal.getInstance().user;
    this.isAdmin = user != undefined && user.role == '1';
  }

  ngAfterViewInit() {
    this.getCouponTmpls();
  }

  getCouponTmpls() {
    this.pricelistData.getCouponTmpls().then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.couponTmpls = data.data;
          this.couponTmpls.unshift({ id: 0, name: "无" });
        } else {
          this.showToast(data.errmsg)
        }
      },
      err => {
        this.showToast();
      }
    )
  }

  save() {
    if (this.pricelist.name === undefined || this.pricelist.name === '') {
      this.showToast("请输入名称");
      return;
    }
    if (this.pricelist.first_price_discount === undefined) {
      this.showToast("请输入折扣");
      return;
    }
    if (this.pricelist.first_price_discount < 0 || this.pricelist.first_price_discount > 10) {
      this.showToast("请输入正确的折扣");
      return;
    }
    if (this.pricelist.code === undefined || this.pricelist.code === '') {
      this.showToast("请输入唯一识别码");
      return;
    }
    this.pricelistData.savePricelist(this.pricelist).then(
      info => {
        var data: any = info;
        if (data.errcode == 0) {
          if (this.pricelist.id > 0) { }
          else {
            this.pricelist.id = data.data.id;
            this.pricelist.items = data.data.items;
            this.model.mode = 'edit';
          }
          this.dismiss();
        }
        this.showToast(data.errmsg);
      },
      err => {
        this.showToast();
      }
    );
  };

  showItems() {
    this.navCtrl.push(PricelistItemsPage, this.pricelist);
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }

  dismiss() {
    this.viewController.dismiss();
  }
}
