import { Component } from '@angular/core';
import { NavController, NavParams, ToastController, AlertController } from 'ionic-angular';
import { SmsData } from '../../providers/sms-data';
import { LoadingController } from 'ionic-angular';

@Component({
  selector: 'page-sms-category',
  templateUrl: 'sms-category.html'
})
export class SmsCategoryPage {
  cats: {
    id?: number,
    name?: string,
  }[] = [];

  constructor(public navCtrl: NavController,
    public smsData: SmsData,
    public loadingCtrl: LoadingController,
    public alertCtrl: AlertController,
    public toastCtrl: ToastController,
    public navParams: NavParams) { }

  ngAfterViewInit() {
    let loader = this.loadingCtrl.create({
      spinner: 'bubbles',
    });
    loader.present();
    this.smsData.getSmsTemplateCategoryList().then(
      info => {
        let data: any = info;
        if (data.errcode == 0)
          this.cats = data.data;
        else
          this.showToast(data.errmsg);
      },
      err => this.showToast())
      .then(s => loader.dismiss()).catch(err => loader.dismiss());
  }

  add() {
    let prompt = this.alertCtrl.create({
      title: '分类名称',
      inputs: [{
        name: 'name',
        placeholder: '请输入',
      }],
      buttons: [{
        text: '取消',
      },
      {
        text: '保存',
        handler: data => {
          if (!data.name)
            return false;
          this.smsData.saveSmsCategory(data).then(
            info => {
              let r: any = info;
              if (r.errcode == 0) {
                data.id = r.data.id;
                this.cats.push(data);
              }
              this.showToast(r.errmsg);
            },
            err => this.showToast());
        }
      }]
    });
    prompt.present();
  }

  delete(cat) {
    this.smsData.deleteSmsCategory(cat.id).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          let index = this.cats.indexOf(cat);
          this.cats.splice(index, 1);
        }
        this.showToast(data.errmsg);
      },
      err => this.showToast());
  }

  edit(cat) {
    let prompt = this.alertCtrl.create({
      title: '分类名称',
      inputs: [{
        name: 'name',
        placeholder: '请输入',
        value: cat.name,
      }],
      buttons: [{
        text: '取消',
      },
      {
        text: '保存',
        handler: data => {
          if (!data.name)
            return false;
          data.id = cat.id;
          this.smsData.saveSmsCategory(data).then(
            info => {
              let r: any = info;
              if (r.errcode == 0) {
                cat.name = data.name;
              }
              this.showToast(r.errmsg);
            },
            err => this.showToast());
        }
      }]
    });
    prompt.present();
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
