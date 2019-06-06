import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ViewController, ToastController, ModalController } from 'ionic-angular';
import { MedicalData, Hospitalized } from '../../providers/medical-data';
import { MedicalSelectorPage, SelectorType } from '../medical-selector/medical-selector';

@IonicPage()
@Component({
  selector: 'page-medical-hospitalized-detail',
  templateUrl: 'medical-hospitalized-detail.html',
})
export class MedicalHospitalizedDetail {
  o: Hospitalized = {};
  list: Hospitalized[] = [];
  editMode = false;
  title: string;
  segment = 'normal';
  state_dict = {
    checking: '住院中',
    done: '已出院',
  }
  cat_dict = {
    normal: '常规',
    urgent: '紧急',
    other: '其他',
  }
  constructor(public navCtrl: NavController,
    public viewCtrl: ViewController,
    public medicalData: MedicalData,
    public modalCtrl: ModalController,
    public toastCtrl: ToastController,
    public navParams: NavParams) {
    this.list = navParams.data.list;
    this.o = navParams.data.w;
    this.editMode = this.o.id > 0;
    this.title = this.editMode ? '编辑' : '新建';
    if (!this.editMode) {
      this.o.category = 'normal';
      this.o.state = 'checking';
      this.o.line_ids = [];
    }
  }

  async save() {
    if (!(this.o.name)) {
      this.showToast("请输入名称");
      return;
    }
    if (!(this.o.member_id)) {
      this.showToast("请选择病人");
      return;
    }
    if (!(this.o.bed_id)) {
      this.showToast("请选择病床");
      return;
    }
    if (!(this.o.doctors_id)) {
      this.showToast("请选择医生");
      return;
    }

    this.o.state_name = this.state_dict[this.o.state];
    this.o.category_name = this.cat_dict[this.o.category];

    let r = await this.medicalData.saveMedicalHospitalized(this.o);
    this.showToast(r.errmsg)
    if (r.errcode === 0) {
      this.o.id = r.data.id;
      if (!this.editMode) {
        this.list.unshift(this.o);
      }
      this.viewCtrl.dismiss();
    }
  }

  select(type: string) {
    switch (type) {
      case 'doc':
        this.modalSelector(SelectorType.Doctor, true, d => {
          this.o.doctors_id = d.id;
          this.o.doctors_name = d.name;
        });
        break;
      case 'mem':
        this.modalSelector(SelectorType.Member, true, d => {
          this.o.member_id = d.id;
          this.o.member_name = d.name;
        });
        break;
      case 'bed':
        this.modalSelector(SelectorType.Bed, true, d => {
          this.o.bed_id = d.id;
          this.o.bed_name = d.name;
        });
        break;
      case 'des':
        this.modalSelector(SelectorType.Employee, true, d => {
          this.o.designers_id = d.id;
          this.o.designers_name = d.name;
        });
        break;
      case 'emp':
        this.modalSelector(SelectorType.Employee, true, d => {
          this.o.employee_id = d.id;
          this.o.employee_name = d.name;
        });
        break;
      case 'ward':
        this.modalSelector(SelectorType.Ward, true, d => {
          this.o.ward_id = d.id;
          this.o.ward_name = d.name;
        });
        break;
      case 'rec':
        this.modalSelector(SelectorType.Records, true, d => {
          this.o.records_id = d.id;
          this.o.records_name = d.name;
        });
        break;
      case 'ope':
        this.modalSelector(SelectorType.Operate, true, d => {
          this.o.operate_id = d.id;
          this.o.operate_name = d.name;
        });
        break;
    }
  }

  editLine(i) {
    this.navCtrl.push('MedicalHospitalizedLine', { list: this.o.line_ids, ol: i, o: this.o })
  }

  addLine() {
    this.navCtrl.push('MedicalHospitalizedLine', { list: this.o.line_ids, ol: {}, o: this.o })
  }

  async deleteLine(i) {
    if (this.editMode) {
      let r = await this.medicalData.deleteMedicalOperateLine(i.id);
      this.showToast(r.errmsg);
      if (r.errcode != 0)
        return;
    }
    let index = this.o.line_ids.indexOf(i);
    this.o.line_ids.splice(index, 1);
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
