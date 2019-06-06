
import { Component } from '@angular/core';
import { NavController, NavParams, ModalController, ViewController } from 'ionic-angular';

import { EmployeeData } from '../../providers/employee-data';
import { KpiAllotPage } from '../kpi-allot/kpi-allot';
@Component({
  selector: 'page-follow-employee',
  templateUrl: 'follow-employee.html'
})
export class FollowEmployeePage {

  employees: any = [];
  currentDate:any;
  constructor(
    public navParams: NavParams,
    public navCtrl: NavController,
    public viewCtrl: ViewController,
    public modalCtrl: ModalController,
    public employeeData: EmployeeData) {
    if (navParams.data) {
      this.currentDate = navParams.data;
    }

    if (this.currentDate) {
      this.employeeData.loadFollowEmployee(this.currentDate).then(
        info => {
          let data: any = info;
          if (data.errcode == 0) {
            this.employees = data.data;
          }
        },
        error => {
        }
      )
    }
  }

  dismiss() {
    this.viewCtrl.dismiss();
  }
  onSelectEmployee(employee) {
    let param = { 'currentDate': this.currentDate, 'employee': employee };
    let modal = this.modalCtrl.create(KpiAllotPage, param);
    modal.onDidDismiss(data => {
      if(data!=undefined){
        this.viewCtrl.dismiss(data);
      }
    });
    modal.present();
  }
}
