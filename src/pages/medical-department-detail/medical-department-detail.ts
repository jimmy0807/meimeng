import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ViewController, ToastController, ModalController } from 'ionic-angular';
import { MedicalData, Department } from '../../providers/medical-data';
import { MedicalSelectorPage, SelectorType } from '../medical-selector/medical-selector';

@IonicPage()
@Component({
  selector: 'page-medical-department-detail',
  templateUrl: 'medical-department-detail.html',
})
export class MedicalDepartmentDetail {

  d: Department = {};
  list: Department[] = [];
  editMode = false;
  title: string;
  constructor(public navCtrl: NavController,
    public viewCtrl: ViewController,
    public medicalData: MedicalData,
    public modalCtrl: ModalController,
    public toastCtrl: ToastController,
    public navParams: NavParams) {
    this.list = navParams.data.list;
    this.d = navParams.data.d;
    this.editMode = this.d.id > 0;
    this.title = this.editMode ? '编辑' : '新建';
  }

  async save() {
    if (!(this.d.name)) {
      this.showToast("请输入名称");
      return;
    }

    let r = await this.medicalData.saveBornDepartment(this.d);
    this.showToast(r.errmsg)
    if (r.errcode === 0) {
      this.d.id = r.data.id;
      if (!this.editMode) {
        this.list.unshift(this.d);
      }
      this.viewCtrl.dismiss();
    }
  }

  select(type: string) {
    switch (type) {
      case 'doctor':
        this.modalSelector(SelectorType.Doctor, true, d => {
          this.d.hr_doctor_id = d.id;
          this.d.hr_doctor_name = d.name;
        });
        break;
      case 'doctors':
        this.modalSelector(SelectorType.Doctor, false, d => {
          this.d.hr_doctor_ids = d;
        });
        break;
      case 'operates':
        this.modalSelector(SelectorType.Nurse, false, d => {
          this.d.hr_operate_ids = d;
        });
        break;
      case 'parent':
        this.modalSelector(SelectorType.Department, true, d => {
          this.d.parent_id = d.id;
          this.d.parent_name = d.name;
        });
        break;
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
