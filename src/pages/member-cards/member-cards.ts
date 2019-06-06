import { Component } from '@angular/core';
import { NavController, NavParams, LoadingController, ToastController, Refresher } from 'ionic-angular';
import { MemberCardDetailPage } from '../member-card-detail/member-card-detail';
import { MemberData, Card } from '../../providers/member-data';

@Component({
  selector: 'page-member-cards',
  templateUrl: 'member-cards.html'
})
export class MemberCardsPage {
  member;
  mid;
  cards: Card[] = [];
  constructor(public navCtrl: NavController,
    public loadingCtrl: LoadingController,
    public toastCtrl: ToastController,
    public memberData: MemberData,
    public navParams: NavParams) {
    this.member = navParams.data;
    this.mid = navParams.data.id;
  }

  async ngAfterViewInit() {
    let loader = this.loadingCtrl.create({ spinner: 'bubbles', });
    loader.present();
    try {
      await this.getCards();
    }
    catch (e) {
      this.showToast();
    }
    finally {
      loader.dismiss();
    }
  }

  async getCards() {
    let data = await this.memberData.getMemberCards(this.mid);
    if (data.errcode == 0)
      this.cards = data.data;
    else
      this.showToast(data.errmsg);
  }

  async doRefresh(r: Refresher) {
    try {
      await this.getCards();
    }
    catch (e) {
      this.showToast();
    }
    finally {
      r.complete();
    }
  }

  show(c) {
    this.navCtrl.push(MemberCardDetailPage, { member: this.member, card: c });
  }

  import() {
    this.navCtrl.push(MemberCardDetailPage, { member: this.member, card: {} });
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
