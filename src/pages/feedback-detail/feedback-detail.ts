import { Component } from '@angular/core';
import { NavParams, NavController, ViewController, FabContainer, ModalController } from 'ionic-angular';
import { SMS } from '@ionic-native/sms';
import { CallNumber } from '@ionic-native/call-number';
import { MemberDetailPage } from '../member-detail/member-detail';
import { FeedbackData } from '../../providers/feedback-data';
import { ReservationAddPage } from '../reservation-add/reservation-add';

@Component({
  selector: 'page-feedback-detail',
  templateUrl: 'feedback-detail.html'
})
export class FeedbackDetailPage {

  fd: { note?: string } = {};
  operate: any;
  feedbacks = [];
  submitted: boolean = false;
  constructor(public navParams: NavParams,
    public viewCtrl: ViewController,
    public navCtrl: NavController,
    public sms:SMS,
    public callNumber:CallNumber,
    public modalCtrl: ModalController,
    public feedbackData: FeedbackData) {
    this.operate = navParams.data;
  }

  ngAfterViewInit() {
    this.load();
  }

  load() {
    this.feedbackData.getFeedbackDetail(this.operate.id).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.feedbacks = data.data;
        } else {
          alert(data.errmsg);
        }
      },
      error => {
        alert(error)
      }
    )
  }

  feedback(form) {
    this.submitted = true;
    if (form.valid && this.fd.note != '') {
      this.feedbackData.addFeedBack(this.fd.note, this.operate.id).then(
        info => {
          let data: any = info;
          if (data.errcode == 0) {
            this.load();
            this.fd.note = '';
            this.viewCtrl.dismiss(data.data);
          } else {
            alert(data.errmsg);
          }
        },
        error => {
        }
      )
    }
  }

  reserve() {
    let item = {
      'member_id': this.operate.member_id,
      'member_name': this.operate.member_name,
      'telephone': this.operate.member_mobile
    }
    let modal = this.modalCtrl.create(ReservationAddPage, item);
    modal.onDidDismiss(data => {
      if (data != undefined) {
        this.viewCtrl.dismiss(data);
      }
    });
    modal.present();
  }

  showMember() {
    let param = {
      'id': this.operate.member_id
    }
    this.navCtrl.push(MemberDetailPage, param);
  }

  call(fab: FabContainer) {
    this.callNumber.callNumber(this.operate.member_mobile, true);
    fab.close();
  }

  message(fab: FabContainer) {
    this.sms.send(this.operate.member_mobile, '', {
      android: {
        intent: 'INTENT'
      },
    });
    fab.close();
  }

  dismiss() {
    this.viewCtrl.dismiss();
  }
}
