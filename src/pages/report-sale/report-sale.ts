import { Component } from '@angular/core';
import { NavController, NavParams, ToastController, ModalController } from 'ionic-angular';
import { ReportFilterPage } from '../report-filter/report-filter';
import { ReportData } from '../../providers/report-data';

@Component({
  selector: 'page-report-sale',
  templateUrl: 'report-sale.html'
})
export class ReportSalePage {
  segment = 'month';
  start = '';
  end = '';
  report_data: {
    sale_all?: number,
    sale_all_year_last?: number,
    sale_complete_rate?: string,
    sale_year_last_rate?:string,
    sale_all_goal?: number,
    sale_per_day?: number,
  } = {};
  flag_left = false;
  flag_right = false;
  constructor(public navCtrl: NavController,
    public navParams: NavParams,
    public modalCtrl: ModalController,
    private toastCtrl: ToastController,
    public reprotdata: ReportData) { }

  ngAfterViewInit() {
    console.log('ngAfterViewInit ReportSalePage');
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
    this.reprotdata.getSaleData(this.start, this.end).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.report_data = data.data[0];
          console.log(this.report_data);
          if (this.report_data.sale_year_last_rate != "0.00") {
            this.flag_left = true;
          }
          else
            this.flag_left = false;
          if (this.report_data.sale_complete_rate != "0.00") {
            this.flag_right = true;
          }
          else
            this.flag_right = false;
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

