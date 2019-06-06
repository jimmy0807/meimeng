import { Component } from '@angular/core';
import { NavController, NavParams, ModalController, ViewController, ToastController } from 'ionic-angular';
import { ProductDetailSelectorPage } from '../product-detail-selector/product-detail-selector';
import { ProductData, ProductLine, ProductTemplate } from '../../providers/product-data';

@Component({
  selector: 'page-product-detail-line',
  templateUrl: 'product-detail-line.html'
})
export class ProductDetailLinePage {
  product: ProductTemplate = {};
  title: string;
  packMode = true;
  lineEditMode = true;
  productEditMode = true;
  showMore = false;
  line: ProductLine = {};

  constructor(public navCtrl: NavController,
    public modalCtrl: ModalController,
    public viewCtrl: ViewController,
    public navParams: NavParams,
    public toastCtrl: ToastController,
    public productData: ProductData) {

    this.product = navParams.data.product;
    this.productEditMode = this.product.id > 0;
    this.packMode = this.product.category_code != 2;

    if (navParams.data.line) {
      this.lineEditMode = true;
      this.line = navParams.data.line;
    }
    else {
      this.lineEditMode = false;
      this.line.qty = 1;
    }

    this.title = this.lineEditMode ? '编辑项目' : '添加项目';
    this.showMore = this.packMode && this.lineEditMode && this.productEditMode
      && this.product.category_code == 3 && this.product.type == 'service';
  }

  saveLine() {
    let item = this.line;
    if (!(item.qty > 0)) {
      this.showToast("请输入数量");
      return;
    }
    if (!(item.product_id > 0)) {
      this.showToast("请选择产品");
      return;
    }

    if (this.productEditMode) {
      item.tmpl_id = this.product.id;
      if (this.packMode) {
        this.productData.savePackLine(item).then(
          info => {
            let data: any = info;
            if (data.errcode == 0) {
              this.showToast(data.errmsg).then(() =>
                this.viewCtrl.dismiss());
            }
            else
              this.showToast(data.errmsg);
          },
          err => this.showToast())
      }
      else {
        this.productData.saveConsumeLine(item).then(
          info => {
            let data: any = info;
            if (data.errcode == 0) {
              this.showToast(data.errmsg).then(() =>
                this.viewCtrl.dismiss());
            }
            else
              this.showToast(data.errmsg);
          },
          err => this.showToast());
      }
    }
    else {
      if (!this.lineEditMode) {
        if (this.packMode)
          this.product.pack_line_ids.push(item);
        else
          this.product.consumables_ids.push(item);
      }
      this.viewCtrl.dismiss();
    }
  }

  selectProduct() {
    let type = this.packMode ? 'pack' : 'consume';
    let modal = this.modalCtrl.create(ProductDetailSelectorPage, { type: type, mode: 'single' });
    modal.onDidDismiss(d => {
      if (d != undefined && d.id > 0) {
        this.line.product_id = d.id;
        this.line.product_name = d.name;
        this.line.lst_price = d.lst_price;
      }
    });
    modal.present();
  }

  addSame() {
    let modal = this.modalCtrl.create(ProductDetailSelectorPage, { type: 'same', mode: 'multiple' });
    modal.onDidDismiss(d => {
      if (d) {
        let ids = this.line.same_ids.map(i => i.id);
        d.forEach(p => {
          if (ids.indexOf(p.id) == -1)
            this.line.same_ids.push(p)
        });
      }
    });
    modal.present();
  }

  deleteSame(item) {
    let index = this.line.same_ids.indexOf(item);
    this.line.same_ids.splice(index, 1);
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    return toast.present();
  }

  dismiss() {
    this.viewCtrl.dismiss();
  }
}
