import { Component } from '@angular/core';
import { NavController, NavParams } from 'ionic-angular';
import { HomeData } from '../../providers/home-data';
import { LoadingController } from 'ionic-angular';

@Component({
  selector: 'page-room',
  templateUrl: 'room.html'
})
export class RoomPage {

  rooms = [];
  constructor(
    public navCtrl: NavController,
    public loadingCtrl: LoadingController,
    public homeData: HomeData,
    public navParams: NavParams) { }

  ngAfterViewInit() {
    let loader = this.loadingCtrl.create({
      spinner: 'bubbles',
    });
    loader.present();
    this.getRooms().then(s => loader.dismiss()).catch(err => loader.dismiss());
  }

  getRooms() {
    return this.homeData.getRooms().then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.rooms = data.data;
        }
      }
    )
  }
}
