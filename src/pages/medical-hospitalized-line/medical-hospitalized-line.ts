import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ViewController, ToastController, ModalController } from 'ionic-angular';
import { MedicalData, HospitalizedLine, Hospitalized } from '../../providers/medical-data';
import { MedicalSelectorPage, SelectorType } from '../medical-selector/medical-selector';

@IonicPage()
@Component({
  selector: 'page-medical-hospitalized-line',
  templateUrl: 'medical-hospitalized-line.html',
})
export class MedicalHospitalizedLine {
  ol: HospitalizedLine = {};
  o: Hospitalized;
  list: HospitalizedLine[] = [];
  editMode = false;
  title: string;
  inHospital = false;
  newHospital = true;

  constructor(public navCtrl: NavController,
    public viewCtrl: ViewController,
    public medicalData: MedicalData,
    public modalCtrl: ModalController,
    public toastCtrl: ToastController,
    public navParams: NavParams) {
    this.list = navParams.data.list;
    this.ol = navParams.data.ol;
    this.o = navParams.data.o;
    this.editMode = this.ol.id > 0;
    this.title = this.editMode ? '编辑' : '新建';
    if (!this.editMode) {
    }
    if (this.o) {
      this.inHospital = true;
      if (this.o.id) {
        this.newHospital = false;
        this.ol.hospitalized_id = this.o.id;
      }
    }
  }

  async save() {
    if (!(this.ol.product_id)) {
      this.showToast("请选择产品");
      return;
    }

    if (this.inHospital && this.newHospital) {
      if (this.o.line_ids.indexOf(this.ol) < 0)
        this.o.line_ids.unshift(this.ol);
      this.dismiss();
      return;
    }
    let r = await this.medicalData.saveMedicalHospitalizedLine(this.ol);
    this.showToast(r.errmsg)
    if (r.errcode === 0) {
      this.ol.id = r.data.id;
      if (!this.editMode) {
        this.list.unshift(this.ol);
      }
      this.viewCtrl.dismiss();
    }
  }

  select(type: string) {
    switch (type) {
      case 'prd':
        this.modalSelector(SelectorType.Product, true, d => {
          this.ol.product_id = d.id;
          this.ol.product_name = d.name;
        });
        break;
      case 'uom':
        this.modalSelector(SelectorType.Uom, true, d => {
          this.ol.uom_id = d.id;
          this.ol.uom_name = d.name;
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
