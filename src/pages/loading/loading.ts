import { Component, NgZone } from '@angular/core';
import { ModalController, Events, NavController, AlertController } from 'ionic-angular';
import { StatusBar } from '@ionic-native/status-bar';
import { NativeStorage } from '@ionic-native/native-storage';
import { Device } from '@ionic-native/device';

import { PeferenceData } from '../../providers/reference-data';
import { AppGlobal, AppGroup } from '../../app-global';
import { LoginPage } from '../login/login';
import { TabsPage } from '../tabs/tabs';
import { UserData } from '../../providers/user-data';

declare var cordova: any;

@Component({
  selector: 'page-loading',
  templateUrl: 'loading.html'
})

export class LoadingPage {

  canLogin: boolean = false;
  isCordova = false;
  constructor(
    public statusBar: StatusBar,
    public device: Device,
    public nativeStorage: NativeStorage,
    public navCtrl: NavController,
    public ngZone: NgZone,
    public userData: UserData,
    public alert: AlertController,
    public modalCtrl: ModalController,
    public peferenceData: PeferenceData,
    public events: Events
  ) {
    this.isCordova = AppGlobal.getInstance().isCordova;
  }

  ionViewDidLoad() {
    this.statusBar.hide();
  }

  ionViewDidEnter() {
    this.load();
  }

  load() {
    this.nativeStorage.getItem('ds.reference').then(
      data => {
        if (data.uid != undefined && data.uid > 0
          && data.login != undefined && data.login != "") {
          this.nativeStorage.getItem(data.login).then(
            info => {
              if (info.uid != undefined && info.uid > 0 && info.login != undefined
                && info.login != "" && info.api != undefined && info.api != "") {
                AppGlobal.getInstance().api = info.api;

                this.peferenceData.launch(this.device.uuid).then(info => {

                  let data: any = info;
                  if (data.errcode == 0) {
                    AppGlobal.getInstance().user = data.data.user;
                    AppGlobal.getInstance().zimgServerUrl = data.data.zimg_server_url;
                    AppGlobal.getInstance().userGroup = data.data.user.user_group;
                    AppGlobal.getInstance().appGroup = new AppGroup(data.data.user.app_group);
                    AppGlobal.getInstance().groupMedical = data.data.user.group_medical;
                    AppGlobal.getInstance().sid = data.data.user.sid;
                    AppGlobal.getInstance().shops = data.data.shops;
                    this.events.publish('user:login');
                    let security = cordova.require("cordova-plugin-security.Security");
                    let ident = {
                      'device_mode': this.device.model,
                      'device_uuid': this.device.uuid,
                      'platform': this.device.platform,
                      'version': this.device.version,
                      'latitude': AppGlobal.getInstance().latitude,
                      'longitude': AppGlobal.getInstance().longitude,
                      'login': data.data.user.login,
                      'uid': data.data.user.uid,
                      'url': AppGlobal.getInstance().server,
                      'db': AppGlobal.getInstance().db,
                    }
                    security.deviceRegister(ident, function (info) {
                      console.info(info);
                      AppGlobal.getInstance().user.security_id = info;
                    }, function (error) {
                      console.info(error);
                    });

                    new Promise(resolve => {
                      (<any>window).plugins.jPushPlugin.getRegistrationID(function (info) {
                        console.info(info);
                        resolve(info);
                      });
                    }).then(result => {
                      this.userData.saveToken(result, 'user');
                    });


                    // (<any>window).plugins.jPushPlugin.getRegistrationID().then(res => {
                    //    this.userData.saveToken(res,'user');
                    //  });

                    this.navCtrl.push(TabsPage);

                  } else {
                    this.canLogin = true;
                  }
                })
              } else {
                this.canLogin = true;
              }
            },
            error => {
              this.canLogin = true;
            }
          )
        } else {
          this.canLogin = true;
        }
      },
      error => {
        this.canLogin = true;
      }
    )
  }

  ionViewWillLeave() {
    this.statusBar.show();
  }

  onLogin() {
    this.statusBar.show();
    let modal = this.modalCtrl.create(LoginPage);
    modal.onDidDismiss(data => {
      if (data.isLogin) {
        this.events.publish('user:login');
        this.navCtrl.push(TabsPage);
      }
    });
    modal.present();
  }

  resetPwd() {
    this.navCtrl.push('LoginResetPwdPage');
  }

  onLoginTest() {
    let app = AppGlobal.getInstance();
    app.sid = 3;
    app.api = "http://dev.we-erp.com/V9N00000034";
    app.user = {
      role: '1',
      company_id: 1,
      uid: 1,
      eid: 34,
      ename: '测试',
      ecat: 'designers',
      book_time: 30,
      is_accept_see_partner: true,
    };
    app.groupMedical = true;
    app.appGroup = new AppGroup(null);
    app.userGroup = {
      in_group_55: true,
      in_group_6: true,
      in_group_84: true,
      sel_groups_103_104: '经理',
      sel_groups_110: '查看',
      sel_groups_1_2_3: '设置',
      sel_groups_23_24: '主管',
      sel_groups_47_48: '经理',
      sel_groups_4_104_44_45: '经理',
      sel_groups_52_53_54: '经理',
      sel_groups_94: '查看',
      sel_groups_95_101_96: '管理员',
      sel_groups_99_100: '经理',
      sel_groups_9_34_10: '经理',
    }
    // AppGlobal.getInstance().api="/V9N00000025";
    //AppGlobal.getInstance().user.shop_name='测试';

    this.navCtrl.push(TabsPage);
  }

}
