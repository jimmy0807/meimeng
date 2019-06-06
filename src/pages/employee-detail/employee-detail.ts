import { Component } from '@angular/core';
import { NavController, NavParams, ModalController, ToastController, ViewController } from 'ionic-angular';
import { EmployeeData, Employee } from '../../providers/employee-data';
import { EmployeeSelectorPage } from '../employee-selector/employee-selector';

@Component({
  selector: 'page-employee-detail',
  templateUrl: 'employee-detail.html'
})
export class EmployeeDetailPage {
  list: Employee[];
  employee: Employee;
  jobs = [];
  departments = [];
  genders = [];
  roles = [];
  editMode = false;
  title = '';
  constructor(public navCtrl: NavController,
    public modalCtrl: ModalController,
    public employeeData: EmployeeData,
    public toastCtrl: ToastController,
    public viewCtrl: ViewController,
    public navParams: NavParams) {
    this.list = navParams.data.list;
    this.employee = navParams.data.employee;
    this.editMode = this.employee.id > 0;
    this.title = this.editMode ? '编辑员工' : '新建员工';
  }

  ngAfterViewInit() {
    this.employeeData.getJobs().then(
      (newData) => {
        let data: any = newData;
        if (data.errcode === 0) {
          this.jobs = data.data;
        }
      });
    this.employeeData.getDepartments().then(
      (newData) => {
        let data: any = newData;
        if (data.errcode === 0) {
          this.departments = data.data;
        }
      });
    this.genders = [
      { id: 'male', name: '男' },
      { id: 'female', name: '女' },
      { id: 'other', name: '其他' },
    ];
    this.roles = [
      { id: '1', name: '公司管理员' },
      { id: '2', name: '公司运维' },
      { id: '3', name: '门店管理员' },
      { id: '4', name: '收银员' },
      { id: '5', name: '普通用户' },
    ];
  }

  selectShop() {
    let m = this.modalCtrl.create(EmployeeSelectorPage, { mode: 'shop' });
    m.onDidDismiss(data => {
      if (data) {
        this.employee.shop_id = data.id;
        this.employee.shop_name = data.name;
      }
    });
    m.present();
  }

  selectPosConfig() {
    let m = this.modalCtrl.create(EmployeeSelectorPage, { mode: 'posconfig' });
    m.onDidDismiss(data => {
      if (data) {
        this.employee.pos_config_id = data.id;
        this.employee.pos_config_name = data.name;
      }
    });
    m.present();
  }

  save() {
    if (!(this.employee.name)) {
      this.showToast("请输入姓名");
      return;
    }
    if (!(this.employee.mobile_phone)) {
      this.showToast("请输入手机");
      return;
    }
    if (!/^1\d{10}$/.test(this.employee.mobile_phone)) {
      this.showToast("请输入正确的手机");
      return;
    }
    if (this.employee.is_login) {
      if (!(this.employee.role_option)) {
        this.showToast("请选择角色");
        return;
      }
      if (!(this.employee.password)) {
        this.showToast("请输入密码");
        return;
      }
    }

    this.employeeData.saveEmployee(this.employee).then(
      info => {
        var data: any = info;
        if (data.errcode == 0) {
          this.employee.id = data.data.id;
          if (!this.editMode) {
            this.list.unshift(this.employee);
          }
          this.dismiss();
        }
        this.showToast(data.errmsg);
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

  dismiss() {
    this.viewCtrl.dismiss();
  }
}
