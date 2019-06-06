import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ViewController, ToastController, ModalController } from 'ionic-angular';
import { MedicalData, Operate } from '../../providers/medical-data';
import { MedicalSelectorPage, SelectorType } from '../medical-selector/medical-selector';

@IonicPage()
@Component({
  selector: 'page-medical-operate-detail',
  templateUrl: 'medical-operate-detail.html',
})
export class MedicalOperateDetail {
  o: Operate = {};
  list: Operate[] = [];
  editMode = false;
  title: string;
  segment = 'normal';
  constructor(public navCtrl: NavController,
    public viewCtrl: ViewController,
    public medicalData: MedicalData,
    public modalCtrl: ModalController,
    public toastCtrl: ToastController,
    public navParams: NavParams) {
    this.list = navParams.data.list;
    this.o = navParams.data.w;
    this.editMode = this.o.id > 0;
    this.title = this.editMode ? '编辑' : '新建';
    if (!this.editMode) {
      this.o.line_ids = [];
    }
  }

  async save() {
    if (!(this.o.name)) {
      this.showToast("请输入名称");
      return;
    }
    if (!(this.o.doctor_name)) {
      this.showToast("请选择医生");
      return;
    }
    if (!(this.o.member_name)) {
      this.showToast("请选择病人");
      return;
    }
    if (!(this.o.first_treat_date)) {
      this.showToast("请选择初诊时间");
      return;
    }
    let r = await this.medicalData.saveMedicalOperate(this.o);
    this.showToast(r.errmsg)
    if (r.errcode === 0) {
      this.o.id = r.data.id;
      if (!this.editMode) {
        this.list.unshift(this.o);
      }
      this.viewCtrl.dismiss();
    }
  }

  select(type: string) {
    switch (type) {
      case 'doc':
        this.modalSelector(SelectorType.Doctor, true, d => {
          this.o.doctor_id = d.id;
          this.o.doctor_name = d.name;
        });
        break;
      case 'mem':
        this.modalSelector(SelectorType.Member, true, d => {
          this.o.member_id = d.id;
          this.o.member_name = d.name;
        });
        break;
      case 'rec':
        this.modalSelector(SelectorType.Nurse, true, d => {
          this.o.records_id = d.id;
          this.o.records_name = d.name;
        });
        break;
    }
  }

  editLine(i) {
    this.navCtrl.push('MedicalOperateLine', { list: this.o.line_ids, ol: i, o: this.o })
  }

  addLine() {
    this.navCtrl.push('MedicalOperateLine', { list: this.o.line_ids, ol: {}, o: this.o })
  }

  async deleteLine(i) {
    if (this.editMode) {
      let r = await this.medicalData.deleteMedicalOperateLine(i.id);
      this.showToast(r.errmsg);
      if (r.errcode != 0)
        return;
    }
    let index = this.o.line_ids.indexOf(i);
    this.o.line_ids.splice(index, 1);
  }

  modalSelector(type: SelectorType, single: boolean, callback: Function) {
    let m = this.modalCtrl.create(MedicalSelectorPage, { type: type, single: single });
    m.onDidDismiss(data => {
      if (data)
        callback(data);
    });
    m.present();
  }

  dismiss() {
    this.viewCtrl.dismiss(false);
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
