import { Component } from '@angular/core';
import { NavController, NavParams } from 'ionic-angular';
import { RevenueData } from '../../providers/revenue-data';

@Component({
  selector: 'page-revenue-operate',
  templateUrl: 'revenue-operate.html'
})
export class RevenueOperatePage {

  param: any;
  operates = [];
  constructor(
    public navParams: NavParams,
    public navCtrl: NavController,
    public revenueData: RevenueData) {
    if (navParams.data) {
      this.param = navParams.data;
    }
  }

  ngAfterViewInit() {
    this.getKpiOperates();
  }

  getKpiOperates() {

    this.revenueData.getRevenueOperates(this.param).then(
      info => {
        let result: any = info;
        if (result.errcode === 0) {
          this.operates = result.data;
        }
      });
  }
}
