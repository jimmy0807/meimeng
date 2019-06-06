import { Component } from '@angular/core';
import { NavController, NavParams, Refresher, ToastController, InfiniteScroll } from 'ionic-angular';
import { MessageData, Message, MessageCount } from '../../providers/message-data';
import { MessageDetailPage } from '../message-detail/message-detail'

@Component({
  selector: 'page-message',
  templateUrl: 'message.html'
})
export class MessagePage {
  model: {
    type?: string;
    icon?: string;
    iconClass?: string;
    title?: string;
  } = {};
  msgs: Message[] = [];
  msgCount: MessageCount = {};
  infiniteEnabled = true;

  //classDict = {
  //  'class1': [0, 1, 9, 10],
  //  'class2': [7],
  //  'class3': [2],
  //  'class4': [3],
  //  'class5': [4, 5, 6],
  //  'class6': [8, 11, 12]
  //}

  constructor(public navCtrl: NavController,
    public navParams: NavParams,
    public messageData: MessageData,
    public toastCtrl: ToastController) {
    this.model.type = navParams.data.type;
    this.msgCount = navParams.data.count;
    this.model.iconClass = 'icon-large ';
    switch (this.model.type) {
      case 'class1':
        this.model.title = '系统通知';
        this.model.icon = '\uf028';
        this.model.iconClass += 'icon1';
        break;
      case 'class2':
        this.model.title = '工作任务单';
        this.model.icon = '\uf1da';
        this.model.iconClass += 'icon2';
        break;
      case 'class3':
        this.model.title = '会员消息';
        this.model.icon = '\uf007';
        this.model.iconClass += 'icon3';
        break;
      case 'class4':
        this.model.title = '预约';
        this.model.icon = '\uf128';
        this.model.iconClass += 'icon2';
        break;
      case 'class5':
        this.model.title = '员工消息';
        this.model.icon = '\uf2bc';
        this.model.iconClass += 'icon3';
        break;
      case 'class6':
        this.model.title = '关账通知';
        this.model.icon = '\uf011';
        this.model.iconClass += 'icon1';
        break;
    }
  }

  ngAfterViewInit() {
    this.getMessages(undefined);
  }

  getMessages(refresher: Refresher) {
    this.messageData.getMessages(0, this.model.type).then(
      info => {
        let data: any = info;
        if (refresher != undefined)
          refresher.complete();
        if (data.errcode == 0) {
          this.msgs = data.data;
          this.infiniteEnabled = data.data.length == 20;
        }
        else {
          this.showToast(data.errmsg);
        }
      },
      err => {
        if (refresher != undefined)
          refresher.complete();
        this.showToast();
      }
    )
  }

  delete(msg: Message) {
    if (msg.state != 'unlink')
      this.changeCount();
    this.messageData.deleteMessage([msg.id]).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          let index = this.msgs.indexOf(msg);
          this.msgs.splice(index, 1);
        }
        else {
          this.showToast(data.errmsg);
        }
      },
      err => this.showToast()
    )
  }

  show(item: Message) {
    if (item.state != 'unlink') {
      item.state = 'unlink';
      this.changeCount();
      this.messageData.readMessage([item.id]).then(
        info => { },
        err => this.showToast()
      );
    }
    this.navCtrl.push(MessageDetailPage, item);
  }

  changeCount() {
    this.msgCount[this.model.type] -= 1;
    this.msgCount.count -= 1;
    let count = this.msgCount.count;
    if (count > 99)
      this.msgCount.badge = '99+';
    else if (count > 0)
      this.msgCount.badge = count.toString();
    else
      this.msgCount.badge = '';
  }

  doRefresh(refresher: Refresher) {
    this.getMessages(refresher);
  }

  doInfinite(infiniteScroll: InfiniteScroll) {
    this.messageData.getMessages(this.msgs.length, this.model.type).then(
      (newData) => {
        let data: any = newData;
        if (data.errcode === 0) {
          let newItems: any[] = data.data;
          for (var i = 0; i < newItems.length; i++) {
            this.msgs.push(newItems[i]);
          }
          this.infiniteEnabled = newItems.length == 20;
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
