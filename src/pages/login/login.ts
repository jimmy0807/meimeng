import { Component } from '@angular/core';
import { Platform, ModalController, LoadingController, AlertController, NavParams, NavController, ViewController } from 'ionic-angular';
import { Device } from '@ionic-native/device';
import { NativeStorage } from '@ionic-native/native-storage';
import { PeferenceData } from '../../providers/reference-data';
import { UserData } from '../../providers/user-data';
import { AppGlobal, AppGroup } from '../../app-global';

declare var cordova: any;

@Component({
  selector: 'page-login',
  templateUrl: 'login.html'
})

export class LoginPage {

  submitted = false;
  login: { username?: string, password?: string } = {};
  security = cordova.require("cordova-plugin-security.Security");

  constructor(
    public platform: Platform,
    public Device: Device,
    public NativeStorage: NativeStorage,
    public loadingCtrl: LoadingController,
    public params: NavParams,
    public viewCtrl: ViewController,
    public modalCtrl: ModalController,
    public navCtrl: NavController,
    public alertCtrl: AlertController,
    public userData: UserData,
    public peferenceData: PeferenceData
  ) {
  }

  ionViewDidEnter() {
    this.NativeStorage.getItem('ds.reference').then(
      info => {
        if (info.login != undefined) {
          this.login.username = info.login;
        }
      },
      error => { },
    )
  }

  onLogin(form) {

    this.submitted = true;
    if (form.valid) {
      this.onLunch(this.login.username);
    }
  }

  onLunch(login) {
    let ident = {
      'device_mode': this.Device.model,
      'device_uuid': this.Device.uuid,
      'platform': this.Device.platform,
      'version': this.Device.version,
      'latitude': AppGlobal.getInstance().latitude,
      'longitude': AppGlobal.getInstance().longitude,
      'login': login,
    }

    new Promise(resolve => {
      this.security.init(ident, function (info) {
        resolve(info);
      }, function (error) {
        resolve(error);
      })
    }).then(
      result => {
        let info: any = result;
        if (typeof info === 'string') {
          let alert = this.alertCtrl.create({
            title: '登录失败!',
            subTitle: info,
            buttons: ['确认']
          });
          alert.present();
        } else {
          AppGlobal.getInstance().db = info.db;
          AppGlobal.getInstance().server = info.url;
          AppGlobal.getInstance().banners = info.banner;
          AppGlobal.getInstance().api = info.api;
          AppGlobal.getInstance().cuuid = info.cuuid;
          AppGlobal.getInstance().duuid = info.duuid;
          AppGlobal.getInstance().top_api = info.top_api;
          AppGlobal.getInstance().AES_KEY = info.aes_key;
          this.NativeStorage.setItem('ds.banners', info.banner);
          this.NativeStorage.setItem(login, { uid: 0, login: login, url: info.url, db: info.db, api: info.api ,
            cuuid: info.cuuid, duuid: info.duuid, top_api:info.top_api, AES_KEY:info.aes_key});
          this.dologin();
        }
      },
      error => {
        let alert = this.alertCtrl.create({
          title: '登录失败!',
          subTitle: error,
          buttons: ['确认']
        });
        alert.present();
      })
  }

  dologin() {
    let data = {
      device: this.Device.uuid,
      login: this.login.username,
      password: this.login.password,
    }
    new Promise(resolve => {
      this.security.signCommon(data, function (info) {
        resolve(info);
      }, function (error) {
        resolve(error);
      })
    }).then(
      info => {

        if (typeof info === 'string') {
          let alert = this.alertCtrl.create({
            title: '登录失败!',
            subTitle: info,
            buttons: ['确认']
          });
          alert.present();
        } else {


          this.userData.login(info).then(
            res => {
              let result: any = res;
              if (result.errcode != 0) {
                let alert = this.alertCtrl.create({
                  title: '登录失败!',
                  subTitle: result.errmsg,
                  buttons: ['确认']
                });
                alert.present();
              } else {
                this.NativeStorage.getItem(this.login.username).then(
                  info => {
                    info.uid = result.data.user.uid;
                    info.login = result.data.user.login;
                    this.NativeStorage.setItem(this.login.username, info);
                  }
                )
                let reference = { uid: result.data.user.uid, login: result.data.user.login }
                this.NativeStorage.setItem('ds.reference', reference);
                AppGlobal.getInstance().user = result.data.user;
                AppGlobal.getInstance().zimgServerUrl = result.data.zimg_server_url;
                AppGlobal.getInstance().groupMedical = result.data.user.group_medical;
                AppGlobal.getInstance().userGroup = result.data.user.user_group;
                AppGlobal.getInstance().appGroup = new AppGroup(result.data.user.app_group);
                AppGlobal.getInstance().sid = result.data.user.sid;
                AppGlobal.getInstance().shops = result.data.shops;

                // JPush.getRegistrationID().then(res => {
                //   this.userData.saveToken(res,'user');
                // });
                this.dismiss(true);
              }
            },
            error => {
              let alert = this.alertCtrl.create({
                title: '登录失败!',
                subTitle: "身份认证失败请稍后重试",
                buttons: ['确认']
              });
              alert.present();
            }
          )
        }
      });
  }

  resetPwd() {
    this.navCtrl.push('LoginResetPwdPage');
  }

  dismiss(isLogin) {
    let data = { 'isLogin': isLogin };
    this.viewCtrl.dismiss(data);
  }
}
