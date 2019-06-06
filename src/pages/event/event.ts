import { Component, AfterViewInit } from '@angular/core';
import { IonicPage, NavController, NavParams, LoadingController, ToastController, Refresher, InfiniteScroll } from 'ionic-angular';
import { EventData, Event } from '../../providers/event-data';

@IonicPage()
@Component({
  selector: 'page-event',
  templateUrl: 'event.html',
})
export class EventPage implements AfterViewInit {
  list: Event[] = [];
  infiniteEnabled = true;

  constructor(public navCtrl: NavController,
    public eventData: EventData,
    public loadingCtrl: LoadingController,
    public toastCtrl: ToastController,
    public navParams: NavParams) {
  }

  async ngAfterViewInit() {
    let loader = this.loadingCtrl.create({ spinner: 'bubbles' });
    loader.present();
    try {
      await this.getItems();
    }
    finally {
      loader.dismiss();
    }
  }

  async getItems(offset = 0, append = false) {
    try {
      let r = await this.eventData.getEventList(offset);
      if (r.errcode === 0) {
        let arr = <any[]>r.data;
        this.infiniteEnabled = arr.length === 20;
        if (append) {
          for (var i = 0; i < arr.length; i++) {
            this.list.push(arr[i]);
          }
        }
        else {
          this.list = r.data;
        }
      }
      else {
        this.showToast(r.errmsg);
      }
    } catch (e) {
      this.showToast();
    }
  }

  async doRefresh(refresher: Refresher) {
    try {
      await this.getItems(0);
    }
    finally {
      refresher.complete();
    }
  }

  async doInfinite(infiniteScroll: InfiniteScroll) {
    try {
      await this.getItems(this.list.length, true);
    }
    finally {
      infiniteScroll.complete();
    }
  }

  sign(e: Event) {
    if (e.state == 'done')
      return;
    this.navCtrl.push('EventSignPage', e);
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
