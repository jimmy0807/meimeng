import { Component } from '@angular/core';
import { NavController, InfiniteScroll, ToastController } from 'ionic-angular';

import { CommissionDetailPage } from '../commission-detail/commission-detail';
import { CommissionMonthPage } from '../commission-month/commission-month';
import { CommissionData } from '../../providers/commission-data';
import { LoadingController } from 'ionic-angular';

@Component({
  selector: 'page-commission',
  templateUrl: 'commission.html'
})

export class CommissionPage {
  segment = 'day';

  commissionDays: any = [];
  commissionMonths: any = [];

  constructor(public navCtrl: NavController,
    public toastCtrl: ToastController,
    public loadingCtrl: LoadingController,
    public commissionData: CommissionData) { }

  ngAfterViewInit() {
    let loader = this.loadingCtrl.create({
      spinner: 'bubbles',
    });
    loader.present();
    this.loadCommissionDays();
    this.loadCommissionMonths().then(s => loader.dismiss()).catch(err => loader.dismiss());
  }

  loadCommissionDays() {
    return this.commissionData.getCommissionDay(0).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.commissionDays = data.data;
        } else {
          this.showToast(data.errmsg)
        }
      },
      error => {
        this.showToast(error)
      }
    )
  }

  loadCommissionMonths() {
    return this.commissionData.getCommissionMonth().then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.commissionMonths = data.data;
        } else {
          this.showToast(data.errmsg)
        }
      },
      error => {
        this.showToast(error)
      }
    )
  }

  goDetail(commission) {
    this.navCtrl.push(CommissionDetailPage, commission);
  }

  goMonthDetail(worksheet) {
    this.navCtrl.push(CommissionMonthPage, worksheet);
  }

  doInfinite(infiniteScroll: InfiniteScroll) {

    let lg = 0;
    this.commissionDays.forEach(element => {
      lg += element.commissions.length;
    });

    this.commissionData.getCommissionDay(lg).then((newData) => {
      let data: any = newData;
      if (data.errcode === 0) {
        let newData = data.data;
        for (var i = 0; i < newData.length; i++) {
          if (i == 0) {
            let lastTemp = this.commissionDays[this.commissionDays.length - 1];
            let temp = newData[0];
            if (lastTemp.date === temp.date) {
              for (var j = 0; j < temp.commissions.length; j++) {
                this.commissionDays[this.commissionDays.length - 1].commissions.push(temp.commissions[j]);
              }
              let sub_total = this.commissionDays[this.commissionDays.length - 1].sub_total;
              this.commissionDays[this.commissionDays.length - 1].sub_total = sub_total + temp.sub_total;
            } else {
              this.commissionDays.push(newData[i]);
            }
          } else {
            this.commissionDays.push(newData[i]);
          }

        }

        if (newData.length <= 0) {
          infiniteScroll.enable(false);
        }

      }

      infiniteScroll.complete();
    });
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
