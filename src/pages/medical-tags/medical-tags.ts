import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, Refresher, InfiniteScroll, LoadingController, AlertController, ToastController } from 'ionic-angular';
import { MedicalData, Item } from '../../providers/medical-data';

@IonicPage()
@Component({
  selector: 'page-medical-tags',
  templateUrl: 'medical-tags.html',
})
export class MedicalTags {
  t: Item;
  keyword = '';
  list: Item[] = [];
  infiniteEnabled = true;
  constructor(public navCtrl: NavController,
    public loadingCtrl: LoadingController,
    public alertCtrl: AlertController,
    public toastCtrl: ToastController,
    public medicalData: MedicalData,
    public navParams: NavParams) { }

  async ngAfterViewInit() {
    let loader = this.loadingCtrl.create({ spinner: 'bubbles' });
    loader.present();
    try {
      await this.getItems();
    }
    finally {
      loader.dismiss();
    }
  }

  async getItems(offset = 0, append = false) {
    try {
      let r = await this.medicalData.getMedicalTags();
      if (r.errcode === 0) {
        let arr = <any[]>r.data;
        this.infiniteEnabled = arr.length === 20;
        if (append) {
          for (var i = 0; i < arr.length; i++) {
            this.list.push(arr[i]);
          }
        }
        else {
          this.list = r.data;
        }
      }
      else {
        this.showToast(r.errmsg);
      }
    } catch (e) {
      this.showToast();
    }
  }

  async doRefresh(refresher: Refresher) {
    try {
      await this.getItems(0);
    }
    finally {
      refresher.complete();
    }
  }

  async onInput(ev) {
    await this.getItems(0);
  }

  onCancel(ev) {
    this.keyword = '';
  }

  async doInfinite(infiniteScroll: InfiniteScroll) {
    try {
      await this.getItems(this.list.length, true);
    }
    finally {
      infiniteScroll.complete();
    }
  }

  edit(i: Item) {
    this.t = i;
    this.saveItem();
  }


  add() {
    this.t = {};
    this.saveItem();
  }

  saveItem() {
    let prompt = this.alertCtrl.create({
      title: '标签名称',
      inputs: [{
        name: 'name',
        placeholder: '请输入',
        value: this.t.name || '',
      }],
      buttons: [{
        text: '取消',
      },
      {
        text: '保存',
        handler: d => {
          if (!d.name)
            return false;
          this.t.name = d.name;
          this.medicalData.saveMedicalTag(this.t).then(
            r => {
              if (r.errcode == 0) {
                if (!this.t.id) {
                  this.t.id = r.data.id;
                  this.list.push(this.t);
                }
              }
              this.showToast(r.errmsg);
            })
        }
      }]
    });
    prompt.present();
  }

  async delete(i: Item) {
    let r = await this.medicalData.deleteMedicalTag(i.id);
    this.showToast(r.errmsg);
    if (r.errcode === 0) {
      let index = this.list.indexOf(i);
      this.list.splice(index, 1);
    }
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}