import { Component } from '@angular/core';
import { NavController, NavParams, ViewController, ToastController } from 'ionic-angular';
import { Card, Arrears } from '../../providers/member-data';
@Component({
  selector: 'page-member-card-arrears',
  templateUrl: 'member-card-arrears.html'
})
export class MemberCardArrearsPage {
  card: Card;
  arr: Arrears;
  edit = false;
  constructor(public navCtrl: NavController,
    public toastCtrl: ToastController,
    public viewCtrl: ViewController,
    public navParams: NavParams) {
    this.card = navParams.data.card;
    this.arr = navParams.data.arrears;
    if (this.arr.name)
      this.edit = true;
    else {
      this.arr.type = 'arrears';
      let d = new Date();
      this.arr.name = `${d.getFullYear()}年${d.getMonth() + 1}月${d.getDate()}日欠款`;
    }
  }

  save() {
    if (!this.arr.name) {
      this.showToast('请输入名称');
      return;
    }
    if (!this.arr.arrears_amount) {
      this.showToast('请输入金额');
      return;
    }
    if (!this.arr.type) {
      this.showToast('请选择类型');
      return;
    }
    if (!this.edit) {
      this.card.arrears_ids.push(this.arr);
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

  dismiss() {
    this.viewCtrl.dismiss();
  }
}
