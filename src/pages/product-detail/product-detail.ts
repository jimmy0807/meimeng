import { Component } from '@angular/core';
import { NavController, NavParams, ModalController, ToastController, ViewController } from 'ionic-angular';
import { ProductData, ProductLine, ProductTemplate } from '../../providers/product-data';
import { ProductDetailSelectorPage } from '../product-detail-selector/product-detail-selector';
import { ProductDetailLinePage } from '../product-detail-line/product-detail-line';
import { PosCategoryPage } from '../pos-category/pos-category';
import { BarcodeScanner } from '@ionic-native/barcode-scanner';

@Component({
  selector: 'page-product-detail',
  templateUrl: 'product-detail.html'
})
export class ProductDetailPage {
  segment: string = 'normal';
  segmentName: string = '消耗品';
  editMode = true;
  packMode = true;
  showAddLine = true;
  product: ProductTemplate = {};
  bornCats = [];
  productCats: {
    complete_name?: string,
    id?: number
  }[] = [];
  constructor(public navCtrl: NavController,
    public navParams: NavParams,
    public barcodeScanner: BarcodeScanner,
    public modalCtrl: ModalController,
    public toastCtrl: ToastController,
    public viewCtrl: ViewController,
    public productData: ProductData) {
    this.product = navParams.data;
    if (this.product.id > 0) {
      this.editMode = true;
    }
    else {
      this.getBornCats();
      this.product = {};
      this.product.sale_ok = true;
      this.product.available_in_pos = true;
      this.product.category_code = 1;
      this.product.type = 'product';
      this.product.consumables_ids = [];
      this.product.pack_line_ids = [];
      this.product.is_add = true;
      this.editMode = false;
    }
    this.changeMode();
  }

  ngAfterViewInit() {
    this.productData.getProductCategories().then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.productCats = data.data;
          if (!this.editMode)
            this.selectProductCat();
        }
        else
          this.showToast(data.errmsg);
      },
      err => this.showToast());
  }

  selectProductCat() {
    let bc = this.bornCats.find(c => c.code == this.product.category_code);
    if (bc) {
      let pc = this.productCats.find(c => c.complete_name.includes(bc.name));
      if (pc)
        this.product.categ_id = pc.id;
    }
  }

  changeMode() {
    switch (Number(this.product.category_code)) {
      case 1: this.showAddLine = false; this.packMode = false; break;
      case 2: this.showAddLine = true; this.packMode = false; break;
      default: this.showAddLine = true; this.packMode = true; break;
    }
    this.segmentName = this.packMode ? '组合套' : '消耗品';
    if (!this.editMode)
      this.selectProductCat()
  }

  getBornCats() {
    this.productData.getBornCategories().then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.bornCats = data.data;
        }
        else
          this.showToast(data.errmsg);
      },
      err => this.showToast()
    )
  }

  selectPosCat() {
    let modal = this.modalCtrl.create(PosCategoryPage, { allowEdit: true });
    modal.onDidDismiss(d => {
      if (d !== undefined && d.id > 0) {
        this.product.pos_categ_id = d.id;
        this.product.pos_categ_name = d.complete_name;
      }
    });
    modal.present();
  }

  scan(mode: string) {
    this.barcodeScanner.scan().then(
      data => {
        if (mode == 'd')
          this.product.default_code = String(data);
        else
          this.product.barcode = String(data);
      },
      err => this.showToast('错误'));
  }

  save() {
    if (this.product.name === undefined || this.product.name === '') {
      this.showToast("请输入名称");
      return;
    }
    if (this.product.list_price === undefined) {
      this.showToast("请输入售价");
      return;
    }
    if (!this.product.categ_id) {
      this.showToast("请选择打折分类");
      return;
    }

    if (!this.editMode) {
      for (var i = 0; i < this.bornCats.length; i++) {
        if (this.bornCats[i].code == this.product.category_code) {
          this.product.category_id = this.bornCats[i].id;
          break;
        }
      }
    }
    this.productData.saveProduct(this.product).then(
      info => {
        var data: any = info;
        if (data.errcode == 0) {
          this.product.id = data.data.id;
          if (!this.editMode) {
            this.product.pack_line_ids = data.data.pack_line_ids;
            this.product.consumables_ids = data.data.consumables_ids
            this.editMode = true;
          }
          this.dismiss();
        }
        this.showToast(data.errmsg);
      },
      err => {
        this.showToast();
      }
    );
  }

  editLine(item) {
    this.navCtrl.push(ProductDetailLinePage, {
      product: this.product,
      line: item
    });
  }

  createLine() {
    let type = this.packMode ? 'pack' : 'consume';
    let modal = this.modalCtrl.create(ProductDetailSelectorPage, { productId: this.product.id, type: type, mode: 'multiple' });
    modal.onDidDismiss(data => {
      let tmp: ProductTemplate = data;
      if (data) {
        if (this.editMode) {
          this.product.pack_line_ids = tmp.pack_line_ids;
          this.product.consumables_ids = tmp.consumables_ids;
        }
        else {
          tmp.pack_line_ids.forEach(l => this.product.pack_line_ids.push(l));
          tmp.consumables_ids.forEach(l => this.product.consumables_ids.push(l));
        }
      }
    })
    modal.present();
  }

  deleteLine(item: ProductLine) {
    if (this.packMode) {
      if (item.id)
        this.deletePackLine(item);
      else {
        let index = this.product.pack_line_ids.indexOf(item);
        this.product.pack_line_ids.splice(index, 1);
      }
    }
    else {
      if (item.id)
        this.deleteConsumeLine(item);
      else {
        let index = this.product.consumables_ids.indexOf(item);
        this.product.pack_line_ids.splice(index, 1);
      }
    }
  }

  deletePackLine(item) {
    this.productData.deletePackLine(item.id).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          let index = this.product.pack_line_ids.indexOf(item);
          this.product.pack_line_ids.splice(index, 1);
        }
        else {
          this.showToast(data.errmsg);
        }
      },
      err => this.showToast()
    )
  }

  deleteConsumeLine(item) {
    this.productData.deleteConsumeLine(item.id).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          let index = this.product.consumables_ids.indexOf(item);
          this.product.consumables_ids.splice(index, 1);
        }
        else {
          this.showToast(data.errmsg);
        }
      },
      err => this.showToast()
    )
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }

  dismiss() {
    this.viewCtrl.dismiss();
  }
}
