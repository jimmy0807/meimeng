import { Component } from '@angular/core';
import { NavController, NavParams } from 'ionic-angular';

import { AboutEditPage } from '../about-edit/about-edit';
import { AboutImagePage } from '../about-image/about-image';
import { EmployeeInfo } from '../../providers/employee-data';

@Component({
  selector: 'page-about-detail',
  templateUrl: 'about-detail.html'
})
export class AboutDetailPage {
  employee: EmployeeInfo = {};

  constructor(public navCtrl: NavController,
    public navParams: NavParams) {
    this.employee = navParams.data;
  }

  ionViewDidLoad() {
  }

  edit(key: string) {
    // 'image':'name''mobile_phone''gender''birthday''work_email'
    switch (key) {
      case 'image':
        this.navCtrl.push(AboutImagePage, {
          employee: this.employee,
          key: key,
          value: this.employee.image_url
        });
        break;
      default:
        this.navCtrl.push(AboutEditPage, {
          employee: this.employee,
          key: key,
          value: this.employee[key]
        });
    }
  }
}
