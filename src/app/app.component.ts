import { Component, ViewChild } from '@angular/core';
import { Events, Nav, App, Platform, ToastController, IonicApp, AlertController } from 'ionic-angular';
import { SplashScreen } from '@ionic-native/splash-screen';
import { Network } from '@ionic-native/network';
import { StatusBar } from '@ionic-native/status-bar';
import { Keyboard } from '@ionic-native/keyboard';
import { Device } from '@ionic-native/device';
import { NativeStorage } from '@ionic-native/native-storage';
import { LoadingPage } from '../pages/loading/loading';

import { TutorialPage } from '../pages/tutorial/tutorial';
import { PeferenceData } from '../providers/reference-data';
import { AppGlobal } from '../app-global';

declare var cordova: any;
declare var chcp: any;

@Component({
  templateUrl: 'app.template.html',
})

export class DsApp {

  rootPage: any;
  backButtonPressed: boolean = false;  //用于判断返回键是否触发
  @ViewChild('content') nav: Nav;
  isIos = false;
  constructor(
    public events: Events,
    public platform: Platform,
    public app: App,
    public peferenceData: PeferenceData,
    public splashScreen: SplashScreen,
    public keyboard: Keyboard,
    public statusBar: StatusBar,
    public network: Network,
    public device: Device,
    public nativeStorage: NativeStorage,
    public alertCtrl: AlertController,
    public toastCtrl: ToastController,
    public ionicApp: IonicApp,

  ) {
    platform.ready().then(() => {
      this.registerBackButtonAction();//注册返回按键事件
      setTimeout(() => { splashScreen.hide(); }, 100);
      keyboard.hideKeyboardAccessoryBar(true);
      keyboard.disableScroll(true);

      statusBar.styleDefault();
      statusBar.styleLightContent();

      this.isIos = this.platform.is('ios');
      try {
        window["thisRef"] = this;
        this.fetchUpdate();
      } catch (e) { console.error(e); }

      network.onDisconnect().subscribe(() => {
        AppGlobal.getInstance().isNetworkConnect = false;
      });
      network.onConnect().subscribe(() => {
        AppGlobal.getInstance().isNetworkConnect = true;
      });
      AppGlobal.getInstance().isCordova = this.platform.is('cordova');
      if (AppGlobal.getInstance().isCordova)
        (<any>window).plugins.jPushPlugin.init();

      nativeStorage.getItem('ds.reference').then(
        data => {
          this.rootPage = LoadingPage;
          if (data.uid != undefined && data.uid > 0
            && data.login != undefined && data.login != "") {
            let ident = {
              'device_mode': device.model,
              'device_uuid': device.uuid,
              'platform': device.platform,
              'version': device.version,
              'latitude': AppGlobal.getInstance().latitude,
              'longitude': AppGlobal.getInstance().longitude,
              'login': data.login,
            }
            let security = cordova.require("cordova-plugin-security.Security");
            security.init(ident, function (info) {
              AppGlobal.getInstance().db = info.db;
              AppGlobal.getInstance().server = info.url;
              AppGlobal.getInstance().banners = info.banner;
              AppGlobal.getInstance().api = info.api;
              AppGlobal.getInstance().cuuid = info.cuuid;
              AppGlobal.getInstance().duuid = info.duuid;
              AppGlobal.getInstance().top_api = info.top_api;
              AppGlobal.getInstance().AES_KEY = info.aes_key;
              nativeStorage.setItem('ds.banners', info.banner);
              nativeStorage.setItem(data.login, {
                uid: data.uid, login: data.login,
                url: info.url, db: info.db, api: info.api, cuuid: info.cuuid, duuid: info.duuid,
                top_api:info.top_api, AES_KEY:info.aes_key
              }
              );
            }, function (error) {
              console.debug(error);
            });
          }
        },
        error => {
          this.rootPage = TutorialPage;
          console.debug(error);
        }
      )
    });
    this.listenToLoginEvents();
  }

  fetchUpdate() {
    const options = {
      'config-file': 'http://www.wevip.com/www/chcp.json'
    };
    chcp.fetchUpdate(this.updateCallback, options);
  }

  updateCallback(error, data) {
    if (error) {
      console.error(error);
    }
    else {
      console.log('Update is loaded...');
      if (window["thisRef"].isIos) {
        chcp.installUpdate(error => { });
      }
      else {
        let confirm = window["thisRef"].alertCtrl.create({
          title: '应用更新',
          message: '检查到新版本, 是否更新?',
          buttons: [
            { text: '取消' },
            {
              text: '确定',
              handler: () => {
                chcp.installUpdate(error => {
                  if (error) {
                    console.error(error);
                    window["thisRef"].alertCtrl.create({
                      title: '下载更新',
                      subTitle: `错误 ${error.code}`,
                      buttons: ['确定']
                    }).present();
                  } else {
                    console.log('Update installed...');
                  }
                });
              }
            }
          ]
        });
        confirm.present();
      }
    }
  }

  registerBackButtonAction() {
    this.platform.registerBackButtonAction(() => {
      //如果想点击返回按钮隐藏toast或loading或Overlay就把下面加上
      // this.ionicApp._toastPortal.getActive() || this.ionicApp._loadingPortal.getActive() || this.ionicApp._overlayPortal.getActive()
      let activePortal = this.ionicApp._modalPortal.getActive();
      if (activePortal) {
        activePortal.dismiss();
        return;
      }

      let activeVC = this.nav.getActive();
      let tabs = activeVC.instance.tabs;

      let activeNav = tabs.getSelected();
      return activeNav.canGoBack() ? activeNav.pop() : this.showExit()
    }, 1);
  }

  //双击退出提示框
  showExit() {
    if (this.backButtonPressed) { //当触发标志为true时，即2秒内双击返回按键则退出APP
      this.platform.exitApp();
    } else {
      this.toastCtrl.create({
        message: '再按一次退出应用',
        duration: 2000,
        position: 'top'
      }).present();
      this.backButtonPressed = true;
      setTimeout(() => this.backButtonPressed = false, 2000);//2秒内没有再次点击返回则将触发标志标记为false
    }
  }

  listenToLoginEvents() {
    this.events.subscribe('user:login', () => {
    });
    this.events.subscribe('user:logout', () => {
    });
  }
}
