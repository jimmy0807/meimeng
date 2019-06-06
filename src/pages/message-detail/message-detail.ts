import { Component } from '@angular/core';
import { NavController, NavParams, Refresher, ToastController, InfiniteScroll } from 'ionic-angular';
import { MessageData, Message } from '../../providers/message-data';
import { ReservationPage } from '../reservation/reservation';
import { CommissionPage } from '../commission/commission';
import { MessageMemberPage } from '../message-member/message-member';
import { KpiPage } from '../kpi/kpi';
import { LoadingController } from 'ionic-angular';
import { VisitData } from '../../providers/visit-data';
import { VisitPage } from '../visit/visit';

@Component({
  selector: 'page-message-detail',
  templateUrl: 'message-detail.html'
})
export class MessageDetailPage {
  //reservation,commission,system,quest
  msgs: Message[] = [];
  infiniteEnabled = true;
  mode: string;
  title: string;
  constructor(public navCtrl: NavController,
    public messageData: MessageData,
    public toastCtrl: ToastController,
    public loadingCtrl: LoadingController,
    public visitData: VisitData,
    public navParams: NavParams) {
    this.mode = navParams.data.mode;
    switch (this.mode) {
      case 'reservation': this.title = '预约消息'; break;
      case 'commission': this.title = '提成消息'; break;
      case 'system': this.title = '系统通知'; break;
      case '5': this.title = '会员跟进'; break;
      case '6': this.title = '生日跟进'; break;
      case '9': this.title = '规划跟进'; break;
    }
  }

  ngAfterViewInit() {
    let loader = this.loadingCtrl.create({
      spinner: 'bubbles',
    });
    loader.present();
    this.getMessages(undefined).then(s => loader.dismiss()).catch(err => loader.dismiss());
  }

  getMessages(refresher: Refresher) {
    let cat = '';
    if (Number(this.mode))
      cat = this.mode;
    return this.messageData.getMessages(0, this.mode, cat).then(
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

  doInfinite(infiniteScroll: InfiniteScroll) {
    this.messageData.getMessages(this.msgs.length, this.mode).then(
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

  showCommission() {
    this.navCtrl.push(CommissionPage);
  }

  showReservation() {
    this.navCtrl.push(ReservationPage);
  }

  async showMember(msg: Message) {
    let loader = this.loadingCtrl.create({
      spinner: 'bubbles',
    });
    loader.present();
    try {
      let r = await this.visitData.getVisit(Number(msg.value));
      if (r.errcode == 0)
        this.navCtrl.push(VisitPage, { v: r.data });
      else
        this.navCtrl.push('VisitList');
    } catch (e) {
      this.navCtrl.push('VisitList');
    }
    finally {
      loader.dismiss();
    }
  }

  showBirth() {
    this.navCtrl.push(MessageMemberPage, { mode: 'birth', members: this.navParams.data.members });
  }

  showKpi() {
    this.navCtrl.push(KpiPage, this.navParams.data.kpi);
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
