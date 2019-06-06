import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ViewController, ToastController, ModalController } from 'ionic-angular';
import { MedicalData, Bed, Ward } from '../../providers/medical-data';
import { MedicalSelectorPage, SelectorType } from '../medical-selector/medical-selector';

@IonicPage()
@Component({
  selector: 'page-medical-bed-detail',
  templateUrl: 'medical-bed-detail.html',
})
export class MedicalBedDetail {
  b: Bed = {};
  w: Ward;
  list: Bed[] = [];
  editMode = false;
  title: string;
  inWard = false;
  newWard = true;
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
    this.b = navParams.data.b;
    this.w = navParams.data.w;
    this.editMode = this.b.id > 0;
    this.title = this.editMode ? '编辑' : '新建';
    if (!this.editMode) {
      this.b.state = 'normal';
    }
    if (this.w) {
      this.inWard = true;
      this.b.ward_name = this.w.name;
      if (this.w.id) {
        this.newWard = false;
        this.b.ward_id = this.w.id;
      }
    }
  }

  async save() {
    if (!(this.b.name)) {
      this.showToast("请输入名称");
      return;
    }
    if (!this.b.state) {
      this.showToast("请选择状态");
      return;
    }
    this.b.state_name = this.state_dict[this.b.state];

    if (this.inWard && this.newWard) {
      if (this.w.bed_ids.indexOf(this.b) < 0)
        this.w.bed_ids.unshift(this.b);
      this.dismiss();
      return;
    }

    let r = await this.medicalData.saveMedicalBed(this.b);
    this.showToast(r.errmsg)
    if (r.errcode === 0) {
      this.b.id = r.data.id;
      if (!this.editMode) {
        this.list.unshift(this.b);
      }
      this.viewCtrl.dismiss();
    }
  }

  select(type: string) {
    switch (type) {
      case 'ward':
        this.modalSelector(SelectorType.Ward, true, d => {
          this.b.ward_id = d.id;
          this.b.ward_name = d.name;
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
