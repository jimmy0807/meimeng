import { Component } from '@angular/core';
import { InfiniteScroll, PopoverController, Refresher, AlertController, ModalController, NavController } from 'ionic-angular';
import { ReservationAddPage } from '../reservation-add/reservation-add';
import { EmployeePage } from '../employee/employee';
import { ReservationData } from '../../providers/reservation-data';
import { AppGlobal } from '../../app-global';
import { LoadingController } from 'ionic-angular';

@Component({
  selector: 'page-reservation',
  templateUrl: 'reservation.html'
})
export class ReservationPage {

  segment = 'today';
  eid = 0;
  groups = [];
  todayList = [];
  allowAdd = false;

  constructor(
    public navCtrl: NavController,
    public modalCtrl: ModalController,
    public popoverCtrl: PopoverController,
    public loadingCtrl: LoadingController,
    public alertCtrl: AlertController,
    public reservationData: ReservationData) {
    if (AppGlobal.getInstance().user != undefined) {
      this.eid = AppGlobal.getInstance().user.eid;
    }
    let ug = AppGlobal.getInstance().userGroup;
    if (ug)
      this.allowAdd = ['收银员', '经理'].indexOf(ug.sel_groups_52_53_54) >= 0;
  }

  async ngAfterViewInit() {
    let loader = this.loadingCtrl.create({
      spinner: 'bubbles',
    });
    try {
      loader.present();
      await this.getReservations(0, null);
    } finally {
      loader.dismiss();
    }
  }

  async getReservations(offset, refresher: Refresher) {
    try {
      let r = await this.reservationData.getReservations(offset);
      if (r.errcode == 0) {
        this.groups = r.data;
        this.todayList = this.groups.filter(item => item.is_today === true);
      }
    }
    finally {
      if (refresher)
        refresher.complete();
    }
  }

  doInfinite(infiniteScroll: InfiniteScroll) {
    let lg = 0;
    this.groups.forEach(element => {
      lg += element.reservations.length;
    });
    this.reservationData.getReservations(lg).then((newData) => {
      let data: any = newData;
      if (data.errcode === 0) {
        let newData = data.data;
        for (var i = 0; i < newData.length; i++) {

          if (i == 0) {
            let lastTemp = this.groups[this.groups.length - 1];
            let temp = newData[0];
            if (lastTemp.date === temp.date) {
              for (var j = 0; j < temp.reservations.length; j++) {
                this.groups[this.groups.length - 1].reservations.push(temp.reservations[j]);
              }
            } else {
              this.groups.push(newData[i]);
            }
          } else {
            this.groups.push(newData[i]);
          }
        }
        if (newData.length <= 0) {
          infiniteScroll.enable(false);
        }
      }
      infiniteScroll.complete();
    });
  }

  doRefresh(refresher: Refresher) {
    this.getReservations(0, refresher);
  }

  doPulling(refresher: Refresher) {
  }

  updateReservationState(id, state) {
    let data: any = { sid: 1, id: id, state: state }
    this.reservationData.updateReservationState(data).then(
      info => {
        let result: any = info;
        if (result.errcode == 0) {
          this.getReservations(0, undefined);
        } else {
        }
      },
      error => {
      })
  }

  doCancel(reservation) {
    let alert = this.alertCtrl.create({
      title: '取消预约单?',
      message: '您确认要取消该预约单吗?',
      buttons: [
        {
          text: '取消'
        },
        {
          text: '确认',
          handler: () => {
            this.updateReservationState(reservation.id, 'cancel')
          }
        }
      ]
    });
    alert.present();
  }

  doConfirm(reservation) {
    let alert = this.alertCtrl.create({
      title: '确认生效?',
      message: '您确认将该预约单生效吗?',
      buttons: [
        {
          text: '取消'
        },
        {
          text: '确认',
          handler: () => {
            this.updateReservationState(reservation.id, 'approved');
          }
        }
      ]
    });
    alert.present();
  }

  showAllEmployee() {
    let modal = this.modalCtrl.create(EmployeePage);
    modal.present();
  }

  add() {
    let param = {};
    this.navCtrl.push(ReservationAddPage, param)
  }

  showDetail(reservation) {
    this.navCtrl.push(ReservationAddPage, reservation)
  }
}
