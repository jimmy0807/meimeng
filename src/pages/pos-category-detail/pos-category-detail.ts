import { Component } from '@angular/core';
import { NavController, NavParams, ToastController, ViewController, ModalController } from 'ionic-angular';
import { PosCategory, PosCategoryData } from '../../providers/pos-category-data';
import { PosCategoryPage } from '../pos-category/pos-category';

@Component({
  selector: 'page-pos-category-detail',
  templateUrl: 'pos-category-detail.html'
})
export class PosCategoryDetailPage {
  editMode = false;
  title: string;
  cat: PosCategory = {};
  list: PosCategory[];
  constructor(public navCtrl: NavController,
    public navParams: NavParams,
    public modalCtrl: ModalController,
    public viewCtrl: ViewController,
    public toastCtrl: ToastController,
    public categoryData: PosCategoryData) {
    this.list = navParams.data.list;
    this.cat = navParams.data.cat;
    if (this.cat.id > 0) {
      this.editMode = true;
    }
    else {
      this.cat.sequence = 0;
    }
    this.title = this.editMode ? "编辑分类" : "新建分类";
  }

  selectPosCat() {
    let modal = this.modalCtrl.create(PosCategoryPage, { allowEdit: false });
    modal.onDidDismiss(d => {
      if (d !== undefined && d.id > 0) {
        this.cat.parent_id = d.id;
        this.cat.parent_name = d.complete_name;
      }
    });
    modal.present();
  }

  save() {
    if (this.cat.name === undefined || this.cat.name === '') {
      this.showToast("请输入名称");
      return;
    }
    this.categoryData.savePosCategory(this.cat).then(
      info => {
        var data: any = info;
        if (data.errcode == 0) {
          this.cat.id = data.data.id;
          this.cat.complete_name = data.data.complete_name;
          if (!this.editMode) {
            this.list.unshift(this.cat);
          }
          this.dismiss();
        }
        this.showToast(data.errmsg);
      },
      err => {
        this.showToast();
      }
    );
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    return toast.present();
  }

  dismiss() {
    this.viewCtrl.dismiss();
  }
}
