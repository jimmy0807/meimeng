import { Component } from '@angular/core';
import { NavController, NavParams, ToastController } from 'ionic-angular';
import { ReportData } from '../../providers/report-data';
// import {CommissionRuleDetailPage} from '../commission-rule-detail/commission-rule-detail';
import { ReportEquityPage } from '../report-equity/report-equity';
import { ReportIncomePage } from '../report-income/report-income';
import { ReportSalePage } from '../report-sale/report-sale';
import { ReportPctPage } from '../report-pct/report-pct';
import { ReportMemberNewPage } from '../report-member-new/report-member-new';
import { AppGlobal } from '../../app-global';

@Component({
  selector: 'page-report-index',
  templateUrl: 'report-index.html'
})
export class ReportIndexPage {

  eid = 0;
  reportIndex: {
    payment_count?: number,
    amount_complete_rate?: number,
    amount?: number,
    amount_status?: string,

    income_amount?: number,
    income_complete_rate?: number,
    income_amount_status?: string,

    sale_complete_rate?: number,
    sale_day_qty?: number,
    sale_order_qty?: number,
    sale_order_status?: string,

    new_complete_rate?: number,
    new_trial_qty?: number,
    new_qty?: number,
    new_qty_status?: string,

    per_order_guest_amount?: number,
    per_order_member_amount?: number,
    per_order_amount?: number,
    per_order_status ?: string,
  } = {};


  constructor(public navCtrl: NavController,
    public navParams: NavParams,
    private toastCtrl: ToastController,
    public reportData: ReportData) {
    if (AppGlobal.getInstance().user != undefined) {
      this.eid = AppGlobal.getInstance().user.eid;
    }
  }

  ngAfterViewInit() {
    this.getReportIndexDatas();
    console.log(AppGlobal.getInstance().user);
  }


  getReportIndexDatas() {
    this.reportData.getReportIndexDatas().then(
      info => {
        let data: any = info;
        if (data.errcode == 0 && data.data.report_index_datas.length === 1) {
          let obj = data.data.report_index_datas[0];

          this.reportIndex.sale_complete_rate = obj.sale_complete_rate;
          this.reportIndex.new_trial_qty = obj.new_trial_qty;
          this.reportIndex.new_complete_rate = obj.new_complete_rate;
          this.reportIndex.new_qty = obj.new_qty;
          this.reportIndex.sale_day_qty = obj.sale_day_qty;
          this.reportIndex.amount_complete_rate = obj.amount_complete_rate;
          this.reportIndex.income_amount = obj.income_amount;
          this.reportIndex.per_order_guest_amount = obj.per_order_guest_amount;
          this.reportIndex.per_order_member_amount = obj.per_order_member_amount;
          this.reportIndex.sale_order_qty = obj.sale_order_qty;
          this.reportIndex.income_complete_rate = obj.income_complete_rate;
          this.reportIndex.per_order_amount = obj.per_order_amount;
          this.reportIndex.amount = obj.amount;
          this.reportIndex.payment_count = obj.payment_count;
          this.reportIndex.income_amount_status = obj.income_amount_status;
          this.reportIndex.sale_order_status = obj.sale_order_status;
          this.reportIndex.new_qty_status = obj.new_qty_status;
          this.reportIndex.amount_status = obj.amount_status;
          this.reportIndex.per_order_status = obj.per_order_status;
          
        } else {
          this.showToastWithCloseButton(data.errmsg);
        }
      },
      err => {
        this.showToastWithCloseButton("系统繁忙")
      }
    )
  }
  report_detail(option) {
    switch (option) {
      case 'equity':
        this.navCtrl.push(ReportEquityPage);
        break;
      case 'income':
        this.navCtrl.push(ReportIncomePage);
        break;
      case 'sale':
        this.navCtrl.push(ReportSalePage);
        break;
      case 'member_new':
        this.navCtrl.push(ReportMemberNewPage);
        break;
      case 'pct':
        this.navCtrl.push(ReportPctPage);
        break;
      default:
        this.showToastWithCloseButton("未选择");
        break;
    }
  }
  showToastWithCloseButton(errcmsg) {
    const toast = this.toastCtrl.create({
      message: errcmsg,
      duration: 3000
    });
    toast.present();
  }

}
