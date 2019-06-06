import { Component } from '@angular/core';
import { NavController, NavParams, ToastController } from 'ionic-angular';
import { SmsData, SmsTemplate } from '../../providers/sms-data';
import { SmsTemplateDetailPage } from '../sms-template-detail/sms-template-detail';
import { LoadingController } from 'ionic-angular';

@Component({
  selector: 'page-sms-template-list',
  templateUrl: 'sms-template-list.html'
})
export class SmsTemplateListPage {
  list: SmsTemplate[] = [];
  constructor(public navCtrl: NavController,
    public smsData: SmsData,
    public loadingCtrl: LoadingController,
    public toastCtrl: ToastController,
    public navParams: NavParams) { }

  ngAfterViewInit() {
    let loader = this.loadingCtrl.create({
      spinner: 'bubbles',
    });
    loader.present();
    this.smsData.getSmsTemplateList(null).then(
      info => {
        let data: any = info;
        if (data.errcode == 0)
          this.list = data.data;
        else
          this.showToast(data.errmsg);
      },
      err => this.showToast())
      .then(s => loader.dismiss()).catch(err => loader.dismiss());
  }

  add() {
    this.navCtrl.push(SmsTemplateDetailPage, {});
  }

  edit(item) {
    this.navCtrl.push(SmsTemplateDetailPage, item);
  }

  delete(item) {
    this.smsData.deleteSmsTemplate(item.id).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          let index = this.list.indexOf(item);
          this.list.splice(index, 1);
        }
        this.showToast(data.errmsg);
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
