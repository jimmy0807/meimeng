import { Component } from '@angular/core';
import { NavController, NavParams, ActionSheetController, ModalController } from 'ionic-angular';
import { MemberDetailPage } from '../member-detail/member-detail';
import { VisitData } from '../../providers/visit-data';

@Component({
  selector: 'page-message-member',
  templateUrl: 'message-member.html'
})
export class MessageMemberPage {
  //groups: MsgGroup[] = [];
  mode: string;
  title = '会员跟进';
  members: {
    types?: string[]
  }[];
  constructor(public navCtrl: NavController,
    public asCtrl: ActionSheetController,
    public visitData: VisitData,
    public modalCtrl: ModalController,
    public navParams: NavParams) {
    this.mode = navParams.data.mode;
    this.members = navParams.data.members || [];
    this.groupMembers();
  }

  groupMembers() {
    if (this.mode == 'birth') {
      this.title = '生日跟进';
      this.members = this.members.filter(m => m.types.some(t => t.startsWith('生日')));
    }
    else {

    }
  }

  showMember(item) {
    let param = {
      'id': item.id
    }
    this.navCtrl.push(MemberDetailPage, param);
  }

  showVisit(item) {
    //let param = {
    //  'id': item.id,
    //  'name': '',
    //  'member_name': item.name,
    //  'mobile': item.mobile,
    //}
    //let modal = this.modalCtrl.create(VisitPage, param);
    //modal.onDidDismiss(data => {
    //  if (data != undefined) {
    //    this.removeItem(item);
    //  }
    //});
    //modal.present();
    this.navCtrl.push('VisitList');
  }

  removeItem(item) {
    let index = this.members.indexOf(item);
    this.members.splice(index, 1);
  }
}

export interface MsgGroup {
  name?: string;
  count?: number;
  members?: any[];
}
