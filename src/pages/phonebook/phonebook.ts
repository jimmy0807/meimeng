import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ToastController, LoadingController } from 'ionic-angular';
import { EmployeeData, Employee } from '../../providers/employee-data';
import { CallNumber } from '@ionic-native/call-number';

@IonicPage()
@Component({
  selector: 'page-phonebook',
  templateUrl: 'phonebook.html',
})
export class PhonebookPage {
  listBak: Employee[] = [];
  list: Employee[] = [];
  keyword = '';
  constructor(public navCtrl: NavController,
    public toastCtrl: ToastController,
    private callNumber: CallNumber,
    public loadingCtrl: LoadingController,
    public employeeData: EmployeeData,
    public navParams: NavParams) {
  }

  async ngAfterViewInit() {
    let loader = this.loadingCtrl.create({ spinner: 'bubbles' });
    loader.present();
    try {
      let r = await this.employeeData.getAllEmployees([
        'designers',
        'director',
        'adviser',
        'operater',
        'regional_manager',
        'manager',
        'other',
      ]);
      if (r.errcode === 0)
        this.list = this.listBak = r.data;
    } catch (e) {

    }
    finally {
      loader.dismiss();
    }
  }

  onInput(ev) {
    if (this.keyword) {
      let k = this.keyword;
      this.list = this.listBak.filter(e => e.name.includes(k) || e.mobile_phone.includes(k));
    }
    else {
      this.list = this.listBak;
    }
  }

  onCancel(ev) {
    this.keyword = '';
  }

  call(no) {
    this.callNumber.callNumber(no, true)
      .catch((r) => this.showToast(r));
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
