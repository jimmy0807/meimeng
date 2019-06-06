import { Component, ViewChild } from '@angular/core';
import { NavController, NavParams, ToastController, ModalController } from 'ionic-angular';
import { ReportFilterPage } from '../report-filter/report-filter';
import { ReportData } from '../../providers/report-data';
import { ChartModule } from 'ng2-chartjs2';

@Component({
  selector: 'page-report-member-new',
  templateUrl: 'report-member-new.html'
})
export class ReportMemberNewPage {
  @ViewChild('chart') nchart: ChartModule;
  @ViewChild('chart_pct_member') nchart_pct_member: ChartModule;
  segment = 'month';
  start = '';
  end = '';
  report_data: {
    member_all?: number,
    member_active?: number,
    member_sleep?: number,
    member_new?: number,
    member_new_last?: number,
    member_new_percent?: string,
    member_new_goal?: number,
    member_new_goal_percent?: string,
    member_temp?: number,
    member_come?: number,
  } = {};
  flag_left = false;
  flag_right = false;
  chart_data_member_new = [];
  options: any = {
    type: 'doughnut',
    data: {
      labels: [
        "有效会员",
        "沉睡会员",
      ],
      datasets: [
        {
          data: this.chart_data_member_new,
          backgroundColor: [
            "#28BAF0",
            "#28E5F0"
          ],
          hoverBackgroundColor: [
            "#28BAF0",
            "#28E5F0"
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
    console.log('ionViewDidLoad ReportMemberNewPage');
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
    this.reprotdata.getMemberNewData(this.start, this.end).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.report_data = data.data[0];
          console.log(this.report_data);
          if (this.report_data.member_new_last != 0) {
            this.report_data.member_new_percent = (this.report_data.member_new / this.report_data.member_new_last * 100).toFixed(2);
            this.flag_left = true;
          }
          else
            this.flag_left = false;
          if (this.report_data.member_new_goal != 0) {
            this.report_data.member_new_goal_percent = (this.report_data.member_new / this.report_data.member_new_goal * 100).toFixed(2);
            this.flag_right = true;
          }
          else
            this.flag_right = false;
          this.options.data.datasets[0].data = [this.report_data.member_active, this.report_data.member_sleep];
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
