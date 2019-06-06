import {Component} from '@angular/core';
import {NavController, NavParams, ToastController} from 'ionic-angular';
import {DeviceData} from "../../providers/device-data";
import { AppGlobal } from '../../app-global';
@Component({
  selector: 'page-device-access-detail',
  templateUrl: 'device-access-detail.html'
})
export class DeviceAccessDetailPage {

  device: any;
   user_role:string='';

  constructor(public navCtrl: NavController,
              public navParams: NavParams,
              public deviceData: DeviceData,
              public toastCtrl: ToastController) {
    this.device = navParams.data;
     this.user_role = AppGlobal.getInstance().user.role;
  }

  showToastWithCloseButton(errcmsg) {
    const toast = this.toastCtrl.create({
      message: errcmsg,
      duration: 3000
    });
    toast.present();
  }

  changeState(state) {
    let params = {
      'id': this.device.id,
      'state': state,
    }
    this.deviceData.changeState(params).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.device.state = data.data.state;
          // this.showToastWithCloseButton(this.device.state);
          this.showToastWithCloseButton(data.data.state);
        } else {
          this.showToastWithCloseButton(data.errmsg);
        }
      },
      error => {
          this.showToastWithCloseButton('系统繁忙');
      }
    );
  }


}
