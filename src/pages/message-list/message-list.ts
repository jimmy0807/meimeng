import { Component } from '@angular/core';
import { NavController, NavParams, Refresher } from 'ionic-angular';
import { MessageCount } from '../../providers/message-data';
import { MessageQuestPage } from '../message-quest/message-quest';
import { MessageDetailPage } from '../message-detail/message-detail';
import { MessageData } from '../../providers/message-data';


@Component({
  selector: 'page-message-list',
  templateUrl: 'message-list.html'
})

export class MessageListPage {
  msgCount: MessageCount = {};
  showBirth = false;
  constructor(public navCtrl: NavController,
    public messageData: MessageData,
    public navParams: NavParams) {
    this.msgCount = navParams.data;

    //let user = AppGlobal.getInstance().user;
    //if (user != undefined) {
    //  let role = Number(user.role);
    //  switch (role) {
    //    case 1: case 3: case 4:
    //      this.showBirth = true;
    //      break;
    //  }
    //}
  }

  showMessages(type: string) {
    //reservation,commission,system,quest,birthday,festival
    switch (type) {
      case "quest":
        this.navCtrl.push(MessageQuestPage, { count: this.msgCount });
        return;
      case "birthday":
      case "festival":
        //this.navCtrl.push(MessageBirthdayPage, { type: type });
        return;
      case 'reservation':
        this.msgCount.reservation = 0;
        this.readMessages(this.msgCount.cat2);
        this.msgCount.cat2 = [];
        break;
      case 'commission':
        this.msgCount.commission = 0;
        this.readMessages(this.msgCount.cat3);
        this.msgCount.cat3 = [];
        break;
      case 'system':
        this.msgCount.system = 0;
        this.readMessages(this.msgCount.cat1);
        this.msgCount.cat1 = [];
        break;
    };
    this.navCtrl.push(MessageDetailPage, { mode: type, count: this.msgCount });
  }

  readMessages(ids: number[]) {
    if (ids && ids.length > 0) {
      this.messageData.readMessage(ids).then(
        info => {
          let data: any = info;
          if (data.errcode == 0) {
            this.msgCount.count -= data.data.count;
            this.changeCount();
          }
        });
    }
  }

  doRefresh(refresher: Refresher) {
    this.messageData.getMessageCount().then(
      info => {
        refresher.complete();
        let data: any = info;
        if (data.errcode == 0) {
          for (let p in data.data)
            this.msgCount[p] = data.data[p];
          this.changeCount();
        }
      }
    )
  }

  changeCount() {
    let count = this.msgCount.count;
    if (count > 99)
      this.msgCount.badge = '99+';
    else if (count > 0)
      this.msgCount.badge = count.toString();
    else
      this.msgCount.badge = '';
  }
}
