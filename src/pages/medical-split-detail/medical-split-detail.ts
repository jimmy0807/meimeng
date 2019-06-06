import { Component } from '@angular/core';
import { NavController, NavParams, ViewController, ToastController, ActionSheetController, ModalController } from 'ionic-angular';
import { MedicalData, Split } from '../../providers/medical-data';
import { MedicalSelectorPage, SelectorType } from '../medical-selector/medical-selector';

@Component({
  selector: 'page-medical-split-detail',
  templateUrl: 'medical-split-detail.html'
})
export class MedicalSplitDetailPage {
  s: Split = {};
  list: Split[] = [];
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
    this.s = navParams.data.c;
    this.editMode = this.s.id > 0;
    this.title = this.editMode ? '编辑' : '新建';
  }

  async ngAfterViewInit() {
    try {
      let r = await this.medicalData.getAdvisoryCategories();
      if (r.errcode === 0)
        this.cats = r.data;
      r = await this.medicalData.getMedicalTypes();
      if (r.errcode === 0)
        this.types = r.data;
    } catch (e) {
      this.showToast();
    }
  }

  async save() {
    if (!(this.s.customer_id)) {
      this.showToast("请选择客户");
      return;
    }
    if (!(this.s.category_id)) {
      this.showToast("请选择分类");
      return;
    }
    if (!(this.s.type_id)) {
      this.showToast("请选择方式");
      return;
    }
    if (!(this.s.receiver_id)) {
      this.showToast("请选择咨询师");
      return;
    }
    if (!(this.s.content)) {
      this.showToast("请输入内容");
      return;
    }

    let r = await this.medicalData.saveMedicalSplit(this.s);
    this.showToast(r.errmsg)
    if (r.errcode === 0) {
      this.s.id = r.data.id;
      if (!this.editMode) {
        this.list.unshift(this.s);
      }
      this.viewCtrl.dismiss();
    }
  }

  select(type: string) {
    switch (type) {
      case 'customer':
        this.modalSelector(SelectorType.Customer, true, d => {
          this.s.customer_id = d.id;
          this.s.customer_name = d.name;
        });
        break;
      case 'reservation':
        this.modalSelector(SelectorType.Reservation, true, d => {
          this.s.reservation_id = d.id;
          this.s.reservation_name = d.name;
        });
        break;
      case 'receiver':
        this.modalSelector(SelectorType.Receiver, true, d => {
          this.s.receiver_id = d.id;
          this.s.receiver_name = d.name;
        });
        break;
      case 'tags':
        this.modalSelector(SelectorType.Tags, false, d => {
          this.s.tag_ids = d;
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