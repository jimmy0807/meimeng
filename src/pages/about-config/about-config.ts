import { Component } from '@angular/core';
import { NavController, NavParams, App, ToastController, LoadingController } from 'ionic-angular';
import { NativeStorage } from '@ionic-native/native-storage';
import { LoadingPage } from '../loading/loading';
import { UserData } from '../../providers/user-data';
import { EmployeeInfo, UserInfo, EmployeeData } from '../../providers/employee-data';
@Component({
  selector: 'page-about-config',
  templateUrl: 'about-config.html'
})
export class AboutConfigPage {
  employee: EmployeeInfo = {};
  user: UserInfo = {};
  constructor(public navCtrl: NavController,
    public userData: UserData,
    public employeeData: EmployeeData,
    public toastCtrl: ToastController,
    public loadingCtrl: LoadingController,
    public app: App,
    public nativeStorage: NativeStorage,
    public navParams: NavParams) {
    this.employee = navParams.data;
    this.user = this.employee.user_info;
  }

  ionViewDidLoad() {
  }

  async logout() {
    let loader = this.loadingCtrl.create({ spinner: 'bubbles' });
    loader.present();
    try {
      await this.userData.logout();
      let info = await this.nativeStorage.getItem('ds.reference')
      info.uid = 0
      this.nativeStorage.setItem('ds.reference', info);
      this.app.getRootNav().setRoot(LoadingPage);
    }
    finally {
      loader.dismiss();
    }
  }

  save() {
    this.employeeData.saveUserInfo(this.user).then(
      info => {
        let data: any = info;
        this.showToast(data.errmsg);
      },
      err => this.showToast());
  }

  changePwd() {
    this.navCtrl.push('AboutPasswordPage');
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
