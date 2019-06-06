import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ViewController, ToastController, ModalController } from 'ionic-angular';
import { MedicalData, Ward } from '../../providers/medical-data';
import { MedicalSelectorPage, SelectorType } from '../medical-selector/medical-selector';

@IonicPage()
@Component({
  selector: 'page-medical-ward-detail',
  templateUrl: 'medical-ward-detail.html',
})
export class MedicalWardDetail {
  w: Ward = {};
  list: Ward[] = [];
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
    this.w = navParams.data.w;
    this.editMode = this.w.id > 0;
    this.title = this.editMode ? '编辑' : '新建';
    if (!this.editMode) {
      this.w.category = 'normal';
      this.w.bed_ids = [];
    }
  }

  async save() {
    if (!(this.w.name)) {
      this.showToast("请输入名称");
      return;
    }
    if (!(this.w.category)) {
      this.showToast("请选择类型");
      return;
    }
    let r = await this.medicalData.saveMedicalWard(this.w);
    this.showToast(r.errmsg)
    if (r.errcode === 0) {
      this.w.id = r.data.id;
      if (!this.editMode) {
        this.list.unshift(this.w);
      }
      this.viewCtrl.dismiss();
    }
  }

  select(type: string) {
    switch (type) {
      case 'department':
        this.modalSelector(SelectorType.Department, true, d => {
          this.w.departments_id = d.id;
          this.w.departments_name = d.name;
        });
        break;
      case 'doctor':
        this.modalSelector(SelectorType.Doctor, true, d => {
          this.w.doctors_id = d.id;
          this.w.doctors_name = d.name;
        });
        break;
      case 'nurse':
        this.modalSelector(SelectorType.Nurse, true, d => {
          this.w.nurse_id = d.id;
          this.w.nurse_name = d.name;
        });
        break;
    }
  }

  editBed(i) {
    this.navCtrl.push('MedicalBedDetail', { list: this.w.bed_ids, b: i, w: this.w })
  }

  addBed() {
    this.navCtrl.push('MedicalBedDetail', { list: this.w.bed_ids, b: {}, w: this.w })
  }

  async deleteBed(i) {
    if (this.editMode) {
      let r = await this.medicalData.deleteMedicalBed(i.id);
      this.showToast(r.errmsg);
      if (r.errcode != 0)
        return;
    }
    let index = this.w.bed_ids.indexOf(i);
    this.w.bed_ids.splice(index, 1);
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
