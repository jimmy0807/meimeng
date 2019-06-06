import { Component } from '@angular/core';
import { NavController, ToastController, ActionSheetController } from 'ionic-angular';
import { AppGlobal } from '../../app-global';
declare var Wechat: any;
declare var cordova: any;
@Component({
  selector: 'page-community',
  templateUrl: 'community.html'
})

export class CommunityPage {
  banners: any[] = [];
  shows: any[];
  categorys: any[];

  constructor(public navCtrl: NavController,
    public actionSheetCtrl: ActionSheetController,
    public toastCtrl: ToastController) {
  }

  ionViewDidLoad() {
    let allBanners = AppGlobal.getInstance().banners;
    if (allBanners) {
      this.banners = allBanners.filter(function (item) {
        return item.category === 'banner';
      });
      this.shows = allBanners.filter(function (item) {
        return item.category === 'other';
      });
      this.categorys = allBanners.filter(function (item) {
        return item.category === 'category';
      });
    }
  }

  showQrCode(url) {
    let actionSheet = this.actionSheetCtrl.create({
      buttons: [
        {
          text: '好友',
          handler: () => {
            this.toWechat(url, Wechat.Scene.SESSION);
          }
        }, {
          text: '朋友圈',
          handler: () => {
            this.toWechat(url, Wechat.Scene.TIMELINE);
          }
        }, {
          text: '取消',
          role: 'cancel',
        }
      ]
    });
    actionSheet.present();
  }

  toWechat(url, scene) {
    Wechat.isInstalled(
      installed => {
        if (installed) {
          Wechat.share({
            message: {
              title: "分享",
              description: "",
              //thumb: "www/img/mickey.png",
              media: {
                type: Wechat.Type.WEBPAGE,
                webpageUrl: url,
              }
            },
            scene: scene
          },
            success => this.showToast('成功'),
            err => this.showToast(err));
        }
      },
      err => this.showToast(err)
    );
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }




  onBannerClick(item) {
    if (item.link) {
      this.launchNative('browser', item.link);
    }
  }

  launchNative(category, url) {
    var data = {
      'launch_url': AppGlobal.getInstance().server,
      'launch_db': AppGlobal.getInstance().db,
      'launch_cid': AppGlobal.getInstance().user.security_id,
      'launch_category': category,
      'launch_uid': AppGlobal.getInstance().user.uid,
      'launch_sid': AppGlobal.getInstance().sid,
      'launch_mobile': AppGlobal.getInstance().user.login,
      'launch_browser': url
    };

    console.info(data);
    let security = cordova.require("cordova-plugin-security.Security");
    security.launch(data, function (info) {
    }, function (error) {
    });
  }


}
