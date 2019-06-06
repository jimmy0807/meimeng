import { Component } from '@angular/core';
import { NavController, NavParams, ToastController, ViewController } from 'ionic-angular';
import { AppGlobal } from '../../app-global';
import { EmployeeData } from '../../providers/employee-data';
@Component({
  selector: 'page-employee-selector',
  templateUrl: 'employee-selector.html'
})
export class EmployeeSelectorPage {
  title: string;
  mode: string;
  keyword: string = '';
  items = [];
  itemsBak: {
    id?: number,
    name?: string
  }[] = [];
  constructor(public navCtrl: NavController,
    public viewCtrl: ViewController,
    public navParams: NavParams,
    public employeeData: EmployeeData,
    public toastCtrl: ToastController) {
    this.mode = navParams.data.mode;
    if (this.mode == 'shop')
      this.title = '选择门店';
    else
      this.title = '选择收银配置';
  }

  ngAfterViewInit() {
    this.getItems();
  }

  getItems() {
    if (this.mode == 'shop') {
      this.items = AppGlobal.getInstance().shops || [];
      this.itemsBak = this.items;
    }
    else {
      this.employeeData.getPosConfigs().then(
        (newData) => {
          let data: any = newData;
          if (data.errcode === 0) {
            this.items = data.data;
            this.itemsBak = this.items;
          }
          else {
            this.showToast(data.errmsg);
          }
        },
        err => this.showToast());
    }
  }

  onInput(ev) {
    if (this.keyword)
      this.items = this.itemsBak.filter(i => i.name.indexOf(this.keyword) >= 0);
    else
      this.items = this.itemsBak;
  }

  onCancel(ev) {
    this.keyword = '';
  }

  onSelected(item) {
    this.viewCtrl.dismiss(item);
  }

  dismiss() {
    this.viewCtrl.dismiss(false);
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
