import { Component } from '@angular/core';
import { NavController, NavParams, InfiniteScroll, ModalController, ActionSheetController, Platform, Refresher, ToastController } from 'ionic-angular';
import { MemberData, Member } from '../../providers/member-data';
import { MemberDetailPage } from '../member-detail/member-detail';
import { VisitPage } from '../visit/visit';
import { MemberAddPage } from '../member-add/member-add';
//import { MemberFilterPage } from '../member-filter/member-filter';
import { AppGlobal } from '../../app-global';
import { LoadingController } from 'ionic-angular';
import { MemberCardsPage } from '../member-cards/member-cards';

@Component({
  selector: 'page-member-list',
  templateUrl: 'member-list.html'
})
export class MemberListPage {
  segment = 'formal';
  infiniteEnabled = true;
  members: Member[] = [];
  keyword = '';
  filters = {};
  members_mvp: any = [];
  members_new: any = [];
  members_vip: any = [];
  members_normal: any = [];
  members_experience: any = [];
  allowAdd = false;
  constructor(public navCtrl: NavController,
    public navParams: NavParams,
    public memberData: MemberData,
    public modalCtrl: ModalController,
    public loadingCtrl: LoadingController,
    public platform: Platform,
    public asCtrl: ActionSheetController,
    public toastCtrl: ToastController, ) {
    let ug = AppGlobal.getInstance().userGroup;
    if (ug)
      this.allowAdd = ['收银员', '经理'].indexOf(ug.sel_groups_52_53_54) >= 0;
  }

  ngAfterViewInit() {
    let loader = this.loadingCtrl.create({
      spinner: 'bubbles',
    });
    loader.present();
    this.getMemberList(0, '').then(s => loader.dismiss()).catch(err => loader.dismiss());
  }

  getMemberList(offset: number, key, refresher: Refresher = null) {
    return this.memberData.getMemberList(offset, key, this.filters).then(
      info => {
        if (refresher)
          refresher.complete();
        let data: any = info;
        if (data.errcode == 0) {
          this.members = data.data;
          this.infiniteEnabled = data.data.length == 20;
          this.filterMembers();
        }
        else {
          this.showToast(data.errmsg);
        }
      },
      err => {
        if (refresher)
          refresher.complete();
        this.showToast();
      }
    )
  }

  doRefresh(refresher: Refresher) {
    this.getMemberList(0, this.keyword, refresher);
  }

  onInput(ev) {
    this.getMemberList(0, this.keyword);
  }

  onCancel(ev) {
    this.keyword = '';
  }

  showMember(member) {
    if (this.allowAdd)
      member.mode = 'view';
    this.navCtrl.push(MemberDetailPage, member);
  }

  showVisit(item) {
    let param = {
      'id': item.id,
      'name': '',
      'member_name': item.name,
      'mobile': item.mobile,
    }
    let modal = this.modalCtrl.create(VisitPage, param);
    modal.present();
  }

  showCard(item) {
    this.navCtrl.push(MemberCardsPage, item);
  }

  present() {
    let buttons = [];
    buttons.push({
      text: '新建会员',
      icon: !this.platform.is('ios') ? 'add' : null,
      handler: () => {
        this.navCtrl.push(MemberAddPage, { is_ad: false });
      }
    });
    //buttons.push({
    //  text: '新建体验会员',
    //  icon: !this.platform.is('ios') ? 'trash' : null,
    //  handler: () => {
    //    this.navCtrl.push(MemberAddPage, { is_ad: true });
    //  }
    //});
    //buttons.push({
    //  text: '筛选',
    //  icon: !this.platform.is('ios') ? 'arrow-dropright-circle' : null,
    //  handler: () => {
    //    let m = this.modalCtrl.create(MemberFilterPage, this.filters);
    //    m.onDidDismiss(data => {
    //      if (data) {
    //        this.filters = data;
    //        this.getMemberList(0, this.keyword);
    //      }
    //    });
    //    m.present();
    //  }
    //});
    buttons.push({
      text: '取消',
      role: 'cancel',
      icon: !this.platform.is('ios') ? 'close' : null,
    });
    let actionSheet = this.asCtrl.create({
      buttons: buttons
    });
    actionSheet.present();
  }

  filterMembers() {
    let list = this.members;
    this.members_mvp = list.filter(m => m.member_level === 'mvp');
    this.members_new = list.filter(m => m.member_level === 'new' || !m.member_level);
    this.members_vip = list.filter(m => m.member_level === 'vip');
    this.members_normal = list.filter(m => m.member_level === 'normal');
    this.members_experience = list.filter(m => m.is_ad);
  }

  doInfinite(infiniteScroll: InfiniteScroll) {
    this.memberData.getMemberList(this.members.length, this.keyword, this.filters).then(
      (newData) => {
        let data: any = newData;
        if (data.errcode === 0) {
          let newItems = data.data;
          for (var i = 0; i < newItems.length; i++) {
            this.members.push(newItems[i]);
          }
          this.infiniteEnabled = data.data.length == 20;
          this.filterMembers();
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
