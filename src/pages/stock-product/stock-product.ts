import { Component } from '@angular/core';
import { NavController, NavParams, ViewController, ToastController, InfiniteScroll } from 'ionic-angular';
import { StockData } from '../../providers/stock-data';

@Component({
  selector: 'page-stock-product',
  templateUrl: 'stock-product.html'
})
export class StockProductPage {
  keyword = '';
  items: {
    id?: number;
    checked?: boolean,
  }[] = [];
  list: any[] = [];
  infiniteEnabled = true;
  allProduct = false;

  constructor(public navCtrl: NavController,
    public stockData: StockData,
    public toastCtrl: ToastController,
    public viewCtrl: ViewController,
    public navParams: NavParams) {
    //this.list = navParams.data;
  }

  async ngAfterViewInit() {
    await this.getItems();
  }

  async getItems(offset = 0, keyword = '') {
    let r = await this.stockData.getStockProducts(offset, keyword);
    if (r.errcode == 0) {
      this.items = r.data;
      this.infiniteEnabled = this.items.length === 20;
    }
    else
      this.showToast(r.errmsg);
  }

  selectAll() {
    this.items.forEach(p => p.checked = this.allProduct);
  }

  confirm() {
    if (!(this.list instanceof Array))
      return;
    let prds = this.items.filter(i => i.checked);
    for (var i = 0; i < prds.length; i++) {
      if (!this.list.some(p => p.id === prds[i].id))
        this.list.push(prds[i]);
    }
    this.viewCtrl.dismiss();
  }

  onInput(ev) {
    this.getItems(0, this.keyword);
  }

  onCancel(ev) {
    this.keyword = '';
  }

  async doInfinite(infiniteScroll: InfiniteScroll) {
    try {
      let r = await this.stockData.getStockProducts(this.items.length, this.keyword);
      if (r.errcode == 0) {
        let arr: any[] = r.data;
        for (var i = 0; i < arr.length; i++) {
          this.items.push(arr[i]);
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

  dismiss() {
    this.viewCtrl.dismiss();
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
