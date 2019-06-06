import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ViewController, ToastController, LoadingController, ModalController } from 'ionic-angular';
import { MedicalData, Records, RecordsLine } from '../../providers/medical-data';

@IonicPage()
@Component({
  selector: 'page-medical-records-detail',
  templateUrl: 'medical-records-detail.html',
})
export class MedicalRecordsDetail {
  r: Records = {};
  list: Records[] = [];
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
      this.r.line_ids = [];
    }
  }

  async save() {
    if (!(this.r.name)) {
      this.showToast("请输入名称");
      return;
    }

    let r = await this.medicalData.saveMedicalRecords(this.r);
    this.showToast(r.errmsg)
    if (r.errcode === 0) {
      this.r.id = r.data.id;
      if (!this.editMode) {
        this.list.unshift(this.r);
      }
      this.viewCtrl.dismiss();
    }
  }

  async editRecordsLine(i: RecordsLine) {
    let loader = this.loadingCtrl.create({ spinner: 'bubbles' });
    loader.present();
    try {
      await this.getItem(i.id);
    }
    finally {
      loader.dismiss();
      this.navCtrl.push('MedicalRecordsLineDetail', { list: this.r.line_ids, r: i })
    }
  }
  async getItem(id) {
    try {
      let r = await this.medicalData.getRecordsLine(0, id);
      if (r.errcode === 0) {
        this.r.line_ids.forEach(element => {
          if (element["id"] == r.data[0].id) {
            element.prescription_ids = r.data[0].prescription_ids;
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