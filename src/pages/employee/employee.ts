
import { Component } from '@angular/core';
import { NavController, ModalController, NavParams, ViewController } from 'ionic-angular';
import { EmployeeData } from '../../providers/employee-data';

@Component({
  selector: 'page-employee',
  templateUrl: 'employee.html'
})
export class EmployeePage {

  idleEmployees: any = [];
  busyEmployees: any = [];
  specialEmployees: any = [];
  constructor(
    public navCtrl: NavController,
    public navParams: NavParams,
    public viewCtrl: ViewController,
    public modalCtrl: ModalController,
    public employeeData: EmployeeData) {

    this.employeeData.load().then(
      info => {
        let data:any=info;
        if (data.errcode == 0) {
          let employees = data.data;
          employees.forEach(element => {
            if (element.special) {
              this.specialEmployees.push(element);
            }
            if (element.idle) {
              this.idleEmployees.push(element);
            } else {
              this.busyEmployees.push(element);
            }
          });
        }
      },
      error => {
      }
    )
  }

  dismiss() {
    this.viewCtrl.dismiss();
  }

  onSelectEmployee(employee) {
    this.viewCtrl.dismiss(employee);
  }
}
