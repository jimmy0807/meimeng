import { Component } from '@angular/core';
import { NavController, ToastController, NavParams, ViewController } from 'ionic-angular';
import { AuthData } from '../../providers/auth-data';
import { AppGlobal } from '../../app-global';

@Component({
  selector: 'page-authorization-detail',
  templateUrl: 'authorization-detail.html'
})
export class AuthorizationDetailPage {

  auth: { remark?: string } = {};
  authorization: any;
  user;
  constructor(public navCtrl: NavController,
    private toastCtrl: ToastController,
    public authData: AuthData, public viewCtrl: ViewController,
    public navParams: NavParams) {
    this.authorization = navParams.data;
    this.auth.remark = this.authorization.remark;
    this.user = AppGlobal.getInstance().user;
  }

  ionViewDidLoad() {
  }

  updateAuthorization(state) {
    if (!this.auth.remark) {
      this.showToast('请填写审批批注信息');
      return;
    }
    let param = {
      'id': this.authorization.id,
      'remark': this.auth.remark,
      'state': state,
    }
    this.authData.updateAuthorization(param).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.viewCtrl.dismiss(data.data);
        } else {
          this.showToast(data.errmsg);
        }
      },
      error => {
      }
    )
  }

  dismiss() {
    this.viewCtrl.dismiss();
  }

  showToast(errcmsg) {
    const toast = this.toastCtrl.create({
      message: errcmsg,
      duration: 3000
    });
    toast.present();
  }
}
