import { Component, ViewChild } from '@angular/core';
import { NavController, NavParams, ToastController, ModalController } from 'ionic-angular';
import { ReportFilterPage } from '../report-filter/report-filter';
import { ReportData } from '../../providers/report-data';
import { ChartModule } from 'ng2-chartjs2';

@Component({
  selector: 'page-report-pct',
  templateUrl: 'report-pct.html'
})
export class ReportPctPage {
  @ViewChild('chart') nchart: ChartModule;
  @ViewChild('chart_pct_member') nchart_pct_member: ChartModule;
  segment = 'month';
  start = '';
  end = '';
  report_data: {
    pct_all?: number,
    pct_all_last?: number,
    pct_item?: number,
    pct_item_last?: number,
    pct_product?: number,
    pct_member?: number,
    pct_temp?: number,
    pct_item_percent?: string,
    pct_all_percent?: string,
  } = {};
  flag_left = false;
  flag_right = false;
  chart_data_pct = [];
  options: any = {
    type: 'doughnut',
    data: {
      labels: [
        "护理客单价",
        "产品客单价",
      ],
      datasets: [
        {
          data: this.chart_data_pct,
          backgroundColor: [
            "#28BAF0",
            "#28E5F0"
          ],
          hoverBackgroundColor: [
            "#28BAF0",
            "#28E5F0"
          ],
          // borderWidth : [20, 20],
          // hoverBorderWidth : [20, 20]
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
    console.log('ngAfterViewInit ReportPctPage');
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
    this.reprotdata.getPctData(this.start, this.end).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.report_data = data.data[0];
          console.log(this.report_data);
          if (this.report_data.pct_all_percent != "0.00") {
            this.flag_left = true;
          }
          else
            this.flag_left = false;
          if (this.report_data.pct_item_percent != "0.00") {
            this.flag_right = true;
          }
          else
            this.flag_right = false;
          this.options.data.datasets[0].data = [this.report_data.pct_item, this.report_data.pct_product];
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
