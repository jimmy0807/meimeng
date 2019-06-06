import { Component } from '@angular/core';
import { NavController, NavParams } from 'ionic-angular';
import { Sms } from '../../providers/sms-data';

@Component({
  selector: 'page-sms-detail',
  templateUrl: 'sms-detail.html'
})
export class SmsDetailPage {
  sms: Sms = {};
  count;
  names;
  constructor(public navCtrl: NavController,
    public navParams: NavParams) {
    this.sms = navParams.data;

    let num = this.sms.member_ids.concat(this.sms.employee_ids);
    this.count = num.length;
    this.names = num.join('; ');
  }
}
