import { Component } from '@angular/core';
import { NavController, NavParams } from 'ionic-angular';

import { AboutConfigPage } from '../about-config/about-config';
import { AboutDetailPage } from '../about-detail/about-detail';
import { AboutPermissionPage } from '../about-permission/about-permission';
import { EmployeeInfo, EmployeeData } from '../../providers/employee-data';
import { LoadingController } from 'ionic-angular';

@Component({
  selector: 'page-about',
  templateUrl: 'about.html'
})

export class AboutPage {

  employee: EmployeeInfo = {};
  user = {};
  constructor(
    public navCtrl: NavController,
    public loadingCtrl: LoadingController,
    public navParam: NavParams,
    public employeeData: EmployeeData) {
    this.employee.amount_total = 0;
  }

  ngAfterViewInit() {
    let loader = this.loadingCtrl.create({
      spinner: 'bubbles',
    });
    loader.present();
    this.employeeData.getEmployee().then(
      (newData) => {
        let data: any = newData;
        if (data.errcode == 0) {
          this.employee = data.data;
          this.user = this.employee.user_info;
        }
      }).then(s => loader.dismiss()).catch(err => loader.dismiss());
  }

  onSetting() {
    this.navCtrl.push(AboutConfigPage, this.employee);
  }

  detail() {
    if (this.employee.id)
      this.navCtrl.push(AboutDetailPage, this.employee);
  }

  permission() {
    this.navCtrl.push(AboutPermissionPage, this.employee.user_info);
  }

  phone() {
    this.navCtrl.push('PhonebookPage');
  }
}
