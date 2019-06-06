
import { Component } from '@angular/core';
import { NavController, ModalController, InfiniteScroll, ViewController, NavParams } from 'ionic-angular';
import { ProductData } from '../../providers/product-data';
import { Reservation } from '../../providers/reservation-data';

@Component({
  selector: 'page-reservation-product',
  templateUrl: 'reservation-product.html'
})
export class ReservationProductPage {

  holdProducts: any[] = [];
  products: any[] = [];
  cardProducts: any[] = [];
  customerProducts: any[] = [];
  segment = 'all';
  keyword = ''
  r: Reservation;
  constructor(
    public navCtrl: NavController,
    public viewCtrl: ViewController,
    public modalCtrl: ModalController,
    public navParams: NavParams,
    public productData: ProductData) {
    this.r = navParams.data;
  }

  ngAfterViewInit() {
    this.getReservationProducts(0);
  }

  getReservationProducts(offset) {
    this.productData.getReservationProducts(0, this.keyword, this.r.member_id || null).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.products = data.data.all_products;
          this.cardProducts = data.data.member_products;;
        }
      },
      error => {
      }
    )
  }

  doInfinite(infiniteScroll: InfiniteScroll) {
    this.productData.getReservationProducts(this.products.length, this.keyword).then((newData) => {
      let data: any = newData;
      if (data.errcode === 0) {
        let newData = data.data.all_products;
        for (var i = 0; i < newData.length; i++) {
          this.products.push(newData[i]);
        }
        if (newData.length <= 0) {
          infiniteScroll.enable(false);
        }
      }
      infiniteScroll.complete();
    });
  }

  dismiss() {
    this.viewCtrl.dismiss();
  }

  onConfirm() {
    let selected = this.products.filter(p => p.checked).concat(this.cardProducts.filter(p => p.checked));
    if (selected.length <= 0) {
      return;
    }
    this.viewCtrl.dismiss(selected);
  }

  clear() {
    this.r.products = [];
    this.r.product_ids = [];
    this.r.product_names = '';
    this.viewCtrl.dismiss();
  }

  onInput(ev) {
    this.products = this.holdProducts;
    let val = ev.target.value;
    this.keyword = val;
    this.getReservationProducts(0);
  }

  onCancel(ev) {
    this.keyword = '';
  }
}
