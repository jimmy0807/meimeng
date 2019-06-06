import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, LoadingController, AlertController } from 'ionic-angular';
import { EventData, Event } from '../../providers/event-data';
import { BarcodeScanner } from '@ionic-native/barcode-scanner';

@IonicPage()
@Component({
  selector: 'page-event-sign',
  templateUrl: 'event-sign.html',
})
export class EventSignPage {
  event: Event = {};
  code: string = '';
  loading = false;
  constructor(public navCtrl: NavController,
    public barcodeScanner: BarcodeScanner,
    public loadingCtrl: LoadingController,
    public alertCtrl: AlertController,
    public eventData: EventData,
    public navParams: NavParams) {
    this.event = navParams.data;
  }

  async ngAfterViewInit() {
    let r = await this.eventData.getEvent(this.event.id);
    if (r.errcode === 0) {
      let e: Event = r.data;
      this.event.total_attendee = e.total_attendee;
      this.event.count = e.count;
    };
  }

  show() {
    this.navCtrl.push('EventRecordPage', this.event);
  }

  async sign() {
    if (!this.code)
      return;
    let l = this.loadingCtrl.create({ spinner: 'bubbles' });
    l.present();
    try {
      let r = await this.eventData.eventSign(this.event.id, this.code);
      await this.presentAlert(r.errmsg);
      if (r.errcode === 200) {
        this.code = '';
        this.event.count = r.data.count;
      }
    }
    catch (e) {

    }
    finally {
      l.dismiss();
    }
  }

  async scan() {
    if (this.loading)
      return;
    try {
      this.loading = true;
      let r = await this.barcodeScanner.scan();
      this.code = r.text;
      this.sign();
    }
    catch (e) {
      this.presentAlert(e);
    }
    finally {
      this.loading = false;
    }
  }

  async presentAlert(msg: string) {
    let alert = this.alertCtrl.create({
      title: msg,
      buttons: ['确定']
    });
    await alert.present();
  }
}
