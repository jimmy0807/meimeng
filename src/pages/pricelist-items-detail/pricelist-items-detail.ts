import { Component } from '@angular/core';
import { NavController, NavParams, ViewController, ToastController, InfiniteScroll } from 'ionic-angular';
import { PricelistData, Pricelist, PricelistItem } from '../../providers/pricelist-data';

@Component({
  selector: 'page-pricelist-items-detail',
  templateUrl: 'pricelist-items-detail.html'
})
export class PricelistItemsDetailPage {
  model: {
    title?: string,
    mode?: string,
    itemName?: string;
    itemId?: any;
  } = {};
  keyword: string;
  pricelist: Pricelist = {};
  item: PricelistItem = {};
  applyItems: ApplyItem[] = [];
  appliedTypes = [{ type: "3_global", name: "所有商品" },
  { type: "2_product_category", name: "商品分类" },
  { type: "1_product", name: "指定商品" },
  { type: "0_product_variant", name: "商品规格" },
  { type: "2_pos_category", name: "POS商品分类" }];
  appliedType: ApplyType = {};

  constructor(public navCtrl: NavController,
    public navParams: NavParams,
    public viewCtrl: ViewController,
    public toastCtrl: ToastController,
    public pricelistData: PricelistData) {
    this.item = navParams.data[0];
    this.pricelist = navParams.data[1];
    if (this.item.id > 0) {
      this.model.title = "编辑";
      this.model.mode = 'edit';
    }
    else {
      this.model.title = "添加";
      this.model.mode = 'add';
    }
    this.typeSelected();
    this.model.itemId = this.item.categ_id || this.item.pos_categ_id || this.item.product_id || this.item.product_tmpl_id || 0;
    this.model.itemName = this.item.display_name;
  }

  dismiss() {
    this.viewCtrl.dismiss();
  }

  save() {
    if (this.item.name === undefined || this.pricelist.name === '') {
      this.showToast("请输入名称");
      return;
    }
    if (this.item.first_price_discount === undefined) {
      this.showToast("请输入折扣");
      return;
    }
    if (this.item.first_price_discount < 0 || this.item.first_price_discount > 10) {
      this.showToast("请输入正确的折扣");
      return;
    }
    if (!(this.item.sequence > 0)) {
      this.showToast("请输入优先级");
      return;
    }
    if (this.item.applied_on != '3_global' && !(this.model.itemId > 0)) {
      this.showToast("请选择" + this.appliedType.name);
      return;
    }
    this.pricelistData.savePricelistItem(this.item).then(
      info => {
        var data: any = info;
        if (data.errcode == 0) {
          this.item.display_name = data.data.display_name;
          this.model.itemName = this.item.display_name;
          if (this.item.id > 0) { }
          else {
            this.item.id = data.data.id;
            this.pricelist.items.unshift(this.item);
            this.model.mode = 'edit';
          }
        }
        this.showToast(data.errmsg);
        this.viewCtrl.dismiss();
      },
      err => {
        this.showToast();
      }
    );
  }

  typeSelected() {
    this.keyword = '';
    this.applyItems = [];
    this.getApplyItems(0, '');
    this.appliedType = this.getApplyType();
    this.model.itemName = '';
    this.model.itemId = 0;
  }

  getApplyType() {
    return this.appliedTypes.find(t => t.type == this.item.applied_on);
  }

  getApplyItems(offset: Number, keyword: string) {
    let action = this.switchActions(offset, keyword);
    if (action === undefined)
      return;
    action.then(
      (newData) => {
        let data: any = newData;
        if (data.errcode === 0) {
          this.applyItems = data.data;
        }
        else {
          this.showToast(data.errmsg);
        }
      },
      err => this.showToast());
  }

  switchActions(offset: Number, keyword: string) {
    let action: Promise<{}>;
    switch (this.item.applied_on) {
      case "2_product_category": action = this.pricelistData.getProductCategories(offset, keyword); break;
      case "1_product": action = this.pricelistData.getProducts(offset, keyword); break;
      case "0_product_variant": action = this.pricelistData.getProductVariants(offset, keyword); break;
      case "2_pos_category": action = this.pricelistData.getPosCategories(offset, keyword); break;
    }
    return action;
  }

  itemSelected() {
    let id = this.model.itemId;
    switch (this.item.applied_on) {
      case '2_product_category':
        this.item.categ_id = id; break;
      case '1_product':
        this.item.product_tmpl_id = id; break;
      case '0_product_variant':
        this.item.product_id = id; break;
      case '2_pos_category':
        this.item.pos_categ_id = id; break;
    }
  }

  onInput(ev) {
    let val = ev.target.value;
    this.keyword = val;
    this.getApplyItems(0, val);
  }

  onCancel(ev) {
    this.keyword = '';
  }

  doInfinite(infiniteScroll: InfiniteScroll) {
    let action = this.switchActions(this.applyItems.length, '');
    if (action === undefined)
      return;
    action.then(
      (newData) => {
        let data: any = newData;
        if (data.errcode === 0) {
          let newItems = data.data;
          for (var i = 0; i < newItems.length; i++) {
            this.applyItems.push(newItems[i]);
          }
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

export interface ApplyType {
  type?: string;
  name?: string;
}

export interface ApplyItem {
  id?: number;
  name?: string;
}
