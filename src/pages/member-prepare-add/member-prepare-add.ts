import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ToastController, ModalController, ViewController } from 'ionic-angular';
import { MemberPrepare, MemberData } from '../../providers/member-data';
import { MedicalSelectorPage, SelectorType } from '../medical-selector/medical-selector';

@IonicPage()
@Component({
  selector: 'page-member-prepare-add',
  templateUrl: 'member-prepare-add.html',
})
export class MemberPrepareAddPage {
  p: MemberPrepare = {};
  list: MemberPrepare[] = [];
  constructor(public navCtrl: NavController,
    public toastCtrl: ToastController,
    public viewCtrl: ViewController,
    public modalCtrl: ModalController,
    public memberData: MemberData,
    public navParams: NavParams) {
    this.p = navParams.data.p;
    this.list = navParams.data.list;
  }

  select(type: string) {
    switch (type) {
      case 'res':
        this.modalSelector(SelectorType.MemberResist, false, d => {
          this.p.be_resist_ids = d
          this.p.resist_names = this.p.be_resist_ids.map(l => l.name).join(', ');
        });
        break;
      case 'par':
        this.modalSelector(SelectorType.MemberPart, false, d => {
          this.p.be_part_ids = d
          this.p.part_names = this.p.be_part_ids.map(l => l.name).join(', ');
        });
        break;
      case 'emp':
        this.modalSelector(SelectorType.Employee, true, d => {
          this.p.employee_id = d.id;
          this.p.employee_name = d.name;
        });
        break;
    }
  }

  async save() {
    if (!this.p.be_part_ids || !this.p.be_part_ids.length) {
      this.showToast("请选择部位");
      return;
    }
    if (!this.p.prepare_date) {
      this.showToast("请选择日期");
      return;
    }

    let r = await this.memberData.saveMemberPrepare(this.p);
    this.showToast(r.errmsg)
    if (r.errcode === 0) {
      this.p.id = r.data.id;
      if (this.list.indexOf(this.p) < 0)
        this.list.unshift(this.p);
      this.viewCtrl.dismiss();
    }
  }

  order() {
    if (this.p.is_consume) {
      this.navCtrl.push('PadOrderPage', { mid: this.p.member_id, name: this.p.member_name });
    }
    else {
      this.navCtrl.push("MemberPlanPage", { mid: this.p.member_id, name: this.p.member_name, p: this.p });
    }
  }

  modalSelector(type: SelectorType, single: boolean, callback: Function) {
    let m = this.modalCtrl.create(MedicalSelectorPage, { type: type, single: single });
    m.onDidDismiss(data => {
      if (data)
        callback(data);
    });
    m.present();
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
