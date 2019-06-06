import { Component } from '@angular/core';
import { NavController, NavParams, ModalController } from 'ionic-angular';
import { ScheduleEmployeePage } from '../schedule-employee/schedule-employee';
import { ReservationData } from '../../providers/reservation-data';
import { LoadingController } from 'ionic-angular';

@Component({
  selector: 'page-schedule',
  templateUrl: 'schedule.html'
})
export class SchedulePage {

  seleted: any = new Date();
  month: Array<number>;
  current: Date;
  today: Date;
  wHeadShort: string[] = ['日', '一', '二', '三', '四', '五', '六'];
  reservations = [];
  currentDate: any;
  employee: any;
  currentTime: any;
  schedules = [];

  constructor(
    public navCtrl: NavController,
    public reservationData: ReservationData,
    public loadingCtrl: LoadingController,
    public modalCtrl: ModalController,
    public navParams: NavParams) {

    this.today = new Date();
    this.current = new Date();
    this.current.setTime(this.today.getTime());
    this.monthRender(this.today.toISOString());
    this.selectDate(this.today);
  }

  ionViewDidLoad() {
  }

  ngAfterViewInit() {
    let currentDate = this.today.toISOString().substring(0, 10);
    console.info(currentDate);
    let loader = this.loadingCtrl.create({
      spinner: 'bubbles',
    });
    loader.present();
    this.getScheduleEmployee(currentDate).then(s => loader.dismiss()).catch(err => loader.dismiss());
  }

  getScheduleEmployee(schedule_date) {
    return this.reservationData.getSchedule(schedule_date).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.schedules = data.data;
        }
      },
      error => {
      }
    )
  }

  deleteScheduleEmployee(schedule, emoloyee) {
    let params = {
      'line_id': schedule.id,
      'id': emoloyee.id,
    }
    this.reservationData.deleteScheduleEmployee(params).then(
      info => {
        let currentDate = this.seleted.toISOString().substring(0, 10);
        this.getScheduleEmployee(currentDate);
      },
      error => {
      }
    )
  }

  monthRender(date: string) {
    var month = new Array();
    var firstDay = new Date(date);
    firstDay.setDate(1);
    var firstDayNextMonth = new Date(date);

    if (firstDay.getMonth() < 11) {
      firstDayNextMonth.setMonth(firstDay.getMonth() + 1);
      firstDayNextMonth.setDate(1);
    } else {
      firstDayNextMonth.setMonth(1);
      firstDayNextMonth.setDate(1);
    }
    var lastDay = new Date(date);
    lastDay.setTime(firstDayNextMonth.getTime() - (1 * 24 * 3600000));
    var iw = firstDay.getDay();
    var dayCount = 0;
    // build week in month
    for (let i = 0; i <= 5; i++) {
      var weekDay = new Array();
      for (var j = 0; j <= 6; j++) {
        if (i === 0 && j < iw) {
          // previous month date
          var day = new Date();
          day.setTime(firstDay.getTime() - ((iw - j) * 24 * 3600000));
          weekDay.push(this.putEvents(day));
        } else {
          if (dayCount < lastDay.getDate()) {
            var day = new Date();
            day.setTime(firstDay.getTime() + (dayCount * 24 * 3600000));
            weekDay.push(this.putEvents(day));
            dayCount++;
          } else {
            // next month date
            dayCount++;
            var day = new Date();
            day.setTime(lastDay.getTime() + ((dayCount - lastDay.getDate()) * 24 * 3600000));
            weekDay.push(this.putEvents(day));
          }
        }
      }
      month.push(weekDay);
    }
    this.month = month;
  }

  putEvents(day: Date) {
    let hasEvents = false;
    let data: any = { 'date': day, 'events': hasEvents };
    return data;
  }


  previousMonth() {
    let previous = this.current;
    let currentMonth = this.current.getMonth();
    if (currentMonth >= 1) {
      previous.setMonth(currentMonth - 1);
    } else {
      previous.setMonth(11);
      previous.setFullYear(this.current.getFullYear() - 1);
    }
    this.current = new Date();
    this.current.setTime(previous.getTime());
    this.monthRender(this.current.toISOString());

    let firstDay = this.current;
    firstDay.setDate(1);
    var firstDayNextMonth = new Date(firstDay);
    this.selectDate(firstDayNextMonth);
  }

  nextMonth() {
    let next = this.current;
    let currentMonth = this.current.getMonth();
    if (currentMonth <= 11) {
      next.setMonth(currentMonth + 1);
    } else {
      next.setMonth(1);
      next.setFullYear(this.current.getFullYear() + 1);
    }
    this.current = new Date();
    this.current.setTime(next.getTime());
    this.monthRender(this.current.toISOString());

    let firstDay = this.current;
    firstDay.setDate(1);
    var firstDayNextMonth = new Date(firstDay);
    this.selectDate(firstDayNextMonth);

  }

  selectDate(data) {
    this.seleted = data;
    this.currentDate = this.seleted.toISOString().substring(0, 10);
    this.getScheduleEmployee(this.currentDate);
  }

  onSelectEmployee(schedule) {

    console.info(schedule);
    let modal = this.modalCtrl.create(ScheduleEmployeePage, schedule);
    modal.onDidDismiss(data => {
      if (data != undefined) {
        console.info(data);
        let ids = [];
        data.forEach(function (e) {
          ids.push(e.id);
        })
        let params = {
          'line_id': schedule.id,
          'employees': ids.join()
        }
        console.info(params);
        this.reservationData.updateScheduleEmployee(params).then(
          info => {
            let currentDate = this.seleted.toISOString().substring(0, 10);
            this.getScheduleEmployee(currentDate);
          },
          error => {
          }
        )
      }
    });
    modal.present();
  }

}
