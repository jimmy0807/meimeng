import { Component } from '@angular/core';
import { NavController, NavParams, Refresher, InfiniteScroll, LoadingController, ToastController } from 'ionic-angular';
import { MedicalData, Customer } from '../../providers/medical-data';
import { MedicalCustomerDetailPage } from '../medical-customer-detail/medical-customer-detail';

@Component({
  selector: 'page-medical-customer',
  templateUrl: 'medical-customer.html'
})
export class MedicalCustomerPage {
  c: Customer;
  keyword = '';
  list: Customer[] = [];
  infiniteEnabled = true;
  constructor(public navCtrl: NavController,
    public loadingCtrl: LoadingController,
    public toastCtrl: ToastController,
    public medicalData: MedicalData,
    public navParams: NavParams) { }

  async ngAfterViewInit() {
    let loader = this.loadingCtrl.create({ spinner: 'bubbles' });
    loader.present();
    try {
      await this.getItems();
    }
    finally {
      loader.dismiss();
    }
  }

  async getItems(offset = 0, append = false) {
    try {
      let r = await this.medicalData.getMedicalCustomers(offset, this.keyword);
      if (r.errcode === 0) {
        let arr = <any[]>r.data;
        this.infiniteEnabled = arr.length === 20;
        if (append) {
          for (var i = 0; i < arr.length; i++) {
            this.list.push(arr[i]);
          }
        }
        else {
          this.list = r.data;
        }
      }
      else {
        this.showToast(r.errmsg);
      }
    } catch (e) {
      this.showToast();
    }
  }

  async doRefresh(refresher: Refresher) {
    try {
      await this.getItems(0);
    }
    finally {
      refresher.complete();
    }
  }

  async onInput(ev) {
    await this.getItems(0);
  }

  onCancel(ev) {
    this.keyword = '';
  }

  async doInfinite(infiniteScroll: InfiniteScroll) {
    try {
      await this.getItems(this.list.length, true);
    }
    finally {
      infiniteScroll.complete();
    }
  }

  edit(i: Customer) {
    this.navCtrl.push(MedicalCustomerDetailPage, { list: this.list, c: i });
  }

  add() {
    this.navCtrl.push(MedicalCustomerDetailPage, { list: this.list, c: {} });
  }

  async delete(i: Customer) {
    let r = await this.medicalData.deleteMedicalCustomer(i.id);
    this.showToast(r.errmsg);
    if (r.errcode === 0) {
      let index = this.list.indexOf(i);
      this.list.splice(index, 1);
    }
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
