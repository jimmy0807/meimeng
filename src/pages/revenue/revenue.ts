import { Component } from '@angular/core';
import { NavController, InfiniteScroll } from 'ionic-angular';
import { RevenueOperatePage } from '../revenue-operate/revenue-operate';
import { RevenueData } from '../../providers/revenue-data';
import { LoadingController } from 'ionic-angular';

@Component({
  selector: 'page-revenue',
  templateUrl: 'revenue.html'
})
export class RevenuePage {

  segment = 'day';
  revenueDays: any = [];
  revenueMonths: any = [];

  constructor(public navCtrl: NavController,
    public loadingCtrl: LoadingController,
    public revenueData: RevenueData) { }


  ngAfterViewInit() {
    let loader = this.loadingCtrl.create({
      spinner: 'bubbles',
    });
    loader.present();
    this.loadCommissionDays().then(s => loader.dismiss()).catch(err => loader.dismiss());
    this.loadCommissionMonths();
  }


  loadCommissionDays() {
    return this.revenueData.getRevenueDay(this.revenueDays.length).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.revenueDays = data.data;
        } else {
          alert(data.errmsg)
        }
      },
      error => {
        alert(error)
      }
    )
  }

  doInfinite(infiniteScroll: InfiniteScroll) {

    this.revenueData.getRevenueDay(this.revenueDays.length).then((newData) => {
      let data: any = newData;
      if (data.errcode === 0) {
        let newData = data.data;
        for (var i = 0; i < newData.length; i++) {
          this.revenueDays.push(newData[i]);
        }

        if (newData.length <= 0) {
          infiniteScroll.enable(false);
        }
      }
      infiniteScroll.complete();
    });
  }

  showDetail(item) {
    let param = {
      'did': item.id,
      'mid': 0
    }
    this.navCtrl.push(RevenueOperatePage, param)
  }

  showMonthDetail(item) {
    let param = {
      'did': 0,
      'mid': item.id
    }
    this.navCtrl.push(RevenueOperatePage, param)
  }

  loadCommissionMonths() {
    this.revenueData.getRevenueMonth().then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.revenueMonths = data.data;
        } else {
          alert(data.errmsg)
        }
      },
      error => {
        alert(error)
      }
    )
  }

}
