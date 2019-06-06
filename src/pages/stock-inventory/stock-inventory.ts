import { Component } from '@angular/core';
import { NavController, NavParams } from 'ionic-angular';

@Component({
  selector: 'page-stock-inventory',
  templateUrl: 'stock-inventory.html'
})
export class StockInventoryPage {
  state: string;
  constructor(public navCtrl: NavController, public navParams: NavParams) {}

  ionViewDidLoad() {
    console.log('ionViewDidLoad StockInventoryPage');
  }

}
