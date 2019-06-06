import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ToastController, ViewController } from 'ionic-angular';
import { UserData } from '../../providers/user-data';

@IonicPage()
@Component({
  selector: 'page-login-reset-pwd',
  templateUrl: 'login-reset-pwd.html',
})
export class LoginResetPwdPage {
  login: string;
  token: string;
  newp: string;
  confirmp: string;
  tokenText = '获取验证码';
  allowGet = true;
  sec = 60;
  timer;
  constructor(public navCtrl: NavController,
    public toastCtrl: ToastController,
    public viewCtrl: ViewController,
    public userData: UserData,
    public navParams: NavParams) {
  }

  ngAfterViewInit() {
  }

  async getToken() {
    if (!this.allowGet)
      return;
    if (!this.login) {
      this.showToast('请输入手机号');
      return;
    }
    let r = await this.userData.getResetPwdToken(this.login);
    this.showToast(r.errmsg);
    if (r.errcode === 0) {
      this.allowGet = false;
      this.timer = setInterval(this.countDown.bind(this), 1000);
    }
  }

  countDown() {
    if (this.sec > 0) {
      this.tokenText = String(this.sec) + "秒后重新获取";
      this.sec--;
    }
    else {
      this.sec = 60;
      this.allowGet = true;
      this.tokenText = '获取验证码';
      clearInterval(this.timer);
    }
  }

  async save() {
    if (!this.login) {
      this.showToast('请输入手机号');
      return;
    }
    if (!this.token) {
      this.showToast('请输入验证码');
      return;
    }
    if (!this.newp) {
      this.showToast('请输入新密码');
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

    let r = await this.userData.resetPwd(this.login, this.token, this.newp);
    this.showToast(r.errmsg)
    if (r.errcode == 0)
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
