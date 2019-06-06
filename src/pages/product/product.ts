import { Component } from '@angular/core';
import { NavController, NavParams, ToastController, InfiniteScroll } from 'ionic-angular';
import { ProductDetailPage } from '../product-detail/product-detail';
import { ProductData } from '../../providers/product-data';
import { BarcodeScanner } from '@ionic-native/barcode-scanner';
import { AppGlobal } from '../../app-global';
import { LoadingController } from 'ionic-angular';

@Component({
  selector: 'page-product',
  templateUrl: 'product.html'
})
export class ProductPage {
  isAdmin = false;
  keyword: string = '';
  products = [];
  infiniteEnabled = true;

  constructor(public navCtrl: NavController,
    public navParams: NavParams,
    public barcodeScanner: BarcodeScanner,
    public loadingCtrl: LoadingController,
    public toastCtrl: ToastController,
    public productData: ProductData) {
    let user = AppGlobal.getInstance().user;
    this.isAdmin = true || user != undefined && user.role == '1';
  }

  ngAfterViewInit() {
    let loader = this.loadingCtrl.create({
      spinner: 'bubbles',
    });
    loader.present();
    this.getProductList().then(s => loader.dismiss()).catch(err => loader.dismiss());
  }

  getProductList(offset: number = 0, key = '') {
    return this.productData.getProductList(offset, key).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.products = data.data;
          this.infiniteEnabled = data.data.length == 20;
        }
        else {
          this.showToast(data.errmsg);
        }
      },
      err => {
        this.showToast();
      }
    )
  }

  onInput(ev) {
    this.getProductList(0, this.keyword);
  }

  onCancel(ev) {
    this.keyword = '';
  }

  doInfinite(infiniteScroll: InfiniteScroll) {
    this.productData.getProductList(this.products.length, this.keyword).then(
      (newData) => {
        let data: any = newData;
        if (data.errcode === 0) {
          let newItems = data.data;
          for (var i = 0; i < newItems.length; i++) {
            this.products.push(newItems[i]);
          }
          this.infiniteEnabled = newItems.length == 20;
        }
        else {
          this.showToast(data.errmsg);
        }
        infiniteScroll.complete();
      },
      err => this.showToast());
  }

  scan() {
    this.barcodeScanner.scan().then(
      data => this.keyword = String(data),
      err => this.showToast('错误')
    );
  }

  show(item) {
    if (this.isAdmin)
      this.navCtrl.push(ProductDetailPage, item);
  }

  delete(item) {
    this.productData.deleteProduct(item.id).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          let index = this.products.indexOf(item);
          this.products.splice(index, 1);
        }
        else {
          this.showToast(data.errmsg);
        }
      },
      err => this.showToast());
  }

  create() {
    this.navCtrl.push(ProductDetailPage);
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
