import { Component } from '@angular/core';
import { NavController, NavParams, ModalController, ToastController, ViewController } from 'ionic-angular';
import { EmployeeData, Employee } from "../../providers/employee-data";

@Component({
  selector: 'page-member-filter',
  templateUrl: 'member-filter.html'
})
export class MemberFilterPage {
  employees: Employee[];
  memberFilterOptions: {
    birthday_month?: string,
    employee_id?: number,
    un_consume_day?: number,
    consume_day?: number,
    max_amount?: number,
    min_amount?: number,
    max_recharge_amount?: number,
    min_recharge_amount?: number,
    max_consumption_amount?: number,
    min_consumption_amount?: number,
  } = {};

  constructor(public navCtrl: NavController,
    public modalCtrl: ModalController,
    public employeeData: EmployeeData,
    public navParams: NavParams,
    public viewCtrl: ViewController,
    public toastCtrl: ToastController) {
    this.memberFilterOptions = navParams.data;
    this.getEmployeeList();
  }

  getEmployeeList() {
    this.employeeData.load().then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.employees = data.data;
        }
        else {
          this.showToast(data.errmsg);
        }
      },
      err => {
        this.showToast();
      }
    )
  }

  dismiss() {
    this.viewCtrl.dismiss();
  }

  onConfirm() {
    this.viewCtrl.dismiss(this.memberFilterOptions);
  }

  onCancel() {
    this.memberFilterOptions = {};
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
