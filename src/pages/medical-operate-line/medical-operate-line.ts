import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ViewController, ToastController, ModalController } from 'ionic-angular';
import { MedicalData, OperateLine, Operate } from '../../providers/medical-data';
import { MedicalSelectorPage, SelectorType } from '../medical-selector/medical-selector';

@IonicPage()
@Component({
  selector: 'page-medical-operate-line',
  templateUrl: 'medical-operate-line.html',
})
export class MedicalOperateLine {
  ol: OperateLine = {};
  o: Operate;
  list: OperateLine[] = [];
  editMode = false;
  title: string;
  inOperate = false;
  newOperate = true;
  state_dict = {
    normal: '空闲',
    vip: '保留',
    special: '占用',
    cancel: '不可用',
  }
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
      this.inOperate = true;
      if (this.o.id) {
        this.newOperate = false;
        this.ol.medical_operate_id = this.o.id;
      }
    }
  }

  async save() {
    if (!(this.ol.name)) {
      this.showToast("请输入名称");
      return;
    }
    if (!this.ol.operate_date) {
      this.showToast("请选择手术时间");
      return;
    }
    if (!this.ol.review_days) {
      this.showToast("请输入复查天数");
      return;
    }

    if (this.inOperate && this.newOperate) {
      if (this.o.line_ids.indexOf(this.ol) < 0)
        this.o.line_ids.unshift(this.ol);
      this.dismiss();
      return;
    }

    let r = await this.medicalData.saveMedicalOperateLine(this.ol);
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
      case 'doc':
        this.modalSelector(SelectorType.Doctor, true, d => {
          this.ol.doctor_id = d.id;
          this.ol.doctor_name = d.name;
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
