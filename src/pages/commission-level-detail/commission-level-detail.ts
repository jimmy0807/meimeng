import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ViewController, ToastController } from 'ionic-angular';
import { MedicalData, MedicalCommissionLevel } from '../../providers/medical-data';
import { PartnerData } from '../../providers/partner-data';

@IonicPage()
@Component({
  selector: 'page-commission-level-detail',
  templateUrl: 'commission-level-detail.html',
})
export class CommissionLevelDetail {
  c: MedicalCommissionLevel = {};
  list: MedicalCommissionLevel[] = [];
  editMode = false;
  title: string;
  regions = [];

  constructor(public navCtrl: NavController,
    public viewCtrl: ViewController,
    public medicalData: MedicalData,
    public partnerData: PartnerData,
    public toastCtrl: ToastController,
    public navParams: NavParams) {
    this.list = navParams.data.list;
    this.c = navParams.data.c;
    this.editMode = this.c.id > 0;
    this.title = this.editMode ? '编辑' : '新建';
    if (!this.editMode) {
      this.c.category = 'v1';
    }
  }
  async ngAfterViewInit() {
    try {
      let r = await this.partnerData.getBornRegions();
      if (r.errcode == 0)
        this.regions = r.data;
    } catch (e) {
      this.showToast();
    }
  }

  async save() {
    if (!(this.c.name)) {
      this.showToast("请输入名称");
      return;
    }
    if (!this.c.region_id) {
      this.showToast("请选择区域");
      return;
    }

    let r = await this.medicalData.saveCommissionLevel(this.c);
    this.showToast(r.errmsg)
    if (r.errcode === 0) {
      this.c.id = r.data.id;
      if (!this.editMode) {
        this.list.unshift(this.c);
      }
      this.viewCtrl.dismiss();
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
