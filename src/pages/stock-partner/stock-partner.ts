import { Component } from '@angular/core';
import { NavController, NavParams, ToastController, ViewController, LoadingController, InfiniteScroll } from 'ionic-angular';
import { StockData } from '../../providers/stock-data';

@Component({
  selector: 'page-stock-partner',
  templateUrl: 'stock-partner.html'
})
export class StockPartnerPage {
  list = [];
  keyword: string = '';
  infiniteEnabled = true;

  constructor(public navCtrl: NavController,
    public stockData: StockData,
    public loadingCtrl: LoadingController,
    public viewCtrl: ViewController,
    public toastCtrl: ToastController,
    public navParams: NavParams) { }

  async ngAfterViewInit() {
    let loading = this.loadingCtrl.create({ spinner: 'bubbles' });
    loading.present();
    try {
      await this.getPartners();
    }
    catch (e) {
      this.showToast();
    }
    finally {
      loading.dismiss();
    }
  }

  async getPartners(offset = 0, keyword = null) {
    let r = await this.stockData.getPartners(keyword, offset);
    if (r.errcode == 0) {
      this.list = r.data;
      this.infiniteEnabled = this.list.length === 20;
    }
    else
      this.showToast(r.errmsg);
  }

  select(item) {
    this.viewCtrl.dismiss(item);
  }

  onInput(ev) {
    this.getPartners(0, this.keyword);
  }

  onCancel(ev) {
    this.keyword = '';
  }

  async doInfinite(infiniteScroll: InfiniteScroll) {
    try {
      let r = await this.stockData.getPartners(this.keyword, this.list.length);
      if (r.errcode == 0) {
        let arr: any[] = r.data;
        for (var i = 0; i < arr.length; i++) {
          this.list.push(arr[i]);
        }
        this.infiniteEnabled = arr.length === 20;
      }
      else
        this.showToast(r.errmsg);
    } catch (e) {
      this.showToast();
    }
    finally {
      infiniteScroll.complete();
    }
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }

  dismiss() {
    this.viewCtrl.dismiss(false);
  }
}
