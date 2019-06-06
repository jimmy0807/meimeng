import { Component } from '@angular/core';
import { NavController, NavParams } from 'ionic-angular';
import { MemberDetailListPage } from '../member-detail-list/member-detail-list';
import { AppGlobal } from '../../app-global';

@Component({
  selector: 'page-member-detail-types',
  templateUrl: 'member-detail-types.html'
})
export class MemberDetailTypesPage {
  type;
  mid;
  title;
  groupMedical;
  constructor(public navCtrl: NavController,
    public navParams: NavParams) {
    this.type = navParams.data.type;
    this.mid = navParams.data.mid;
    this.groupMedical = AppGlobal.getInstance().groupMedical;
    switch (this.type) {
      case 'info': this.title = '详细信息'; break;
      case 'card': this.title = '消费记录'; break;
    }
  }

  show(mode: string) {
    this.navCtrl.push(MemberDetailListPage, { mode: mode, mid: this.mid });
  }
}
