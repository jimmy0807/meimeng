import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, Refresher, InfiniteScroll, LoadingController, ToastController } from 'ionic-angular';
import { PartnerData, PartnerCommissionDay } from '../../providers/partner-data';

@IonicPage()
@Component({
  selector: 'page-partner-commission',
  templateUrl: 'partner-commission.html',
})
export class PartnerCommissionPage {
  list: PartnerCommissionDay[] = [];
  daySStr: string;
  dayEStr: string;
  dayEt: number[] = [];
  dayOffset = 0;
  dayRange: string;
  constructor(public navCtrl: NavController,
    public loadingCtrl: LoadingController,
    public toastCtrl: ToastController,
    public partnerData: PartnerData,
    public navParams: NavParams) {
    let d = new Date();
    this.dayEt = [d.getFullYear(), d.getMonth(), d.getDate() + 1];
    this.dayEStr = this.getDate(this.dayEt).toLocaleDateString();
  }

  getDate(arr: number[]) {
    return new Date(arr[0], arr[1], arr[2]);
  }

  getDateStr(d: Date) {
    return `${d.getFullYear()}-${d.getMonth() + 1}-${d.getDate()}`;
  }

  async ngAfterViewInit() {
    let loader = this.loadingCtrl.create({ spinner: 'bubbles' });
    loader.present();
    try {
      await this.getItems();
    }
    catch (e) { this.showToast(); }
    finally {
      loader.dismiss();
    }
  }

  async getItems(refresh = true) {
    let st = new Date(this.dayEt[0], this.dayEt[1] - this.dayOffset - 1, this.dayEt[2]);
    let et = new Date(this.dayEt[0], this.dayEt[1] - this.dayOffset, this.dayEt[2]);
    let r = await this.partnerData.getPartnerCommissionDay(this.getDateStr(st), this.getDateStr(et));
    if (r.errcode === 0) {
      let arr = r.data;
      this.list = refresh ? arr : this.list.concat(arr);
      this.daySStr = st.toLocaleDateString();
      this.dayOffset++;
    }
    else
      this.showToast(r.errmsg);
  }

  async doRefresh(refresher: Refresher) {
    try {
      this.dayOffset = 0;
      await this.getItems(true);
    }
    catch (e) {
      this.showToast();
    }
    finally {
      refresher.complete();
    }
  }

  async lastMonth() {
    let loader = this.loadingCtrl.create({ spinner: 'bubbles' });
    loader.present();
    try { await this.getItems(false); }
    catch (e) { }
    finally { loader.dismiss(); }
  }

  show(day: PartnerCommissionDay) {
    this.navCtrl.push('PartnerCommissionLinesPage', day);
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
