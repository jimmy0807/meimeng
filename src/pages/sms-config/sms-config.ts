import { Component } from '@angular/core';
import { NavController, NavParams, ToastController } from 'ionic-angular';
import { SmsData, SmsConfig } from '../../providers/sms-data';
import { SmsConfigDetailPage } from '../sms-config-detail/sms-config-detail';
import { LoadingController } from 'ionic-angular';

@Component({
  selector: 'page-sms-config',
  templateUrl: 'sms-config.html'
})

export class SmsConfigPage {
  cfgs: SmsConfig[] = [];
  constructor(public navCtrl: NavController,
    public loadingCtrl: LoadingController,
    public toastCtrl: ToastController,
    public smsData: SmsData,
    public navParams: NavParams) { }

  async ngAfterViewInit() {
    let loader = this.loadingCtrl.create({
      spinner: 'bubbles',
    });
    loader.present();
    try {
      let data = await this.smsData.getSmsConfigList();
      if (data.errcode == 0)
        this.cfgs = data.data;
      else
        this.showToast(data.errmsg);
    }
    catch (ex) {
      this.showToast();
    }
    finally {
      loader.dismiss();
    }
  }

  edit(item) {
    this.navCtrl.push(SmsConfigDetailPage, item);
  }

  add() {
    this.navCtrl.push(SmsConfigDetailPage, {});
  }

  remove(item) {
    this.smsData.deleteSmsConfig(item.id).then(
      info => {
        let data: any = info;
        this.showToast(data.errmsg);
        if (data.errcode == 0) {
          let index = this.cfgs.indexOf(item);
          this.cfgs.splice(index, 1);
        }
      },
      err => this.showToast());
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
