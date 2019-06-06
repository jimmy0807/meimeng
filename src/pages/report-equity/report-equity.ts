import { Component, ViewChild } from '@angular/core';
import { NavController, NavParams, ToastController, ModalController } from 'ionic-angular';
import { ReportFilterPage } from '../report-filter/report-filter';
import { ReportData } from '../../providers/report-data';
import { ChartModule } from 'ng2-chartjs2';

@Component({
  selector: 'page-report-equity',
  templateUrl: 'report-equity.html'
})
export class ReportEquityPage {
  @ViewChild('chart') nchart: ChartModule;
  @ViewChild('chart_pct_member') nchart_pct_member: ChartModule;
  segment = 'month';
  start = '';
  end = '';
  report_data: {
    equity_all?: number,
    equity_all_last?: number,
    equity_last_percent?: string,
    equity_all_goal?: number,
    equity_goal_percent?: string,
    equity_recharge ?: number,
    // equity_new_commission?: number,
    // equity_course?: number,
    // equity_item?: number,
    equity_sale?: number,
    equity_repayment?: number,
    equity_arrear?: number,
    equity_refund?: number,
    pay_way ?: any,
  } = {};
  flag_left = false;
  flag_right = false;
  chart_data_equity = [];
  options: any = {
    type: 'bar',
    data: {
      labels: [
        "充值/开卡",
        // "",
        "销售额",
        "还款"
      ],
      datasets: [
        {
          data: this.chart_data_equity,
          backgroundColor: [
            "#5A72DB",
            "#3B87EE",
            "#28E5F0",
            // "#28E5F0"
          ],
          hoverBackgroundColor: [
            "#5A72DB",
            "#3B87EE",
            "#28E5F0",
            // "#28E5F0"
          ],
        }]
    },
    options:
    {
      cutoutPercentage: 70,
      legend: {
        display: false
      }
    }

  };
  constructor(public navCtrl: NavController,
    public navParams: NavParams,
    public modalCtrl: ModalController,
    private toastCtrl: ToastController,
    public reprotdata: ReportData) { }

  ngAfterViewInit() {
    console.log('ngAfterViewInit ReportEquityPage');
    this.select_timezone(this.segment);
  }
  select_timezone(time) {
    
    if (time instanceof Array) {
      this.start = time[0];
      this.end = time[1];
    }
    else {
      let date = new Date();
      switch (time) {
        case 'today': this.start = this.formatDate(date); this.end = this.formatDate(date); break;
        case 'yesterday': date.setDate(date.getDate() - 1); this.start = this.formatDate(date); this.end = this.formatDate(date); break;
        case 'week': this.end = this.formatDate(date); date.setDate(date.getDate() - 6); this.start = this.formatDate(date); break;
        case 'month': this.end = this.formatDate(date); this.start = this.formatDate(new Date(date.getFullYear(), date.getMonth(), 1)); break;
      }
    }

    this.reprotdata.getEquityData(this.start, this.end).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.report_data = data.data[0];
          console.log(this.report_data);
          if (this.report_data.equity_last_percent != "0.00") {
            this.flag_left = true;
          }
          else
            this.flag_left = false;
          if (this.report_data.equity_goal_percent != "0.00") {
            this.flag_right = true;
          }
          else
            this.flag_right = false;
          this.options.data.datasets[0].data = [
            this.report_data.equity_recharge,
            // this.report_data.equity_new_commission,
            this.report_data.equity_sale,
            // this.report_data.equity_item,
            this.report_data.equity_repayment,
          ];
          let d: any = this.nchart;
          let dx = d.chart;
          dx.update();
        }
        else {
          this.showToastWithCloseButton(data.errmsg);
        }
      },
      err => {
        this.showToastWithCloseButton("系统繁忙");
      }
    );
  }

  filter() {
    let modal = this.modalCtrl.create(ReportFilterPage,[this.start, this.end]);
    modal.onDidDismiss(data => {
      if (data != undefined) {
        console.log(data);
        this.segment = "";
        this.select_timezone([data[0], data[1]]);
      }
      else {
      }
    });
    modal.present();
  }
  formatDate(d: Date) {
    var D = ['00', '01', '02', '03', '04', '05', '06', '07', '08', '09']
    return [d.getFullYear(), D[d.getMonth() + 1] || d.getMonth() + 1, D[d.getDate()] || d.getDate()].join('-');
  }
  showToastWithCloseButton(errcmsg) {
    const toast = this.toastCtrl.create({
      message: errcmsg,
      duration: 3000
    });
    toast.present();
  }
}
