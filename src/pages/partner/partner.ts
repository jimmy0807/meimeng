import { Component } from '@angular/core';
import { NavController, NavParams, ToastController, LoadingController, InfiniteScroll } from 'ionic-angular';
import { Partner, PartnerData } from '../../providers/partner-data';
import { PartnerDetailPage } from '../partner-detail/partner-detail';

@Component({
  selector: 'page-partner',
  templateUrl: 'partner.html'
})
export class PartnerPage {
  list: Partner[] = [];
  keyword = '';
  infiniteEnabled = true;
  constructor(public navCtrl: NavController,
    public toastCtrl: ToastController,
    public loadingCtrl: LoadingController,
    public partnerData: PartnerData,
    public navParams: NavParams) {
  }

  async ngAfterViewInit() {
    let loader = this.loadingCtrl.create({ spinner: 'bubbles', });
    loader.present();
    try {
      await this.getPartners();
    }
    finally {
      loader.dismiss();
    }
  }

  async getPartners(offset: number = 0, key = '') {
    try {
      let r = await this.partnerData.getBornPartners(offset, key);
      if (r.errcode === 0) {
        this.list = r.data;
        this.infiniteEnabled = r.data.length == 20;
      }
      else {
        this.showToast(r.errmsg);
      }
    } catch (e) {
      this.showToast();
    }
  }

  onInput(ev) {
    this.getPartners(0, this.keyword);
  }

  onCancel(ev) {
    this.keyword = '';
  }

  async doInfinite(infiniteScroll: InfiniteScroll) {
    try {
      let r = await this.partnerData.getBornPartners(this.list.length, this.keyword);
      if (r.errcode == 0) {
        let items: Partner[] = r.data;
        for (var i = 0; i < items.length; i++) {
          this.list.push(items[i]);
        }
        this.infiniteEnabled = items.length === 20;
      }
      else {
        this.showToast(r.errmsg);
      }
    } catch (e) {
      this.showToast();
    }
    finally {
      infiniteScroll.complete();
    }
  }

  async delete(item) {
    try {
      let r = await this.partnerData.deleteBornPartner(item.id);
      this.showToast(r.errmsg);
      if (r.errcode == 0) {
        let index = this.list.indexOf(item);
        this.list.splice(index, 1);
      }
    } catch (e) {
      this.showToast();
    }
  }

  add() {
    this.navCtrl.push(PartnerDetailPage, { list: this.list, partner: {} })
  }

  edit(item) {
    this.navCtrl.push(PartnerDetailPage, { list: this.list, partner: item })
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
