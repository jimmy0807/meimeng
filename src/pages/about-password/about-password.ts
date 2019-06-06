import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ToastController } from 'ionic-angular';
import { UserData } from '../../providers/user-data';

@IonicPage()
@Component({
  selector: 'page-about-password',
  templateUrl: 'about-password.html',
})
export class AboutPasswordPage {
  oldp: string;
  newp: string;
  confirmp: string;
  constructor(public navCtrl: NavController,
    public toastCtrl: ToastController,
    public userData: UserData,
    public navParams: NavParams) {
  }

  ngAfterViewInit() {
  }

  async save() {
    if (!this.oldp) {
      this.showToast('请输入原密码');
      return;
    }
    if (!this.newp) {
      this.showToast('请输入新密码');
      return;
    }
    if (this.newp === this.oldp) {
      this.showToast('新密码不能与原密码相同');
      return;
    }
    if (!this.confirmp) {
      this.showToast('请确认新密码');
      return;
    }
    if (this.newp !== this.confirmp) {
      this.showToast('密码不一致');
      return;
    }

    let r = await this.userData.changePwd(this.oldp, this.newp);
    this.showToast(r.errmsg)
    if (r.errcode == 0)
      this.navCtrl.pop();
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
