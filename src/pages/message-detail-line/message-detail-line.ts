import { Component } from '@angular/core';
import { NavController, NavParams, ToastController } from 'ionic-angular';
import { MessageData, Message, MessageCount } from '../../providers/message-data';
import { SchedulePage } from '../schedule/schedule';
import { FollowEmployeePage } from '../follow-employee/follow-employee';
import { KpiMemberPage } from '../kpi-member/kpi-member';
import { AuthorizationPage } from '../authorization/authorization';
import { LoadingController } from 'ionic-angular';

@Component({
  selector: 'page-message-detail-line',
  templateUrl: 'message-detail-line.html'
})
export class MessageDetailLinePage {
  msgs: Message[] = [];
  mode: string;
  infiniteEnabled = true;
  title: string;
  msgLines: Line[] = [];
  msgCount: MessageCount;
  constructor(public navCtrl: NavController,
    public toastCtrl: ToastController,
    public loadingCtrl: LoadingController,
    public messageData: MessageData,
    public navParams: NavParams) {
    this.mode = navParams.data.mode;
    this.msgCount = navParams.data.count;
    switch (this.mode) {
      case '4': this.title = '排班'; break;
      case '7': this.title = '分配指标'; break;
      case '8': this.title = '业绩规划'; break;
      case '10': this.title = '审批'; break;
    }
  }

  ngAfterViewInit() {
    let loader = this.loadingCtrl.create({
      spinner: 'bubbles',
    });
    loader.present();
    this.getMessages().then(s => loader.dismiss()).catch(err => loader.dismiss());
  }

  getMessages() {
    let cat = '';
    if (Number(this.mode))
      cat = this.mode;
    return this.messageData.getMessages(0, this.mode, cat).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.msgs = data.data;
          this.createLines();
          this.infiniteEnabled = data.data.length == 20;
        }
        else {
          this.showToast(data.errmsg);
        }
      },
      err => {
        this.showToast();
      }
    )
  }

  createLines() {
    this.msgLines = this.msgs.map(m => {
      let l: Line = {};
      l.id = m.id;
      l.state = m.state;
      l.time = m.display_date;
      l.readed = m.state === 'unlink';
      l.class = l.readed ? 'p-readed' : '';
      var arr = m.create_date.split(/[- : \/]/);
      let month = Number(arr[1]) + 1;
      switch (this.mode) {
        case '4': l.title = '待排班'; break;
        case '7': l.title = month + '月份指标'; break;
        case '8': l.title = month + '月份业绩规划'; break;
        case '10': l.title = '待审批'; break;
      }
      return l;
    });
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }

  read(line: Line) {
    if (!line.readed) {
      this.messageData.readMessage([line.id]).then(
        info => {
          let data: any = info;
          if (data.errcode == 0) {
            line.state = 'unlink';
            line.readed = true;
            line.class = 'p-readed';
            let key = 'cat' + this.mode;
            let index = this.msgCount[key].indexOf(line.id);
            this.msgCount[key].splice(index, 1);
            if (!this.msgCount[key].length)
              this.msgCount[key] = undefined;
            this.msgCount.count--;
            this.changeCount();
          }
        },
        err => this.showToast());
    }

    switch (this.mode) {
      case '4':
        this.navCtrl.push(SchedulePage);
        break;
      case '7':
        let now = new Date();
        let currentDate = { 'year': now.getFullYear(), 'month': now.getMonth() + 1 };
        this.navCtrl.push(FollowEmployeePage, currentDate);
        break;
      case '8':
        this.navCtrl.push(KpiMemberPage, this.navParams.data.param);
        break;
      case '10':
        this.navCtrl.push(AuthorizationPage);
        break;
    }
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

export interface Line {
  id?: number;
  title?: string,
  state?: string,
  class?: string;
  time?: string,
  readed?: boolean;
}
