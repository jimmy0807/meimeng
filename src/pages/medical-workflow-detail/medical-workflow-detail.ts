import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ViewController, ToastController, ModalController } from 'ionic-angular';
import { MedicalData, Workflow } from '../../providers/medical-data';
import { MedicalSelectorPage, SelectorType } from '../medical-selector/medical-selector';

@IonicPage()
@Component({
  selector: 'page-medical-workflow-detail',
  templateUrl: 'medical-workflow-detail.html',
})
export class MedicalWorkflowDetail {
  w: Workflow = {};
  list: Workflow[] = [];
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
      this.w.activity_ids = [];
    }
  }

  async save() {
    if (!(this.w.name)) {
      this.showToast("请输入名称");
      return;
    }

    let r = await this.medicalData.saveBornWorkflow(this.w);
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

    }
  }

  editActivity(i) {
    this.navCtrl.push('MedicalWorkflowActivityDetail', { list: this.w.activity_ids, a: i, w: this.w })
  }

  addActivity() {
    this.navCtrl.push('MedicalWorkflowActivityDetail', { list: this.w.activity_ids, a: {}, w: this.w })
  }

  async deleteActivity(i) {
    if (this.editMode) {
      let r = await this.medicalData.deleteWorkflowActivity(i.id);
      this.showToast(r.errmsg);
      if (r.errcode != 0)
        return;
    }
    let index = this.w.activity_ids.indexOf(i);
    this.w.activity_ids.splice(index, 1);
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
