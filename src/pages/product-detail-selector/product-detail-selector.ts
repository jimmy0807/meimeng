import { Component } from '@angular/core';
import { NavController, NavParams, InfiniteScroll, ToastController, ViewController } from 'ionic-angular';
import { ProductData, ProductLine, ProductTemplate } from '../../providers/product-data';

@Component({
  selector: 'page-product-detail-selector',
  templateUrl: 'product-detail-selector.html'
})

export class ProductDetailSelectorPage {
  type: string;
  //single,multiple
  mode: string;
  productId: number;
  title: string;
  keyword: string = '';
  infiniteEnabled = true;

  items: {
    id?: number,
    name?: string,
    lst_price?: number,
    qty?: number,
    checked?: boolean
  }[] = [];

  constructor(public navCtrl: NavController,
    public viewCtrl: ViewController,
    public navParams: NavParams,
    public productData: ProductData,
    public toastCtrl: ToastController) {
    this.type = navParams.data.type;
    this.mode = navParams.data.mode;
    this.productId = navParams.data.productId;
  }

  ngAfterViewInit() {
    this.getItems();
  }

  switchActions(offset: number, keyword: string) {
    let action: Promise<{}>;
    switch (this.type) {
      case "same": action = this.productData.getSameProduct(offset, keyword); break;
      case "pack": action = this.productData.getPackProduct(offset, keyword); break;
      case "consume": action = this.productData.getConsumeProduct(offset, keyword); break;
      case "all": action = this.productData.getAllProduct(offset, keyword); break;
    }
    return action;
  }

  getItems(offset = 0, key = '') {
    this.switchActions(offset, this.keyword).then(
      (newData) => {
        let data: any = newData;
        if (data.errcode === 0) {
          this.items = data.data;
          this.infiniteEnabled = this.items.length == 20;
        }
        else {
          this.showToast(data.errmsg);
        }
      },
      err => this.showToast());
  }

  onInput(ev) {
    this.getItems(0, this.keyword);
  }

  onCancel(ev) {
    this.keyword = '';
  }

  onSelected(item) {
    this.viewCtrl.dismiss(item);
  }

  save() {
    let prds = this.items.filter(i => i.checked);
    if (this.type == 'same' || this.type == 'all') {
      this.viewCtrl.dismiss(prds);
      return;
    }

    let lines = prds.map(p => {
      let newLine: ProductLine = {};
      newLine.lst_price = p.lst_price;
      newLine.qty = 1;
      newLine.product_id = p.id;
      newLine.product_name = p.name;
      return newLine;
    })

    let tmp: ProductTemplate = {};
    tmp.pack_line_ids = [];
    tmp.consumables_ids = [];
    if (this.productId) {
      let action: Promise<{}>;
      switch (this.type) {
        case "pack": action = this.productData.addPackLines(this.productId, lines); break;
        case "consume": action = this.productData.addConsumeLines(this.productId, lines); break;
      }
      action.then(
        info => {
          let data: any = info;
          this.showToast(data.errmsg);
          if (data.errcode === 0) {
            tmp.pack_line_ids = data.data.pack_line_ids;
            tmp.consumables_ids = data.data.consumables_ids;
            this.viewCtrl.dismiss(tmp);
          }
        },
        err => this.showToast());
    }
    else {
      switch (this.type) {
        case "pack": tmp.pack_line_ids = lines; break;
        case "consume": tmp.consumables_ids = lines; break;
      }
      this.viewCtrl.dismiss(tmp);
    }
  }

  dismiss() {
    this.viewCtrl.dismiss(false);
  }

  doInfinite(infiniteScroll: InfiniteScroll) {
    let action = this.switchActions(this.items.length, this.keyword);
    action.then(
      (newData) => {
        let data: any = newData;
        if (data.errcode === 0) {
          let newItems = data.data;
          for (var i = 0; i < newItems.length; i++) {
            this.items.push(newItems[i]);
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

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
