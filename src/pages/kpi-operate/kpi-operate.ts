import { Component } from '@angular/core';
import { NavController, NavParams } from 'ionic-angular';
import { KpiData } from '../../providers/kpi-data';

@Component({
  selector: 'page-kpi-operate',
  templateUrl: 'kpi-operate.html'
})

export class KpiOperatePage {
  kpi: any;
  operates = [];
  constructor(
    public navParams: NavParams,
    public navCtrl: NavController,
    public kpiData: KpiData) {
    if (navParams.data) {
      this.kpi = navParams.data;
    }
  }

  ngAfterViewInit() {
    this.getKpiOperates();
  }

  getKpiOperates() {
    let param = {
      'kid': this.kpi.id
    }
    this.kpiData.getKpiOperates(param).then(
      info => {
        let result: any = info;
        if (result.errcode === 0) {
          this.operates = result.data;
        }
      });
  }
}
