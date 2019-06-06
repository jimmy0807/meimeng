import { Component } from '@angular/core';
import { NavController, NavParams, ViewController, ToastController, ModalController } from 'ionic-angular';
import { SmsData, SmsEntity, SmsTemplate } from '../../providers/sms-data';
import { SmsTemplateEditPage } from '../sms-template-edit/sms-template-edit';

@Component({
  selector: 'page-sms-template',
  templateUrl: 'sms-template.html'
})
export class SmsTemplatePage {
  title = "生日";
  tmpls: SmsTemplate[] = [];
  smsEntity: SmsEntity;
  constructor(public navCtrl: NavController,
    public smsData: SmsData,
    public modalCtrl: ModalController,
    public viewCtrl: ViewController,
    public toastCtrl: ToastController,
    public navParams: NavParams) {
    this.smsEntity = navParams.data;
  }

  ngAfterViewInit() {
    this.smsData.getSmsTemplateList(this.smsEntity.category_id).then(
      info => {
        let data: any = info;
        if (data.errcode == 0)
          this.tmpls = data.data;
        else
          this.showToast(data.errmsg);
      },
      err => this.showToast());
  }

  selected(item: SmsTemplate) {
    this.smsEntity.config_id = item.config_id;
    this.smsEntity.template = item;
    this.smsEntity.supplier = item.supplier;
    this.smsEntity.params = [];
    if (item.param_desc_ids.length) {
      let m = this.modalCtrl.create(SmsTemplateEditPage, this.smsEntity);
      m.onDidDismiss(data => {
        if (data)
          this.viewCtrl.dismiss();
      });
      m.present();
    }
    else {
      this.smsEntity.content = item.template_content;
      this.viewCtrl.dismiss(item);
    }
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
