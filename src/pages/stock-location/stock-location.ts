import { Component } from '@angular/core';
import { NavController, NavParams, ToastController, ViewController, Refresher } from 'ionic-angular';
import { StockData } from '../../providers/stock-data';
import { StockLocationDetailPage } from '../stock-location-detail/stock-location-detail';

@Component({
  selector: 'page-stock-location',
  templateUrl: 'stock-location.html'
})
export class StockLocationPage {
  list = [];
  mode: string;
  constructor(public navCtrl: NavController,
    public toastCtrl: ToastController,
    public viewCtrl: ViewController,
    public stockData: StockData,
    public navParams: NavParams) {
    this.mode = navParams.data.mode;
  }

  async ngAfterViewInit() {
    await this.getStockLocations();
  }

  async getStockLocations() {
    try {
      let r = await this.stockData.getStockLocations();
      if (r.errcode == 0)
        this.list = r.data;
      else
        this.showToast(r.errmsg);
    } catch (e) {
      this.showToast();
    }
  }

  add() {
    this.navCtrl.push(StockLocationDetailPage, { locations: this.list, lot: {} });
  }

  edit(item) {
    if (this.mode === 'select')
      this.viewCtrl.dismiss(item);
    else
      this.navCtrl.push(StockLocationDetailPage, { locations: this.list, lot: item });
  }

  async doRefresh(r: Refresher) {
    try {
      await this.getStockLocations();
    }
    finally {
      r.complete();
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

