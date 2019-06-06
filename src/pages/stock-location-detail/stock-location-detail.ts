import { Component } from '@angular/core';
import { NavController, NavParams, ToastController, ViewController, ModalController } from 'ionic-angular';
import { StockData, Location } from '../../providers/stock-data';
import { StockPartnerPage } from '../stock-partner/stock-partner';

@Component({
  selector: 'page-stock-location-detail',
  templateUrl: 'stock-location-detail.html'
})
export class StockLocationDetailPage {
  lot: Location;
  locations = [];
  removal = [];
  putaway = [];
  constructor(public navCtrl: NavController,
    public toastCtrl: ToastController,
    public modalCtrl: ModalController,
    public viewCtrl: ViewController,
    public stockData: StockData,
    public navParams: NavParams) {
    this.lot = navParams.data.lot;
    let lots: any[] = navParams.data.locations;
    this.locations = lots.filter(l => l != this.lot);
  }

  async ngAfterViewInit() {
    try {
      let r = await this.stockData.getRemovalStrategies();
      if (r.errcode == 0)
        this.removal = r.data;
      r = await this.stockData.getPutawayStrategies();
      if (r.errcode == 0)
        this.putaway = r.data;
    }
    catch (e) {
      this.showToast();
    }
  }

  selectPartner() {
    let m = this.modalCtrl.create(StockPartnerPage);
    m.onDidDismiss(d => {
      if (d) {
        this.lot.partner_id = d.id;
        this.lot.partner_name = d.name;
      }
    })
    m.present();
  }

  async save() {
    try {
      let r = await this.stockData.saveStockLocation(this.lot);
      this.showToast(r.errmsg);
      if (r.errcode == 0)
        this.viewCtrl.dismiss();
    } catch (e) {
      this.showToast();
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
