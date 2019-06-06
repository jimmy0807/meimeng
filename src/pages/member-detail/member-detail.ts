import { Component } from '@angular/core';
import { NavController, NavParams, ViewController, ModalController, Refresher } from 'ionic-angular';
import { MemberAddPage } from '../member-add/member-add';
import { MemberData, Member } from '../../providers/member-data';
import { AppGlobal } from '../../app-global';
import { MemberDetailListPage } from '../member-detail-list/member-detail-list';

@Component({
  selector: 'page-member-detail',
  templateUrl: 'member-detail.html'
})
export class MemberDetailPage {
  memberBak: any;
  member: Member;
  mode = '';
  isMedical = false;
  constructor(
    public navParams: NavParams,
    public memberData: MemberData,
    public navCtrl: NavController,
    public viewCtrl: ViewController,
    public modalCtrl: ModalController, ) {
    if (navParams.data) {
      this.memberBak = navParams.data;
      this.member = navParams.data;
      this.mode = navParams.data.mode;
    }
    this.isMedical = AppGlobal.getInstance().groupMedical;
  }

  dismiss() {
    this.viewCtrl.dismiss();
  }

  async ngAfterViewInit() {
    try {
      let r = await this.memberData.getMemberInfo(this.member.id);
      if (r.errcode === 0)
        this.member = r.data;
    } catch (e) {

    }
  }

  async doRefresh(refresher: Refresher) {
    try {
      let r = await this.memberData.getMemberInfo(this.member.id);
      if (r.errcode === 0)
        this.member = r.data;
    } catch (e) {
    }
    finally {
      refresher.complete();
    }
  }

  showMember() {
    let tModal = this.modalCtrl.create(MemberAddPage, this.memberBak);
    tModal.onDidDismiss(data => {
      if (data) {
        this.member.name = data.name;
        this.member.image_url = data.image_url;
      }
    });
    tModal.present();
  }

  show(mode: string) {
    this.navCtrl.push(MemberDetailListPage, { mode: mode, mid: this.member.id });
  }

  showVisit() {
    this.navCtrl.push('VisitList', { mid: this.member.id, mname: this.member.name });
  }

  showPlan() {
    this.navCtrl.push('PadOrderPage', { mid: this.member.id, name: this.member.name });
  }

  showAnalysis() {
    this.navCtrl.push('MemberAnalysisPage', this.member.id);
  }

  showInfo() {
    this.navCtrl.push('MemberSourceinfoPage', this.member.id);
  }

  showPrepare() {
    this.navCtrl.push('MemberPreparePage', this.member);
  }
}
