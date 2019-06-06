import { Component } from '@angular/core';
import { ToastController, NavController, NavParams, Refresher } from 'ionic-angular';
import { PricelistDetailPage } from '../pricelist-detail/pricelist-detail';
import { PricelistData } from '../../providers/pricelist-data';
import { AppGlobal } from '../../app-global';
import { LoadingController } from 'ionic-angular';

@Component({
  selector: 'page-pricelist',
  templateUrl: 'pricelist.html'
})
export class PricelistPage {
  isAdmin = true;
  pricelists = [];
  constructor(public navCtrl: NavController,
    public navParams: NavParams,
    public loadingCtrl: LoadingController,
    public pricelistData: PricelistData,
    public toastCtrl: ToastController) {
    let user = AppGlobal.getInstance().user;
    this.isAdmin = user != undefined && user.role == '1';
  }

  ngAfterViewInit() {
    //this.getPricelists(undefined);
  }

  ionViewDidEnter() {
    let loader = this.loadingCtrl.create({
      spinner: 'bubbles',
    });
    loader.present();
    this.getPricelists(undefined).then(s => loader.dismiss()).catch(err => loader.dismiss());
  }

  getPricelists(refresher: Refresher) {
    return this.pricelistData.getPricelists().then(
      info => {
        let data: any = info;
        if (refresher != undefined)
          refresher.complete();
        if (data.errcode == 0) {
          this.pricelists = data.data;
        }
        else {
          this.showToast(data.errmsg);
        }
      },
      err => {
        if (refresher != undefined)
          refresher.complete();
        this.showToast();
      }
    )
  }

  doRefresh(refresher: Refresher) {
    this.getPricelists(refresher);
  }

  edit(item) {
    this.navCtrl.push(PricelistDetailPage, item);
  }

  create() {
    this.navCtrl.push(PricelistDetailPage);
  }

  unlink(item) {
    this.pricelistData.deletePricelist(item.id).then(
      (info) => {
        let data: any = info;
        this.showToast(data.errmsg);
        if (data.errcode === 0) {
          let index = this.pricelists.indexOf(item);
          this.pricelists.splice(index, 1);
        }
      },
      err => this.showToast());
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}

