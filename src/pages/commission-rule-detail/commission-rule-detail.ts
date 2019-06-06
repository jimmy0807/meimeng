import {Component} from '@angular/core';
import {NavController, NavParams, ViewController, ToastController} from 'ionic-angular';
import {CommissionRuleData} from '../../providers/commission-rule-data';

@Component({
  selector: 'page-commission-rule-detail',
  templateUrl: 'commission-rule-detail.html'
})
export class CommissionRuleDetailPage {

  isSubmit: boolean = false;
  model = 'add';

  commissionRule: {
    id?: number,
    name?: string,
    sale_price_sel?: string,
    sale_price_sel_display?: string,
    is_total_special?: boolean,
    fix_named?: number,
    percent_named?: number,
    fix_percent?: number,
    active?: boolean,
    total_special?: number,
    title_display?: string,

  } = {};


  constructor(public navCtrl: NavController,
              public viewCtrl: ViewController,
              private toastCtrl: ToastController,
              public commissionRuleData: CommissionRuleData,
              public navParams: NavParams) {

    this.commissionRule.title_display = '新增';
    this.commissionRule.name = '';
    this.commissionRule.id = 0;

    if (navParams.data != undefined && navParams.data.id != undefined) {
      this.commissionRule = navParams.data;
      this.commissionRule.title_display = this.commissionRule.name;
      this.model = 'edit';
    } else {
      this.commissionRule.sale_price_sel = 'sale_price';
      this.commissionRule.sale_price_sel_display = '根据成交价';
      this.commissionRule.is_total_special = false;
      this.commissionRule.fix_named = 0.0;
      this.commissionRule.percent_named = 0.0;
      this.commissionRule.fix_percent = 0.0;
      this.commissionRule.active = true;
      this.commissionRule.total_special = 0.0;
      this.model = 'add';
    }
  }

  showToastWithCloseButton(errcmsg) {
    const toast = this.toastCtrl.create({
      message: errcmsg,
      duration: 3000
    });
    toast.present();
  }

  save() {
    if (this.isSubmit) {
      return;
    }
    if (this.commissionRule.name === undefined) {
      this.showToastWithCloseButton('请输入提成方案名称');
      return;
    }
    this.isSubmit = true;

    this.commissionRuleData.saveCommissionRule(this.commissionRule).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {

          this.commissionRule.id = data.data.id;
          this.commissionRule.title_display = this.commissionRule.name;
          this.model = 'edit';
          this.showToastWithCloseButton(data.errmsg);
          this.viewCtrl.dismiss(data.data);
          this.isSubmit = false;
        } else {
          this.showToastWithCloseButton(data.errmsg);
          this.isSubmit = false;
        }
      },
      err => {
        this.showToastWithCloseButton("系统繁忙")
      }
    )
  }

  update() {
    this.commissionRuleData.updateCommissionRule(this.commissionRule).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.commissionRule = data.data;
          this.model = 'edit';
          this.showToastWithCloseButton(data.errmsg);
          this.viewCtrl.dismiss(data.data);
        } else {
          this.showToastWithCloseButton(data.errmsg);
          this.isSubmit = false;
        }
      },
    )
  }

  dismiss() {
    this.viewCtrl.dismiss();
  }

}
