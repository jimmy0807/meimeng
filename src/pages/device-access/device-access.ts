import { Component } from '@angular/core';
import { NavController, NavParams, InfiniteScroll, ToastController, Refresher } from 'ionic-angular';
import { DeviceAccessDetailPage } from '../device-access-detail/device-access-detail'
import { DeviceData } from "../../providers/device-data";
import { LoadingController } from 'ionic-angular';

@Component({
  selector: 'page-device-access',
  templateUrl: 'device-access.html'
})
export class DeviceAccessPage {
  devices = [];
  sid: number = 0;

  constructor(public navCtrl: NavController,
    public loadingCtrl: LoadingController,
    public navParams: NavParams,
    private toastCtrl: ToastController,
    public deviceData: DeviceData) {
  }

  async ngAfterViewInit() {
    let loader = this.loadingCtrl.create({
      spinner: 'bubbles',
    });
    try {
      loader.present();
      await this.loadDeviceList(0, null)
    }
    finally {
      loader.dismiss();
    }
  }

  ionViewWillEnter() {
    this.loadDeviceList(0, undefined);
  }

  async loadDeviceList(offset, refresher: Refresher) {
    try {
      let r = await this.deviceData.getDeviceList(offset);
      if (r.errcode === 0) {
        this.devices = r.data.list;
      }
      else {
        this.showToast(r.errmsg);
      }
    } catch (e) {
      this.showToast();
    }
    finally {
      if (refresher)
        refresher.complete();
    }
  }

  async delete(i) {
    let r = await this.deviceData.deleteDevice(i.id);
    this.showToast(r.errmsg);
    if (r.errcode === 0) {
      let index = this.devices.indexOf(i);
      this.devices.splice(index, 1);
    }
  }

  async doRefresh(refresher: Refresher) {
    await this.loadDeviceList(0, refresher);
  }

  async doInfinite(infiniteScroll: InfiniteScroll) {
    try {
      let r = await this.deviceData.getDeviceList(this.devices.length);
      if (r.errcode === 0) {
        let newData: any[] = r.data.list;
        for (var i = 0; i < newData.length; i++) {
          this.devices.push(newData[i]);
        }
      } else {
        this.showToast(r.errmsg);
      }
      if (this.devices.length >= r.data.count) {
        infiniteScroll.enable(false);
      }
    }
    finally {
      infiniteScroll.complete();
    }
  }

  showToast(errcmsg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: errcmsg,
      duration: 3000
    });
    toast.present();
  }

  showDetail(item) {
    this.navCtrl.push(DeviceAccessDetailPage, item)
  }
}
