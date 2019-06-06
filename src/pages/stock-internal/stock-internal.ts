import { Component } from '@angular/core';
import { NavController, NavParams } from 'ionic-angular';
import { StockInternalDetailPage } from '../stock-internal-detail/stock-internal-detail';

@Component({
  selector: 'page-stock-internal',
  templateUrl: 'stock-internal.html'
})
export class StockInternalPage {
  state: string;
  constructor(public navCtrl: NavController,
    public navParams: NavParams) { }

  add() {
    this.navCtrl.push(StockInternalDetailPage);
  }
}
