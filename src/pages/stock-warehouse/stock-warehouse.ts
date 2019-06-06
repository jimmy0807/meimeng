import { Component } from '@angular/core';
import { NavController, NavParams, ToastController } from 'ionic-angular';
import { StockData } from '../../providers/stock-data';

@Component({
  selector: 'page-stock-warehouse',
  templateUrl: 'stock-warehouse.html'
})
export class StockWarehousePage {
  list = [];
  constructor(public navCtrl: NavController,
    public toastCtrl: ToastController,
    public stockData: StockData,
    public navParams: NavParams) { }

  async ngAfterViewInit() {
    try {
      let r = await this.stockData.getWarehouseList();
      if (r.errcode == 0)
        this.list = r.data;
      else
        this.showToast(r.errmsg);
    } catch (e) {
      this.showToast();
    }
    finally {

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
