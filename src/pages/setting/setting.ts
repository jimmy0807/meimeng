import { Component } from '@angular/core';
import { NavController, App, Events } from 'ionic-angular';
import { NativeStorage } from '@ionic-native/native-storage';
import { LoadingPage } from '../loading/loading';

import { UserData } from '../../providers/user-data';
declare var cordova: any;
@Component({
  selector: 'page-setting',
  templateUrl: 'setting.html'
})


export class SettingPage {


  id: any = '';
  constructor(
    public navCtrl: NavController,
    public nativeStorage:NativeStorage,
    public events: Events,
    public app: App,
    public userData: UserData) { }

  onLogout() {
    this.userData.logout().then(
      data => {
        this.nativeStorage.getItem('ds.reference').then(
          info => {
            info.uid = 0
            this.nativeStorage.setItem('ds.reference', info);
            this.app.getRootNav().setRoot(LoadingPage);
          }
        )
      },
      error => { }
    )
  }
}
