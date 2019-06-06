import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, LoadingController, ToastController, Refresher, InfiniteScroll } from 'ionic-angular';
import { EventData } from '../../providers/event-data';

@IonicPage()
@Component({
  selector: 'page-event-record',
  templateUrl: 'event-record.html',
})
export class EventRecordPage {
  segment = 'sign';
  list = [];
  list2 = [];
  infiniteEnabled = true;
  infiniteEnabled2 = true;
  id: number;
  constructor(public navCtrl: NavController,
    public eventData: EventData,
    public loadingCtrl: LoadingController,
    public toastCtrl: ToastController, public navParams: NavParams) {
    this.id = navParams.data.id;
  }

  async ngAfterViewInit() {
    let loader = this.loadingCtrl.create({ spinner: 'bubbles' });
    loader.present();
    try {
      await this.getItems();
      await this.getItems2();
    }
    finally {
      loader.dismiss();
    }
  }

  async getItems(offset = 0, append = false) {
    try {
      let r = await this.eventData.getEventRecord(this.id, offset);
      if (r.errcode === 200) {
        let arr = <any[]>r.data.attendees;
        this.infiniteEnabled = arr.length === 80;
        if (append) {
          for (var i = 0; i < arr.length; i++) {
            this.list.push(arr[i]);
          }
        }
        else {
          this.list = arr;
        }
      }
      else {
        this.showToast(r.errmsg);
      }
    } catch (e) {
      this.showToast();
    }
  }

  async getItems2(offset = 0, append = false) {
    try {
      let r = await this.eventData.getEventRecord(this.id, offset, 'buy');
      if (r.errcode === 200) {
        let arr = <any[]>r.data.attendees;
        this.infiniteEnabled2 = arr.length === 80;
        if (append) {
          for (var i = 0; i < arr.length; i++) {
            this.list2.push(arr[i]);
          }
        }
        else {
          this.list2 = arr;
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
      await this.getItems();
      await this.getItems2();
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

  async doInfinite2(infiniteScroll: InfiniteScroll) {
    try {
      await this.getItems2(this.list2.length, true);
    }
    finally {
      infiniteScroll.complete();
    }
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
