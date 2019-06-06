import { Component } from '@angular/core';
import { NavController, NavParams } from 'ionic-angular';
import { StockData } from '../../providers/stock-data';
import { StockProductPage } from '../stock-product/stock-product';

@Component({
  selector: 'page-stock-internal-detail',
  templateUrl: 'stock-internal-detail.html'
})
export class StockInternalDetailPage {
  title = '调拨单';
  item = {};
  locations = [];
  constructor(public navCtrl: NavController,
    public stockData: StockData,
    public navParams: NavParams) { }

  addProducts() {
    this.navCtrl.push(StockProductPage, []);
  }

  scan() {

  }
}
