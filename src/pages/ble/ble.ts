import { Component } from '@angular/core';
import { NavController, AlertController } from 'ionic-angular';
import { BLE } from '@ionic-native/ble';

@Component({
  selector: 'page-ble',
  templateUrl: 'ble.html'
})
export class BlePage {

  blf: { username?: string, password?: string } = {};
  item: any;
  connect: boolean = false;
  constructor(public navCtrl: NavController,
  public ble:BLE,
  public alertCtrl: AlertController,) { }

  ngAfterViewInit() {
    this.startScan();
  }

  ionViewDidLeave() {
    if (this.item) {
      this.ble.disconnect(this.item.id);
    }
  }

  startScan() {
    this.ble.startScan([]).subscribe(device => {
      if (device.advertising) {
        console.info(device.advertising);


        if (device.advertising.kCBAdvDataLocalName != undefined
          && device.advertising.kCBAdvDataLocalName == 'ble_wifi_service') {
          this.item = device;

          this.onConect();
          this.ble.stopScan();

        }
      }
    });
  }

  onConect() {
    this.ble.connect(this.item.id).subscribe(
      info => {
        console.info('onConectonConect');
        console.info(info);
        this.connect = true;

      },
      error => {
        console.info('onConectonConerrorerrorerrorect');
        console.info(error);
        this.connect = false;
      });
  }

  onWrite() {
    if (this.blf.username == '' || this.blf.password == '') {
      return false;
    }
    if (this.item) {
      this.startNotification();
      this.ble.write(this.item.id, 'EC00', 'EC0E', this.stringToBytes('reset wifi')).then(
        info => {
          this.ble.write(this.item.id, 'EC00', 'EC0E', this.stringToBytes(this.blf.username)).then(
            info => {
              console.info(info);
              this.ble.write(this.item.id, 'EC00', 'EC0E', this.stringToBytes(this.blf.password)).then(
                info => {
                  console.info(info);
                },
                error => {
                  console.info(error)
                });
            },
            error => {
              console.info(error)
            });
        },
        error => {

        });
    }
  }

  startNotification() {
    this.ble.startNotification(this.item.id, 'EC00', 'EC0E').subscribe(
      info => {
        let alert = this.alertCtrl.create({
          title: '绑定成功!',
          subTitle: '无线打印机蓝牙绑定成功',
          buttons: ['确认']
        });
        alert.present();
        //var data = new Uint8Array(info);
      },
      error => {
       // var data = new Uint8Array(error);
      });
  }
  stringToBytes(string) {
    var array = new Uint8Array(string.length);
    for (var i = 0, l = string.length; i < l; i++) {
      array[i] = string.charCodeAt(i);
    }
    return array.buffer;
  }
}
