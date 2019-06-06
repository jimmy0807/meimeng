import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ToastController } from 'ionic-angular';
import { MemberMedicalInfo, MemberData } from '../../providers/member-data';

@IonicPage()
@Component({
  selector: 'page-member-sourceinfo',
  templateUrl: 'member-sourceinfo.html',
})
export class MemberSourceinfoPage {
  info: MemberMedicalInfo = {};
  mid: number;
  constructor(public navCtrl: NavController,
    public memberData: MemberData,
    public toastCtrl: ToastController,
    public navParams: NavParams) {
    this.mid = navParams.data;
  }

  async ngAfterViewInit() {
    try {
      let r = await this.memberData.getMemberMedicalInfo(this.mid);
      if (r.errcode === 0) {
        this.info = r.data;
      }
    }
    catch (e) {
      this.showToast();
    }
  }

  async save() {
    try {
      let r = await this.memberData.saveMemberMedicalInfo(this.info);
      this.showToast(r.errmsg);
    }
    catch (e) {
      this.showToast();
    }
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
