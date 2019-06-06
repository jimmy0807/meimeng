import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ViewController, ToastController, LoadingController, ModalController } from 'ionic-angular';
import { MedicalData, RecordsLine, Prescription } from '../../providers/medical-data';
import { MedicalSelectorPage, SelectorType } from '../medical-selector/medical-selector';

@IonicPage()
@Component({
  selector: 'page-medical-records-line-detail',
  templateUrl: 'medical-records-line-detail.html',
})
export class MedicalRecordsLineDetail {
  r: RecordsLine = {};
  list: RecordsLine[] = [];
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
    this.r = navParams.data.r;
    this.editMode = this.r.id > 0;
    this.title = this.editMode ? '编辑' : '新建';
    if (!this.editMode) {
      this.r.prescription_ids = [];
    }
  }

  async save() {
    if (!(this.r.doctors_name)) {
      this.showToast("请输入名称");
      return;
    }

    let r = await this.medicalData.saveMedicalRecordsLine(this.r);
    this.showToast(r.errmsg)
    if (r.errcode === 0) {
      this.r.id = r.data.id;
      if (!this.editMode) {
        this.list.unshift(this.r);
      }
      this.viewCtrl.dismiss();
    }
  }
  select(type: string) {
    switch (type) {
      case 'doctors':
        this.modalSelector(SelectorType.Doctor, true, d => {
          this.r.doctors_id = d.id;
          this.r.doctors_name = d.name;
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

  async editPrescription(i: Prescription) {
    let loader = this.loadingCtrl.create({ spinner: 'bubbles' });
    loader.present();
    try {
      await this.getItem(i.id);
    }
    finally {
      loader.dismiss();
      this.navCtrl.push('MedicalPrescriptionDetail', { list: this.r.prescription_ids, p: i })
    }
  }
  async getItem(id) {
    try {
      let r = await this.medicalData.getBornPrescription(0, id);
      if (r.errcode === 0) {
        this.r.prescription_ids.forEach(element => {
          if (element["id"] == r.data[0].id) {
            element.line_ids = r.data[0].line_ids;
          }
        });
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