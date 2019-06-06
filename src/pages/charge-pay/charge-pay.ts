import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ToastController, ViewController, LoadingController } from 'ionic-angular';
import { ChargeData } from '../../providers/charge-data';
import { Alipay } from '@ionic-native/alipay';

declare var Wechat: any;

@IonicPage()
@Component({
  selector: 'page-charge-pay',
  templateUrl: 'charge-pay.html',
})
export class ChargePayPage {
  t: number;
  wx: boolean = true;
  ali: boolean = false;
  constructor(public navCtrl: NavController,
    private alipay: Alipay,
    public viewCtrl: ViewController,
    public loadingCtrl: LoadingController,
    public toastCtrl: ToastController,
    public chargeData: ChargeData,
    public navParams: NavParams) {
    this.t = navParams.data;
  }

  select(type: string) {
    switch (type) {
      case 'wx': this.wx = true; this.ali = false; break;
      case 'ali': this.wx = false; this.ali = true; break;
    }
  }

  async pay() {
    let loader = this.loadingCtrl.create({ spinner: 'bubbles' });
    loader.present();
    try {
      loader.setContent("正在生成订单……");
      let info = await this.chargeData.getPayInfo(this.t, this.ali ? 'alipay' : 'weixin');
      if (info.errcode === 0) {
        loader.setContent("正在跳转到支付……");
        if (this.ali) {
          let r = await this.alipay.pay(info.data.pay_info);
        }
        else {
          let r = await this.wxpay(info.data.pay_info);
        }
        loader.dismiss();
        this.showToast("支付完成");
        this.viewCtrl.dismiss();
      }
      else {
        loader.dismiss();
        this.showToast(info.errmsg);
      }
    }
    catch (e) {
      loader.dismiss();
      this.showToast(e);
    }
  }

  wxpay(params) {
    return new Promise<any>((s, j) => {
      Wechat.sendPaymentRequest(params,
        () => { s('success'); },
        (err) => { j(err); });
    });
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
