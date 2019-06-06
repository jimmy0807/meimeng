import { Component } from '@angular/core';
import { NavController, NavParams, ActionSheetController, Refresher, InfiniteScroll, ToastController } from 'ionic-angular';
import { Sms, SmsData } from '../../providers/sms-data';
import { SmsSelectorPage } from '../sms-selector/sms-selector';
import { SmsDetailPage } from '../sms-detail/sms-detail';
import { SmsConfigPage } from '../sms-config/sms-config';
import { SmsTemplateListPage } from '../sms-template-list/sms-template-list';
import { SmsCategoryPage } from '../sms-category/sms-category';
import { LoadingController } from 'ionic-angular';

@Component({
  selector: 'page-sms-index',
  templateUrl: 'sms-index.html'
})
export class SmsIndexPage {
  list: Sms[] = [];
  people: {
    members?: any[],
    employees?: any[],
    msg?: string
  } = {};
  infiniteEnabled = true;
  constructor(public navCtrl: NavController,
    public asCtrl: ActionSheetController,
    public loadingCtrl: LoadingController,
    public toastCtrl: ToastController,
    public smsData: SmsData,
    public navParams: NavParams) { }

  ngAfterViewInit() {
    let loader = this.loadingCtrl.create({
      spinner: 'bubbles',
    });
    loader.present();
    this.getSmsList().then(s => loader.dismiss()).catch(err => loader.dismiss());
    this.getBirth();
  }

  getBirth() {
    this.smsData.getAllBirthday()
      .then(r => {
        if (r.errcode == 0) {
          this.people = r.data;
          let strs: string[] = [];
          if (this.people.members.length)
            strs.push(this.people.members.length + "位会员");
          if (this.people.employees.length)
            strs.push(this.people.employees.length + "位员工");
          this.people.msg = strs.join("，");
        }
        else
          this.showToast(r.errmsg);
      })
      .catch(() => this.showToast());
  }

  getSmsList(offset = 0, refresher: Refresher = null) {
    return this.smsData.getSmsList(offset).then(
      (newData) => {
        if (refresher)
          refresher.complete();
        let data: any = newData;
        if (data.errcode === 0) {
          this.list = data.data;
          this.infiniteEnabled = data.data.length == 20;
        }
        else {
          this.showToast(data.errmsg);
        }
      },
      err => {
        if (refresher)
          refresher.complete();
        this.showToast()
      });
  }

  doRefresh(refresher: Refresher) {
    this.getSmsList(0, refresher);
  }

  doInfinite(infiniteScroll: InfiniteScroll) {
    this.smsData.getSmsList(this.list.length).then(
      (newData) => {
        let data: any = newData;
        if (data.errcode === 0) {
          let newItems = data.data;
          for (var i = 0; i < newItems.length; i++) {
            this.list.push(newItems[i]);
          }
          this.infiniteEnabled = data.data.length == 20;
        }
        else {
          this.showToast(data.errmsg);
        }
        infiniteScroll.complete();
      },
      err => {
        infiniteScroll.complete();
        this.showToast()
      });
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }

  more() {
    let actionSheet = this.asCtrl.create({
      buttons: [{
        text: "短信模板",
        handler: () => { this.navCtrl.push(SmsTemplateListPage) }
      },
      {
        text: "短信配置",
        handler: () => { this.navCtrl.push(SmsConfigPage) }
      },
      {
        text: "短信分类",
        handler: () => { this.navCtrl.push(SmsCategoryPage) }
      },
      {
        text: '取消',
        role: 'cancel',
      }]
    });
    actionSheet.present();
  }

  create() {
    this.navCtrl.push(SmsSelectorPage, { mode: 'all', people: {} });
  }

  birth() {
    this.navCtrl.push(SmsSelectorPage, { mode: 'birth', people: this.people });
  }

  show(item) {
    this.navCtrl.push(SmsDetailPage, item);
  }
}
