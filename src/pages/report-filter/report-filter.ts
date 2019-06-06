import { Component } from '@angular/core';
import { NavController, NavParams, ViewController } from 'ionic-angular';

@Component({
  selector: 'page-report-filter',
  templateUrl: 'report-filter.html'
})
export class ReportFilterPage {
  option: any;
  date_start: any;
  date_end: any;
  date_max: any;
  constructor(public navCtrl: NavController,
    public viewCtrl: ViewController,
    public navParams: NavParams) {
      console.log(navParams)
      this.date_start = navParams.data[0];
      this.date_end = navParams.data[1];
      var now = new Date();
      this.date_max = this.formatDate(now);
  }

  ngAfterViewInit() {
    console.log('ngAfterViewInit ReportFilterPage');
    // var now = new Date();
    // this.date_max = this.formatDate(now);
    // // this.date_start = now.getFullYear() + '-' + (now.getMonth() + 1) + '-' + now.getDay();
    // this.date_end = this.formatDate(now);
    // // var d= new Date(now.getFullYear(), now.getMonth()+1, 0); 
    // now.setDate(now.getDate() - 30);
    // this.date_start = this.formatDate(now);
  }
  check_date() {
    // console.log(this.date_end);
    if (this.date_end < this.date_start)
      this.date_start = this.date_end;
  }
  cancel() {
    this.viewCtrl.dismiss();
  }
  complete() {
    console.log(this.date_start);
    console.log(this.date_end);
    this.viewCtrl.dismiss([this.date_start, this.date_end]);
  }
  formatDate(d: Date) {
    var D = ['00', '01', '02', '03', '04', '05', '06', '07', '08', '09']
    return [d.getFullYear(), D[d.getMonth() + 1] || d.getMonth() + 1, D[d.getDate()] || d.getDate()].join('-');
  }
}
