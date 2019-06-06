import { Component } from '@angular/core';
import { NavController, NavParams, ViewController, ToastController } from 'ionic-angular';
import { SmsData, SmsConfig } from '../../providers/sms-data';
import { SmsSignDetailPage } from '../sms-sign-detail/sms-sign-detail';

@Component({
  selector: 'page-sms-config-detail',
  templateUrl: 'sms-config-detail.html'
})

export class SmsConfigDetailPage {
  cfg: SmsConfig = {}
  editMode = false;
  constructor(public navCtrl: NavController,
    public smsData: SmsData,
    public viewCtrl: ViewController,
    public toastCtrl: ToastController,
    public navParams: NavParams) {
    this.cfg = navParams.data;
    this.editMode = this.cfg.id > 0;
  }

  save() {
    if (!this.cfg.name) {
      this.showToast('请输入名称');
      return;
    }
    if (!this.cfg.supplier) {
      this.showToast('请选择服务商');
      return;
    }
    switch (this.cfg.supplier) {
      case 'aliyun':
        if (!this.cfg.aliyun_access_key_id) {
          this.showToast('请输入Access Key Id');
          return;
        }
        if (!this.cfg.aliyun_access_key_secret) {
          this.showToast('请输入Access Key Secret');
          return;
        }
        break;
      case 'dianxin':
        if (!this.cfg.dx_app_id) {
          this.showToast('请输入应用ID');
          return;
        }
        if (!this.cfg.dx_app_secret) {
          this.showToast('请输入应用密钥');
          return;
        }
        break;
    }

    this.smsData.saveSmsConfig(this.cfg).then(
      info => {
        let data: any = info;
        this.showToast(data.errmsg);
        if (data.errcode == 0) {
          this.viewCtrl.dismiss();
        }
      },
      err => this.showToast());
  }

  addSign() {
    if (!this.cfg.aliyun_sign_name_ids)
      this.cfg.aliyun_sign_name_ids = [];
    this.navCtrl.push(SmsSignDetailPage, { cfg: this.cfg, sign: {} })
  }

  editSign(s) {
    this.navCtrl.push(SmsSignDetailPage, { cfg: this.cfg, sign: s })
  }

  removeSign(s) {
    let index = this.cfg.aliyun_sign_name_ids.indexOf(s);
    this.cfg.aliyun_sign_name_ids.splice(index, 1);
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
