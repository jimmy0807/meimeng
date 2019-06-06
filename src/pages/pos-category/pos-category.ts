import { Component } from '@angular/core';
import { NavController, NavParams, ToastController, ViewController, InfiniteScroll } from 'ionic-angular';
import { PosCategory, PosCategoryData } from '../../providers/pos-category-data';
import { PosCategoryDetailPage } from '../pos-category-detail/pos-category-detail';
import { AppGlobal } from '../../app-global';
import { LoadingController } from 'ionic-angular';

@Component({
  selector: 'page-pos-category',
  templateUrl: 'pos-category.html'
})
export class PosCategoryPage {
  categories: PosCategory[] = [];
  editMode = false;
  manageMode = false;
  isAdmin = false;
  keyword: string = '';
  infiniteEnabled = true;

  constructor(public navCtrl: NavController,
    public navParams: NavParams,
    public categoryData: PosCategoryData,
    public loadingCtrl: LoadingController,
    public toastCtrl: ToastController,
    public viewCtrl: ViewController) {
    let user = AppGlobal.getInstance().user;
    this.isAdmin = true || user != undefined && user.role == '1';
    this.editMode = navParams.data.allowEdit;
    this.manageMode = navParams.data.manageMode;
  }

  ngAfterViewInit() {
    let loader = this.loadingCtrl.create({
      spinner: 'bubbles',
    });
    loader.present();
    this.getCategories().then(s => loader.dismiss()).catch(err => loader.dismiss());
  }

  getCategories(offset: number = 0, key = '') {
    return this.categoryData.getPosCategories(offset, key).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.categories = data.data;
          this.infiniteEnabled = data.data.length == 20;
        }
        else {
          this.showToast(data.errmsg);
        }
      },
      err => {
        this.showToast();
      }
    )
  }

  onInput(ev) {
    this.getCategories(0, this.keyword);
  }

  onCancel(ev) {
    this.keyword = '';
  }

  doInfinite(infiniteScroll: InfiniteScroll) {
    this.categoryData.getPosCategories(this.categories.length, this.keyword).then(
      (newData) => {
        let data: any = newData;
        if (data.errcode === 0) {
          let newItems = data.data;
          for (var i = 0; i < newItems.length; i++) {
            this.categories.push(newItems[i]);
          }
          this.infiniteEnabled = newItems.length == 20;
        }
        else {
          this.showToast(data.errmsg);
        }
        infiniteScroll.complete();
      },
      err => this.showToast());
  }

  onSelected(item) {
    if (this.manageMode && this.editMode)
      this.navCtrl.push(PosCategoryDetailPage, { list: this.categories, cat: item });
    else
      this.viewCtrl.dismiss(item);
  }

  edit(item) {
    this.navCtrl.push(PosCategoryDetailPage, { list: this.categories, cat: item });
  }

  create() {
    this.navCtrl.push(PosCategoryDetailPage, { list: this.categories, cat: {} });
  }

  delete(item) {
    this.categoryData.deletePosCategory(item.id).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          let index = this.categories.indexOf(item);
          this.categories.splice(index, 1);
        }
        else {
          this.showToast(data.errmsg);
        }
      },
      err => this.showToast());
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }

  dismiss() {
    this.viewCtrl.dismiss();
  }
}
