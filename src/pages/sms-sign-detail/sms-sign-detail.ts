import { Component } from '@angular/core';
import { NavController, NavParams, ViewController, ToastController } from 'ionic-angular';
import { SmsConfig, SmsSignName } from '../../providers/sms-data';

@Component({
  selector: 'page-sms-sign-detail',
  templateUrl: 'sms-sign-detail.html'
})
export class SmsSignDetailPage {
  sign: SmsSignName = {};
  cfg: SmsConfig = {};
  constructor(public navCtrl: NavController,
    public toastCtrl: ToastController,
    public viewCtrl: ViewController,
    public navParams: NavParams) {
    this.sign = navParams.data.sign;
    this.cfg = navParams.data.cfg;
  }

  ionViewDidLoad() {
    console.log('ionViewDidLoad SmsSignDetailPage');
  }

  save() {
    if (!this.sign.name) {
      this.showToast('请输入签名名称');
      return;
    }
    if (!this.sign.type) {
      this.showToast('请选择签名类型');
      return;
    }
    switch (this.sign.type) {
      case '0': this.sign.type_display_name = '验证码或短信通知'; break;
      case '1': this.sign.type_display_name = '推广短信'; break;
    }
    if (this.cfg.aliyun_sign_name_ids.indexOf(this.sign) < 0) {
      this.cfg.aliyun_sign_name_ids.push(this.sign);
    }
    this.viewCtrl.dismiss();
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
