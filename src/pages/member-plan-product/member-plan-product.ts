import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, InfiniteScroll, ToastController, ViewController, LoadingController } from 'ionic-angular';
import { MemberData, CardLine } from '../../providers/member-data';
import { ProductData } from '../../providers/product-data';

@IonicPage()
@Component({
  selector: 'page-member-plan-product',
  templateUrl: 'member-plan-product.html',
})
export class MemberPlanProductPage {
  mid: number;
  cardLines: CardLine[] = [];
  prds: CardLine[] = [];
  keyword: string;
  segment: string = 'prd';
  infiniteEnabled = true;
  constructor(public navCtrl: NavController,
    public memberData: MemberData,
    public viewCtrl: ViewController,
    public loadingCtrl: LoadingController,
    public toastCtrl: ToastController,
    public productData: ProductData,
    public navParams: NavParams) {
    this.mid = navParams.data.mid;
  }

  async ngAfterViewInit() {
    let loader = this.loadingCtrl.create({ spinner: 'bubbles' });
    loader.present();
    try {
      let r = await this.memberData.getMemberCardProducts(this.mid);
      if (r.errcode === 0)
        this.cardLines = r.data;
      await this.getItems();
    }
    finally {
      loader.dismiss();
    }
  }

  async getItems() {
    let r = await this.productData.getAllProduct(0, this.keyword);
    if (r.errcode === 0) {
      this.prds = r.data;
      this.infiniteEnabled = this.prds.length === 20;
    }
    else {
      this.showToast(r.errmsg);
    }
  }

  onInput(ev) {
    this.getItems();
  }

  onCancel(ev) {
    this.keyword = '';
  }

  async doInfinite(infiniteScroll: InfiniteScroll) {
    try {
      let r = await this.productData.getAllProduct(this.prds.length, this.keyword);
      if (r.errcode === 0) {
        let arr = r.data;
        for (var i = 0; i < arr.length; i++) {
          this.prds.push(arr[i]);
        }
        this.infiniteEnabled = arr.length === 20;
      }
      else {
        this.showToast(r.errmsg)
      }
    } catch (e) {
      this.showToast();
    }
    finally {
      infiniteScroll.complete();
    }
  }
  save() {
    let data = {
      card: this.cardLines.filter(l => l.checked),
      prd: this.prds.filter(l => l.checked),
    }
    this.viewCtrl.dismiss(data);
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
