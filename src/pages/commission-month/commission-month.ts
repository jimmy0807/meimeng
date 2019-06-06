import { Component } from '@angular/core';
import { NavParams, NavController } from 'ionic-angular';
import { CommissionDetailPage } from '../commission-detail/commission-detail';
import { CommissionData } from '../../providers/commission-data';
import { LoadingController } from 'ionic-angular';

@Component({
  selector: 'page-commission-month',
  templateUrl: 'commission-month.html'
})
export class CommissionMonthPage {

  commission: any;
  commissionDays = [];

  constructor(public navParams: NavParams,
    public navCtrl: NavController,
    public loadingCtrl: LoadingController,
    public commissionData: CommissionData) {
    this.commission = navParams.data;
  }

  ngAfterViewInit() {
    let loader = this.loadingCtrl.create({
      spinner: 'bubbles',
    });
    loader.present();
    this.loadCommissionDays().then(s => loader.dismiss()).catch(err => loader.dismiss());
  }

  loadCommissionDays() {
    return this.commissionData.getCommissionMonthDetail(this.commission.id).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.commissionDays = data.data;
        } else {
          alert(data.errmsg)
        }
      },
      error => {
        alert(error)
      }
    )
  }

  goDetail(commission) {
    this.navCtrl.push(CommissionDetailPage, commission);
  }
}
