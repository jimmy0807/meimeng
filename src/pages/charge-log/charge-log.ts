import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, LoadingController, ToastController, Refresher, InfiniteScroll } from 'ionic-angular';
import { ChargeData, FeeRecharge, FeeRecord } from '../../providers/charge-data';

@IonicPage()
@Component({
  selector: 'page-charge-log',
  templateUrl: 'charge-log.html',
})
export class ChargeLogPage {
  segment = 'con';
  list: FeeRecord[] = [];
  list2: FeeRecharge[] = [];
  groups: FeeRecord[] = new Array();
  keys: string[] = [];
  infiniteEnabled = false;
  infiniteEnabled2 = false;
  id: number;
  constructor(public navCtrl: NavController,
    public chargeData: ChargeData,
    public loadingCtrl: LoadingController,
    public toastCtrl: ToastController,
    public navParams: NavParams) {
  }

  async ngAfterViewInit() {
    let loader = this.loadingCtrl.create({ spinner: 'bubbles' });
    loader.present();
    try {
      await Promise.all([this.getItems(), this.getItems2()]);
    }
    finally {
      loader.dismiss();
    }
  }

  async getItems(offset = 0, append = false) {
    try {
      let r = await this.chargeData.getFeeRecord(offset);
      if (r.errcode === 0) {
        let arr = <any[]>r.data;
        this.infiniteEnabled = arr.length === 20;
        if (append) {
          for (var i = 0; i < arr.length; i++) {
            this.list.push(arr[i]);
          }
          this.groupItems();
        }
        else {
          this.list = arr;
          this.groupItems();
        }
      }
      else {
        this.showToast(r.errmsg);
      }
    } catch (e) {
      this.showToast();
    }
  }

  groupItems(items: FeeRecord[] = null) {
    if (!items) {
      this.groups = new Array();
      this.keys = [];
    }
    let g = this.groups;
    let arr = items || this.list;
    let key = '';
    for (var i = 0; i < arr.length; i++) {
      key = arr[i].month;
      if (g[key])
        g[key].push(arr[i]);
      else {
        g[key] = [arr[i]];
        this.keys.push(key);
      }
    }
  }

  async getItems2(offset = 0, append = false) {
    try {
      let r = await this.chargeData.getFeeRecharge(offset);
      if (r.errcode === 0) {
        let arr = <any[]>r.data;
        this.infiniteEnabled2 = arr.length === 20;
        if (append) {
          for (var i = 0; i < arr.length; i++) {
            this.list2.push(arr[i]);
          }
        }
        else {
          this.list2 = arr;
        }
      }
      else {
        this.showToast(r.errmsg);
      }
    } catch (e) {
      this.showToast();
    }
  }

  async doRefresh(refresher: Refresher) {
    try {
      await Promise.all([this.getItems(), this.getItems2()])
    }
    finally {
      refresher.complete();
    }
  }

  async doInfinite(infiniteScroll: InfiniteScroll) {
    try {
      await this.getItems(this.list.length, true);
    }
    finally {
      infiniteScroll.complete();
    }
  }

  async doInfinite2(infiniteScroll: InfiniteScroll) {
    try {
      await this.getItems2(this.list2.length, true);
    }
    finally {
      infiniteScroll.complete();
    }
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
