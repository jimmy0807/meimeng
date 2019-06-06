import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ViewController, ToastController, ModalController } from 'ionic-angular';
import { MedicalData, WorkflowActivity, Workflow } from '../../providers/medical-data';
import { MedicalSelectorPage, SelectorType } from '../medical-selector/medical-selector';

@IonicPage()
@Component({
  selector: 'page-medical-workflow-activity-detail',
  templateUrl: 'medical-workflow-activity-detail.html',
})
export class MedicalWorkflowActivityDetail {
  a: WorkflowActivity = {};
  w: Workflow;
  list: WorkflowActivity[] = [];
  editMode = false;
  title: string;
  inWorkflow = false;
  newWorkflow = true;

  constructor(public navCtrl: NavController,
    public viewCtrl: ViewController,
    public medicalData: MedicalData,
    public modalCtrl: ModalController,
    public toastCtrl: ToastController,
    public navParams: NavParams) {
    this.list = navParams.data.list;
    this.a = navParams.data.a;
    this.w = navParams.data.w;
    this.editMode = this.a.id > 0;
    this.title = this.editMode ? '编辑' : '新建';

    if (this.w) {
      this.inWorkflow = true;
      this.a.workflow_name = this.w.name;
      if (this.w.id) {
        this.newWorkflow = false;
        this.a.workflow_id = this.w.id;
      }
    }
  }

  async save() {
    if (!(this.a.name)) {
      this.showToast("请输入名称");
      return;
    }
    if (!this.a.workflow_id && !this.inWorkflow) {
      this.showToast("请选择工作流");
      return;
    }

    if (this.inWorkflow && this.newWorkflow) {
      if (this.w.activity_ids.indexOf(this.a) < 0)
        this.w.activity_ids.unshift(this.a);
      this.dismiss();
      return;
    }

    let r = await this.medicalData.saveWorkflowActivity(this.a);
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
      case 'workflow':
        this.modalSelector(SelectorType.Workflow, true, d => {
          this.a.workflow_id = d.id;
          this.a.workflow_name = d.name;
        });
        break;
      case 'parent':
        this.modalSelector(SelectorType.Activity, true, d => {
          this.a.parent_activity_id = d.id;
          this.a.parent_activity_name = d.name;
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
