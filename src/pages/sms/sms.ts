import { Component } from '@angular/core';
import { NavController, NavParams, ModalController, ToastController, ActionSheetController, AlertController, ViewController } from 'ionic-angular';
import { SmsTemplatePage } from '../sms-template/sms-template';
import { SmsTemplateEditPage } from '../sms-template-edit/sms-template-edit';
import { SmsSelectorPage } from '../sms-selector/sms-selector';
import { SmsData, SmsSignName, SmsEntity } from '../../providers/sms-data';
import { Member } from '../../providers/member-data';
import { Employee } from '../../providers/employee-data';

@Component({
  selector: 'page-sms',
  templateUrl: 'sms.html'
})
export class SmsPage {
  names?: string;
  sign: SmsSignName = {};
  signs: SmsSignName[] = [];
  cats = [];
  smsEntity: SmsEntity = {};
  people: {
    members?: Member[],
    employees?: Employee[],
    reminding_ids?: number[],
  } = {};
  constructor(public navCtrl: NavController,
    public modalCtrl: ModalController,
    public asCtrl: ActionSheetController,
    public viewCtrl: ViewController,
    public smsData: SmsData,
    public alertCtrl: AlertController,
    public toastCtrl: ToastController,
    public navParams: NavParams) {
    this.people = navParams.data;
    let mids: any[] = this.people.members;
    let eids: any[] = this.people.employees;
    this.smsEntity.members = mids.map(m => m.id);
    this.smsEntity.employees = eids.map(e => e.id);
    this.smsEntity.reminding_ids = this.people.reminding_ids;
    this.names = mids.map(m => m.name).concat(eids.map(e => e.name)).join('; ');
  }

  ngAfterViewInit() {
    this.smsData.getSmsTemplateCategoryList().then(
      info => {
        let data: any = info;
        if (data.errcode == 0)
          this.cats = data.data;
        else
          this.showToast(data.errmsg);
      },
      err => this.showToast());
  }

  ionViewDidEnter() {
    if (this.smsEntity.supplier === 'aliyun' && this.smsEntity.config_id) {
      this.smsData.getSmsSignNameList(this.smsEntity.config_id).then(
        info => {
          let data: any = info;
          if (data.errcode == 0) {
            this.signs = data.data;
            if (this.signs.length > 0)
              this.sign = this.signs[0];
            else {
              this.signs = [];
              this.sign = {};
            }
          }
          else
            this.showToast(data.errmsg);
        },
        err => this.showToast());
    }
    else {
      this.signs = [];
      this.sign = {};
    }
  }

  selectTmpl() {
    let inputs = this.cats.map(c =>
      <any>{
        type: 'radio',
        label: c.name,
        value: String(c.id),
        checked: c.id === this.smsEntity.category_id,
      });

    let ac = this.alertCtrl.create({
      title: "选择短信分类",
      inputs: inputs,
      buttons: [
        {
          text: '关闭',
          role: 'cancel',
        },
        {
          text: '确定',
          handler: data => {
            let id = Number(data);
            this.smsEntity.category_id = id;
            this.navCtrl.push(SmsTemplatePage, this.smsEntity)
          }
        }
      ]
    });
    ac.present();
  }

  selectNum() {
    let m = this.modalCtrl.create(SmsSelectorPage, this.people);
    m.onDidDismiss(data => {
      if (data) {
        let mids: any[] = data.members;
        let eids: any[] = data.employees;
        this.smsEntity.members = mids.map(m => m.id);
        this.smsEntity.employees = eids.map(e => e.id);
        this.names = mids.map(m => m.name).concat(eids.map(e => e.name)).join('; ');
      }
    })
    m.present();
  }

  selectSign() {
    let inputs = this.signs.map(s =>
      <any>{
        type: 'radio',
        label: s.name,
        value: String(s.id),
        checked: s.id === this.sign.id,
      });

    let ac = this.alertCtrl.create({
      title: "选择签名",
      inputs: inputs,
      buttons: [
        {
          text: '关闭',
          role: 'cancel',
        },
        {
          text: '确定',
          handler: data => {
            let id = Number(data);
            this.sign = this.signs.find(s => s.id === id) || {};
          }
        }
      ]
    });
    ac.present();
  }

  edit() {
    if (this.smsEntity.template && this.smsEntity.template.param_desc_ids.length > 0) {
      let m = this.modalCtrl.create(SmsTemplateEditPage, this.smsEntity);
      //m.onDidDismiss(data => {

      //});
      m.present();
    }
  }

  send() {
    this.smsEntity.sign_id = this.sign.id;

    if (!this.smsEntity.template) {
      this.showToast('请选择模板');
      return;
    }
    this.smsData.sendSms(this.smsEntity).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.showToast("发送成功");
          this.viewCtrl.dismiss();
        }
        else
          this.showToast(data.errmsg);
      },
      err => this.showToast());
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
