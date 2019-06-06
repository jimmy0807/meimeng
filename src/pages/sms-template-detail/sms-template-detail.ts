import { Component } from '@angular/core';
import { NavController, NavParams, ToastController, ViewController } from 'ionic-angular';
import { SmsData, SmsTemplate, SmsTemplateParam } from '../../providers/sms-data';

@Component({
  selector: 'page-sms-template-detail',
  templateUrl: 'sms-template-detail.html'
})
export class SmsTemplateDetailPage {
  tmpl: SmsTemplate = {};
  cats = [];
  suppliers = [];
  constructor(public navCtrl: NavController,
    public smsData: SmsData,
    public toastCtrl: ToastController,
    public viewCtrl: ViewController,
    public navParams: NavParams) {
    this.tmpl = navParams.data;
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

    this.smsData.getSmsConfigList().then(
      info => {
        let data: any = info;
        if (data.errcode == 0)
          this.suppliers = data.data;
        else
          this.showToast(data.errmsg);
      },
      err => this.showToast());
  }

  save() {
    if (!this.tmpl.template_id) {
      this.showToast('请输入模板ID/CODE');
      return;
    }
    if (!this.tmpl.template_name) {
      this.showToast('请输入模板名称');
      return;
    }
    if (!this.tmpl.config_id) {
      this.showToast('请选择短信配置');
      return;
    }
    if (!this.tmpl.template_content) {
      this.showToast('请输入模板内容');
      return;
    }
    this.smsData.saveSmsTemplate(this.tmpl).then(
      info => {
        let data: any = info;
        this.showToast(data.errmsg);
        if (data.errcode == 0) {
          this.viewCtrl.dismiss();
        }
      },
      err => this.showToast());
  }

  add() {
    if (this.tmpl.template_content) {
      let ps = this.tmpl.template_content.match(/\$?{.*?}/g);
      this.tmpl.param_desc_ids = ps.map(p => <SmsTemplateParam>{
        params_name: p.match(/\$?{(.*?)}/)[1],
        params_desc: '默认生成，请修改'
      });
    }
  }

  remove(p) {
    let index = this.tmpl.param_desc_ids.indexOf(p);
    this.tmpl.param_desc_ids.splice(index, 1);
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
