import { Component } from '@angular/core';
import { NavController, NavParams, ViewController, ToastController, ActionSheetController, ModalController } from 'ionic-angular';
import { MedicalData, Advisory } from '../../providers/medical-data';
import { MedicalSelectorPage, SelectorType } from '../medical-selector/medical-selector';

@Component({
  selector: 'page-medical-advisory-detail',
  templateUrl: 'medical-advisory-detail.html'
})
export class MedicalAdvisoryDetailPage {
  a: Advisory = {};
  list: Advisory[] = [];
  editMode = false;
  title: string;
  cats = [];
  types = [];
  constructor(public navCtrl: NavController,
    public viewCtrl: ViewController,
    public asCtrl: ActionSheetController,
    public medicalData: MedicalData,
    public modalCtrl: ModalController,
    public toastCtrl: ToastController,
    public navParams: NavParams) {
    this.list = navParams.data.list;
    this.a = navParams.data.c;
    this.editMode = this.a.id > 0;
    this.title = this.editMode ? '编辑' : '新建';
  }

  async ngAfterViewInit() {
  }

  async save() {
    if (!(this.a.customer_id)) {
      this.showToast("请选择客户");
      return;
    }
    if (!(this.a.category)) {
      this.showToast("请选择区分");
      return;
    }
    if (!(this.a.receiver_id)) {
      this.showToast("请选择咨询师");
      return;
    }

    let r = await this.medicalData.saveMedicalAdvisory(this.a);
    this.showToast(r.errmsg)
    if (r.errcode === 0) {
      this.a.id = r.data.id;
      if (!this.editMode) {
        this.list.unshift(this.a);
      }
      this.viewCtrl.dismiss();
    }
  }

  select(type: string) {
    switch (type) {
      case 'customer':
        this.modalSelector(SelectorType.Customer, true, d => {
          this.a.customer_id = d.id;
          this.a.customer_name = d.name;
        });
        break;
      case 'reservation':
        this.modalSelector(SelectorType.Reservation, true, d => {
          this.a.reservation_id = d.id;
          this.a.reservation_name = d.name;
        });
        break;
      case 'receiver':
        this.modalSelector(SelectorType.Receiver, true, d => {
          this.a.receiver_id = d.id;
          this.a.receiver_name = d.name;
        });
        break;
      case 'split':
        this.modalSelector(SelectorType.Split, true, d => {
          this.a.split_id = d.id;
          this.a.split_name = d.name;
        });
        break;
      case 'member':
        this.modalSelector(SelectorType.Member, true, d => {
          this.a.member_id = d.id;
          this.a.member_name = d.name;
        });
        break;
      case 'employee':
        this.modalSelector(SelectorType.Employee, true, d => {
          this.a.employee_id = d.id;
          this.a.employee_id = d.name;
        });
        break;
      case 'designer':
        this.modalSelector(SelectorType.Employee, true, d => {
          this.a.designers_id = d.id;
          this.a.designers_name = d.name;
        });
        break;
      case 'doctor':
        this.modalSelector(SelectorType.Employee, true, d => {
          this.a.doctor_id = d.id;
          this.a.doctor_name = d.name;
        });
        break;
      case 'product':
        this.modalSelector(SelectorType.Product, false, d => {
          this.a.product_ids = d;
        });
        break;
      case 'reservation':
        this.modalSelector(SelectorType.Reservation, true, d => {
          this.a.reservation_id = d.id;
          this.a.reservation_name = d.name;
        });
        break;
      case 'operate':
        this.modalSelector(SelectorType.Operate, true, d => {
          this.a.operate_id = d.id;
          this.a.operate_name = d.name;
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