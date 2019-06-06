import { Component } from '@angular/core';
import { NavParams, NavController, ViewController } from 'ionic-angular';
import { ReservationData, Time } from '../../providers/reservation-data';

@Component({
  selector: 'page-reservation-time',
  templateUrl: 'reservation-time.html',

})
export class ReservationTimePage {
  times: TimeSpan[] = [];

  constructor(
    public navParams: NavParams,
    public navCtrl: NavController,
    public viewCtrl: ViewController,
    public reservationData: ReservationData, ) {

    for (var i = 8; i < 24; i++) {
      for (var j = 0; j < 60; j += 15) {
        this.times.push({
          active: true,
          time: `${this.padLeft(i)}:${this.padLeft(j)}`
        })
      }
    }
    let date = navParams.data.date;
    let time = this.getTimeStr(new Date());
    let now = this.getDateStr(new Date());
    if (date == now) {
      for (var i = 0; i < this.times.length; i++) {
        if (this.times[i].time < time)
          this.times[i].active = false;
        else
          break;
      }
    }
    else if (date < now) {
      for (var i = 0; i < this.times.length; i++) {
        this.times[i].active = false;
      }
    }

    this.checkTimes(navParams.data.times);
  }

  checkTimes(ts: Time[]) {
    if (ts && ts.length) {
      let t: Time;
      let si = 0;
      let ei = 0;
      for (var i = 0; i < ts.length; i++) {
        t = ts[i];
        si = this.getFirst(t);
        ei = this.getLast(t);
        for (var i = si; i < ei; i++) {
          this.times[i].active = false;
        }
      }
    }
  }

  getTimeStr(d: Date) {
    return `${this.padLeft(d.getHours())}:${this.padLeft(d.getMinutes())}`;
  }

  getDateStr(d: Date) {
    return `${d.getFullYear()}-${this.padLeft(d.getMonth() + 1)}-${this.padLeft(d.getDate())}`;
  }

  getFirst(t: Time) {
    if (t.start < this.times[0].time)
      return 0;
    let hm = t.start.split(':');
    return Math.floor((Number(hm[0]) - 8) * 4 + Number(hm[1]) / 15);
  }

  getLast(t: Time) {
    if (t.end < this.times[0].time)
      return 0;
    let hm = t.end.split(':');
    return Math.ceil((Number(hm[0]) - 8) * 4 + Number(hm[1]) / 15);
  }

  padLeft(num) {
    if (num < 10)
      return '0' + String(num);
    return String(num);
  }

  tapped(t: TimeSpan) {
    if (t.active)
      this.viewCtrl.dismiss(t.time);
  }

  close() {
    this.viewCtrl.dismiss();
  }
}

export interface TimeSpan {
  time?: string;
  active?: boolean;
}