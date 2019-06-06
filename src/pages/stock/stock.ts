import { Component } from '@angular/core';
import { NavController, NavParams, ActionSheetController } from 'ionic-angular';
import { StockLocationPage } from '../stock-location/stock-location';
import { StockWarehousePage } from '../stock-warehouse/stock-warehouse';
import { StockInternalPage } from '../stock-internal/stock-internal';
import { StockInventoryPage } from '../stock-inventory/stock-inventory';
import { StockProductPage } from '../stock-product/stock-product';

@Component({
  selector: 'page-stock',
  templateUrl: 'stock.html'
})
export class StockPage {
  list = [];
  constructor(public navCtrl: NavController,
    public asCtrl: ActionSheetController,
    public navParams: NavParams) { }

  more() {
    let buttons = [{
      text: '仓库',
      handler: () => { this.navCtrl.push(StockWarehousePage) }
    },
    {
      text: '库位',
      handler: () => { this.navCtrl.push(StockLocationPage) }
    },
    {
      text: '取消',
      role: 'cancel',
    }]
    let actionSheet = this.asCtrl.create({
      buttons: buttons
    });
    actionSheet.present();
  }

  show(page: string) {
    switch (page) {
      case 'db':
        this.navCtrl.push(StockInternalPage); break;
      case 'cp':
        this.navCtrl.push(StockProductPage); break;
      case 'pd':
        this.navCtrl.push(StockInventoryPage); break;
    }
  }
}
