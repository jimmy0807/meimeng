import { Component } from '@angular/core';
import { NavController, NavParams } from 'ionic-angular';

@Component({
  selector: 'page-about-permission',
  templateUrl: 'about-permission.html'
})
export class AboutPermissionPage {
  user;
  constructor(public navCtrl: NavController,
    public navParams: NavParams) {
    this.user = navParams.data;
  }

  ionViewDidLoad() {
  }
}
