import { Component } from '@angular/core';
import { NavController, NavParams, ViewController } from 'ionic-angular';
@Component({
  selector: 'page-member-card-line',
  templateUrl: 'member-card-line.html'
})
export class MemberCardLinePage {
  prd;
  year;
  constructor(public navCtrl: NavController,
    public viewCtrl: ViewController,
    public navParams: NavParams) {
    this.prd = navParams.data;
    this.year = new Date().getFullYear() + 10;
  }

  save() {
    this.viewCtrl.dismiss();
  }

  dismiss() {
    this.viewCtrl.dismiss();
  }
}
