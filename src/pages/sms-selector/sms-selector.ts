import { Component } from '@angular/core';
import { NavController, NavParams, ViewController, ToastController, LoadingController } from 'ionic-angular';
import { Member, MemberData } from '../../providers/member-data';
import { Employee, EmployeeData } from '../../providers/employee-data';
import { SmsData } from '../../providers/sms-data';
import { SmsPage } from '../sms/sms';

@Component({
  selector: 'page-sms-selector',
  templateUrl: 'sms-selector.html'
})
export class SmsSelectorPage {
  people: {
    members?: Member[],
    employees?: Employee[]
  } = {};
  allMember = false;
  allEmployee = false;
  segment = 'member';
  type: string;
  title: string;
  mode: string;
  constructor(public navCtrl: NavController,
    public viewCtrl: ViewController,
    public employeeData: EmployeeData,
    public loadingCtrl: LoadingController,
    public memberData: MemberData,
    public smsData: SmsData,
    public toastCtrl: ToastController,
    public navParams: NavParams) {
    this.mode = navParams.data.mode;
    this.people = navParams.data.people;
  }

  ngAfterViewInit() {
    switch (this.mode) {
      case 'all':
        let loading = this.loadingCtrl.create({ spinner: 'bubbles' });
        loading.present();
        this.people = {};
        this.getAll().then(() => loading.dismiss());
        break;
    }
  }

  getAll() {
    return Promise.all([
      this.memberData.getAllMembers()
        .then(info => {
          let data: any = info;
          if (data.errcode == 0)
            this.people.members = data.data;
          else
            this.showToast(data.errmsg);
        },
        err => this.showToast()),
      this.employeeData.getAllEmployees()
        .then(info => {
          let data: any = info;
          if (data.errcode == 0)
            this.people.employees = data.data;
          else
            this.showToast(data.errmsg);
        },
        err => this.showToast())
    ])
  };

  selectAll(mode: string) {
    switch (mode) {
      case 'm':
        this.allMember = !this.allMember;
        break;
      case 'e':
        this.allEmployee = !this.allEmployee;
        break;
    }
  }

  selectChange(mode: string) {
    switch (mode) {
      case 'm':
        this.people.members.forEach(m => m.checked = this.allMember);
        break;
      case 'e':
        this.people.employees.forEach(m => m.checked = this.allEmployee);
        break;
    }
  }

  confirm() {
    let data: {
      members?: any[],
      employees?: any[],
      reminding_ids?: any[],
    } = {};
    data.members = [];
    data.employees = [];
    data.reminding_ids = [];
    if (this.people.members) {
      let mids = this.people.members.filter(m => m.checked);
      if (mids.length) {
        data.members = mids;
        mids.forEach(m => {
          if (m.rid)
            data.reminding_ids.push(m.rid);
        });
      }
    }
    if (this.people.employees) {
      let eids = this.people.employees.filter(e => e.checked);
      if (eids.length) {
        data.employees = eids;
        eids.forEach(e => {
          if (e.rid)
            data.reminding_ids.push(e.rid);
        });
      }
    }
    if (!(data.members.length + data.employees.length)) {
      this.showToast('请选择发送对象');
      return;
    }
    this.navCtrl.push(SmsPage, data);
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }

  dismiss() {
    this.viewCtrl.dismiss(false);
  }
}
