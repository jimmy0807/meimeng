import { Component } from '@angular/core';
import { NavParams, NavController } from 'ionic-angular';

@Component({
  selector: 'page-commission-detail',
  templateUrl: 'commission-detail.html'
})
export class CommissionDetailPage {

  commission: any;

  constructor(
    public navParams: NavParams,
    public navCtrl: NavController,
  ) {
    this.commission = navParams.data;
  }
}
