
import { Component } from '@angular/core';
import { NavController, ViewController, NavParams } from 'ionic-angular';
import { ReservationData } from '../../providers/reservation-data';
import { LoadingController } from 'ionic-angular';

@Component({
  selector: 'page-schedule-employee',
  templateUrl: 'schedule-employee.html'
})
export class ScheduleEmployeePage {
  schedule: any;
  employees = [];
  constructor(
    public navParams: NavParams,
    public loadingCtrl: LoadingController,
    public navCtrl: NavController,
    public reservationData: ReservationData,
    public viewCtrl: ViewController) {
    this.schedule = navParams.data;
  }

  ngAfterViewInit() {
    let loader = this.loadingCtrl.create({
      spinner: 'bubbles',
    });
    loader.present();
    this.getScheduleEmployee().then(s => loader.dismiss()).catch(err => loader.dismiss());
  }

  onConfirm() {
    let selected: any = []
    this.employees.forEach(function (e) {
      if (e.checked) {
        selected.push(e)
      }
      e.checked = false;
    })
    if (selected.length <= 0) {
      return;
    }
    console.info(selected);
    this.viewCtrl.dismiss(selected);
  }

  getScheduleEmployee() {
    let params = {
      'id': this.schedule.id
    }
    return this.reservationData.getScheduleEmployee(params).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.employees = data.data;
        }
      },
      error => {
      }
    )
  }

  dismiss() {
    this.viewCtrl.dismiss();
  }

}
