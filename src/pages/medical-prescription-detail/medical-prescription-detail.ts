import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ViewController, ToastController, ModalController } from 'ionic-angular';
import { MedicalData, Prescription } from '../../providers/medical-data';
import { MedicalSelectorPage, SelectorType } from '../medical-selector/medical-selector';

@IonicPage()
@Component({
  selector: 'page-medical-prescription-detail',
  templateUrl: 'medical-prescription-detail.html',
})
export class MedicalPrescriptionDetail {
  p: Prescription = {};
  list: Prescription[] = [];
  title: string;
  segment = 'normal';
  constructor(public navCtrl: NavController,
    public viewCtrl: ViewController,
    public medicalData: MedicalData,
    public modalCtrl: ModalController,
    public toastCtrl: ToastController,
    public navParams: NavParams) {
    this.list = navParams.data.list;
    this.p = navParams.data.p;
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
