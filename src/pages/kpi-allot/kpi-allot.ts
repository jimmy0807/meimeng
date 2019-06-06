import { Component } from '@angular/core';
import { NavController, ToastController, ViewController, NavParams } from 'ionic-angular';
import { KpiData } from '../../providers/kpi-data';

@Component({
  selector: 'page-kpi-allot',
  templateUrl: 'kpi-allot.html'
})
export class KpiAllotPage {

  kpi_type = 'commission';
  currentDate: {
    month?: string,
    year?: number,
  } = {};
  employee: {
    name?: string,
    id?: number,
  } = {};

  id: number = 0;
  royalties: number = 1000;
  spending: number = 1000;
  operate: number = 10;
  new_card: number = 5;
  customer: number = 5;

  constructor(
    public navParams: NavParams,
    public kpiData: KpiData,
    public viewCtrl: ViewController,
    private toastCtrl: ToastController,
    public navCtrl: NavController) {
    if (navParams.data) {
      this.employee = navParams.data.employee;
      this.currentDate = navParams.data.currentDate;
    }
  }

  ngAfterViewInit() {
    this.getEmployeeKpi();
  }

  getEmployeeKpi() {
    let param = {
      'month': this.currentDate.month,
      'year': this.currentDate.year,
      'eid': this.employee.id,
    }
    this.kpiData.getEmployeeKpi(param).then(
      info => {
        let data: any = info;
        if (data.errcode === 0) {
          this.id = data.data.id;
          this.royalties = data.data.royalties;
          this.spending = data.data.spending;
          this.operate = data.data.operate;
          this.new_card = data.data.new_card;
          this.customer = data.data.customer;
          this.kpi_type = data.data.kpi_type;
        }
      },
      error => {
      }
    )
  }

  showToastWithCloseButton(errcmsg) {
    const toast = this.toastCtrl.create({
      message: errcmsg,
      duration: 3000
    });
    toast.present();
  }

  dismiss() {
    this.viewCtrl.dismiss();
  }

  updateEmployeeKpi() {
    let param = {
      'month': this.currentDate.month,
      'year': this.currentDate.year,
      'eid': this.employee.id,
      'kid': this.id,
      'royalties': this.royalties,
      'spending': this.spending,
      'operate': this.operate,
      'new_card': this.new_card,
      'customer': this.customer,
      'kpi_type': this.kpi_type,
    };
    this.kpiData.updateEmployeeKpi(param).then(
      info => {
        let data: any = info;
        if (data.errcode === 0) {
          this.id = data.id;
          this.viewCtrl.dismiss(this.currentDate);
        }
        this.showToastWithCloseButton(data.errmsg);
      },
      error => {
      }
    )
  }
}
