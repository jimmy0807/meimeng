import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ViewController, ToastController, ModalController } from 'ionic-angular';
import { MedicalData, VisitLevel } from '../../providers/medical-data';
import { MedicalSelectorPage, SelectorType } from '../medical-selector/medical-selector';

@IonicPage()
@Component({
  selector: 'page-medical-visit-level-detail',
  templateUrl: 'medical-visit-level-detail.html',
})
export class MedicalVisitLevelDetail {
  w: VisitLevel = {};
  list: VisitLevel[] = [];
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
      this.w.category_ids = [];
    }
  }

  async save() {
    if (!(this.w.name)) {
      this.showToast("请输入名称");
      return;
    }
    if (!(this.w.days)) {
      this.showToast("请输入天数");
      return;
    }
    if (!(this.w.category)) {
      this.showToast("请选择类型");
      return;
    }

    let r = await this.medicalData.saveVisitLevel(this.w);
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
      case 'pos':
        this.modalSelector(SelectorType.PosCategory, true, d => {
          let arr: any[] = d;
          let ids = this.w.category_ids.map(c => c.id);
          for (var i = 0; i < arr.length; i++) {
            if (ids.indexOf(arr[i].id) < 0)
              this.w.category_ids.push(arr[i]);
          }
        });
        break;
    }
  }


  addCat() {
    this.select('pos');
  }

  deleteCat(i) {
    let index = this.w.category_ids.indexOf(i);
    this.w.category_ids.splice(index, 1);
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
