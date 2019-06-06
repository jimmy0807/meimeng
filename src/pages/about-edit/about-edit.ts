import { Component, ViewChild } from '@angular/core';
import { NavController, NavParams, ToastController, ViewController, TextInput } from 'ionic-angular';
import { Employee, EmployeeData } from '../../providers/employee-data';

@Component({
  selector: 'page-about-edit',
  templateUrl: 'about-edit.html'
})
export class AboutEditPage {
  @ViewChild('input') input: TextInput;
  employee: Employee;
  key: string;
  value: any;
  title: string;
  constructor(public navCtrl: NavController,
    public toastCtrl: ToastController,
    public viewCtrl: ViewController,
    public employeeData: EmployeeData,
    public navParams: NavParams) {
    this.employee = navParams.data.employee;
    this.key = navParams.data.key;
    this.value = navParams.data.value;
    switch (this.key) {
      case 'name': this.title = '姓名'; break;
      case 'mobile_phone': this.title = '电话'; break;
      case 'gender': this.title = '性别'; break;
      case 'birthday': this.title = '生日'; break;
      case 'work_email': this.title = '邮箱'; break;
    }
  }
  ngAfterViewInit() {
    //if (this.input)
    //  this.input.setFocus();
  }

  save() {
    this.employeeData.saveEmployeeProp(this.employee.id, this.key, this.value).then(
      info => {
        var data: any = info;
        this.showToast(data.errmsg);
        if (data.errcode == 0) {
          this.employee[this.key] = this.value;
          this.viewCtrl.dismiss();
        }
      },
      err => {
        this.showToast();
      }
    );
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
