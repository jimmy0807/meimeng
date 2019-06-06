import { Component } from '@angular/core';
import { NavController, NavParams, ToastController, ModalController, ViewController } from 'ionic-angular';
import { MemberData, Card, CardLine } from '../../providers/member-data';
import { PricelistData } from '../../providers/pricelist-data';
import { ProductDetailSelectorPage } from '../product-detail-selector/product-detail-selector';
import { MemberCardLinePage } from '../member-card-line/member-card-line';
import { MemberCardArrearsPage } from '../member-card-arrears/member-card-arrears';

@Component({
  selector: 'page-member-card-detail',
  templateUrl: 'member-card-detail.html'
})
export class MemberCardDetailPage {
  segment = 'normal';
  card: Card = {}
  pricelists = [];
  member;
  view = false;
  year;
  constructor(public navCtrl: NavController,
    public toastCtrl: ToastController,
    public pricelistData: PricelistData,
    public viewCtrl: ViewController,
    public memberData: MemberData,
    public modalCtrl: ModalController,
    public navParams: NavParams) {
    this.member = navParams.data.member;
    this.card = navParams.data.card;
    this.year = new Date().getFullYear() + 10;
    if (this.card.id)
      this.view = true;
    else {
      this.card.product_ids = [];
      this.card.arrears_ids = [];
    }
  }

  ngAfterViewInit() {
    if (!this.view)
      this.getPricelists();
  }

  getPricelists() {
    this.pricelistData.getPricelists().then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.pricelists = data.data;
        }
        else {
          this.showToast(data.errmsg);
        }
      },
    ).catch(() => this.showToast());
  }

  editLine(line) {
    if (this.view)
      return;
    this.navCtrl.push(MemberCardLinePage, line);
  }

  deleteLine(line) {
    let index = this.card.product_ids.indexOf(line);
    this.card.product_ids.splice(index, 1);
  }

  createArrears() {
    this.navCtrl.push(MemberCardArrearsPage, { card: this.card, arrears: {} });
  }

  editArrears(arr) {
    if (this.view)
      return;
    this.navCtrl.push(MemberCardArrearsPage, { card: this.card, arrears: arr });
  }

  deleteArrears(arr) {
    let index = this.card.arrears_ids.indexOf(arr);
    this.card.arrears_ids.splice(index, 1);
  }

  async save() {
    if (!this.card.no) {
      this.showToast("请输入卡号");
      return;
    }
    if (!this.card.pricelist_id) {
      this.showToast("请选择折扣方案");
      return;
    }
    try {
      let data = await this.memberData.importMemberCard(this.member.id, this.card);
      this.showToast(data.errmsg);
      if (data.errcode == 0)
        this.viewCtrl.dismiss();
    } catch (e) {
      this.showToast();
    }
  }

  createLine() {
    let modal = this.modalCtrl.create(ProductDetailSelectorPage, { type: 'same', mode: 'multiple' });
    modal.onDidDismiss(d => {
      if (d) {
        let ids = this.card.product_ids.map(i => i.product_id);
        d.forEach(p => {
          if (ids.indexOf(p.id) == -1)
            this.card.product_ids.push(<CardLine>{
              name: p.name,
              product_id: p.id,
              price_unit: p.lst_price,
              qty: 1,
            })
        });
      }
    });
    modal.present();
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
