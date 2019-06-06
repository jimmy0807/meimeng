import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, LoadingController, ToastController } from 'ionic-angular';
import { PartnerData, PartnerCommission, PartnerCommissionDay } from '../../providers/partner-data';

@IonicPage()
@Component({
  selector: 'page-partner-commission-lines',
  templateUrl: 'partner-commission-lines.html',
})
export class PartnerCommissionLinesPage {
  list: PartnerCommission[] = [];
  day: PartnerCommissionDay;
  arr: {
    id: number,
    name: string,
    sum: number,
    items: PartnerCommission[]
  }[] = new Array();
  keys = [];
  constructor(public navCtrl: NavController,
    public loadingCtrl: LoadingController,
    public toastCtrl: ToastController,
    public partnerData: PartnerData,
    public navParams: NavParams) {
    this.day = navParams.data;
  }

  async ngAfterViewInit() {
    let loader = this.loadingCtrl.create({ spinner: 'bubbles' });
    loader.present();
    try {
      let r = await this.partnerData.getPartnersCommission(this.day.ids);
      if (r.errcode === 0) {
        this.list = r.data;
        this.groupItem();
      }
      else
        this.showToast(r.errmsg);
    }
    catch (e) {
      this.showToast();
    }
    finally {
      loader.dismiss();
    }
  }

  groupItem() {
    let a = this.arr;
    for (let c of this.list) {
      if (a[c.partner_id]) {
        a[c.partner_id].items.push(c);
        a[c.partner_id].sum += c.base_amount;
      }
      else {
        a[c.partner_id] = {
          id: c.partner_id,
          items: [c],
          name: c.partner_name,
          sum: c.base_amount
        }
        this.keys.push(c.partner_id);
      }
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
