import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, Refresher, InfiniteScroll, LoadingController, ToastController } from 'ionic-angular';
import { MemberData, PadOrder } from '../../providers/member-data';
import { ApiResult } from '../../providers/api-http';

@IonicPage()
@Component({
  selector: 'page-pad-order',
  templateUrl: 'pad-order.html',
})
export class PadOrderPage {
  list: PadOrder[] = [];
  infiniteEnabled = true;
  mid: number;
  name: string;
  groups: PadOrder[] = new Array();
  keys: string[] = [];
  constructor(public navCtrl: NavController,
    public loadingCtrl: LoadingController,
    public toastCtrl: ToastController,
    public memberData: MemberData,
    public navParams: NavParams) {
    this.mid = navParams.data.mid;
    this.name = navParams.data.name;
  }

  async ngAfterViewInit() {
    let loader = this.loadingCtrl.create({ spinner: 'bubbles' });
    loader.present();
    try {
      await this.getItems();
    }
    finally {
      loader.dismiss();
    }
  }

  groupItems(items: PadOrder[] = null) {
    if (!items) {
      this.groups = new Array();
      this.keys = [];
    }
    let g: PadOrder[] = this.groups;
    let arr = items || this.list;
    let key = '';
    for (var i = 0; i < arr.length; i++) {
      key = arr[i].date;
      if (g[key])
        g[key].push(arr[i]);
      else {
        g[key] = [arr[i]];
        this.keys.push(key);
      }
    }
  }

  async getItems(offset = 0, append = false) {
    try {
      let r: ApiResult;
      r = await this.memberData.getPadOrders(this.mid, offset);

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
          this.list = r.data;
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

  async doRefresh(refresher: Refresher) {
    try {
      await this.getItems(0);
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

  edit(i: PadOrder) {
    this.navCtrl.push('MemberPlanPage', { order: i, list: this.list });
  }

  add() {
    this.navCtrl.push("MemberPlanPage", { mid: this.mid, name: this.name, list: this.list });
  }

  async delete(i) {
    let r = await this.memberData.deletePadOrder(i.id);
    this.showToast(r.errmsg);
    if (r.errcode === 0) {
      let index = this.list.indexOf(i);
      this.list.splice(index, 1);
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
