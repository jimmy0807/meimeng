import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ViewController, ToastController, LoadingController, ModalController } from 'ionic-angular';
import { MedicalData, Pharmacy, Prescription } from '../../providers/medical-data';
import { MedicalSelectorPage, SelectorType } from '../medical-selector/medical-selector';

@IonicPage()
@Component({
  selector: 'page-medical-pharmacy-detail',
  templateUrl: 'medical-pharmacy-detail.html',
})
export class MedicalPharmacyDetail {
  w: Pharmacy = {};
  list: Pharmacy[] = [];
  list_prescription: Prescription[] = [];
  editMode = false;
  title: string;
  segment = 'normal';
  constructor(public navCtrl: NavController,
    public loadingCtrl: LoadingController,
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
      this.w.prescription_ids = [];
    }
  }

  async save() {
    if (!(this.w.name)) {
      this.showToast("请输入名称");
      return;
    }
    if (!(this.w.employee_name)) {
      this.showToast("请选择负责人");
      return;
    }
    console.log(this.w);
    let r = await this.medicalData.saveMedicalPharmacy(this.w);
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
      case 'employee':
        this.modalSelector(SelectorType.Employee, true, d => {
          this.w.employee_id = d.id;
          this.w.employee_name = d.name;
          console.log("+++w+++", this.w);
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
  async editPrescription(i: Pharmacy) {
    let loader = this.loadingCtrl.create({ spinner: 'bubbles' });
    loader.present();
    try {
      await this.getItem(i.id);
    }
    finally {
      loader.dismiss();
      i = this.list_prescription[0];
      console.log(i)
      this.navCtrl.push('MedicalPrescriptionDetail', { list: this.list_prescription, p: i })
    }
  }
  async getItem(id) {
    try {
      let r = await this.medicalData.getBornPrescription(0, id);
      if (r.errcode === 0) {
        console.log(this.list_prescription)
        this.list_prescription = r.data;
      }
      else {
        this.showToast(r.errmsg);
      }
    } catch (e) {
      this.showToast();
    }
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