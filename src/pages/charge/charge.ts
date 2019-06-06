import {Component} from '@angular/core';
import {IonicPage, NavController, NavParams} from 'ionic-angular';
import {ChargeData} from '../../providers/charge-data';

@IonicPage()
@Component({
  selector: 'page-charge',
  templateUrl: 'charge.html',
})
export class ChargePage {
  types = [0.01, 5000, 10000, 15000, 20000, 25000];
  remain = 0;

  constructor(public navCtrl: NavController,
              public chargeData: ChargeData,
              public navParams: NavParams) {
  }

  async ionViewDidEnter() {
    let r = await this.chargeData.getFeeRemain();
    if (r.errcode == 0) {
      this.remain = r.data.remain;
    }
  }

  log() {
    this.navCtrl.push('ChargeLogPage');
  }

  pay(t) {
    this.navCtrl.push('ChargePayPage', t);
  }
}
