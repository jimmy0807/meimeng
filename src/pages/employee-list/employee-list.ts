import { Component } from '@angular/core';
import { NavController, NavParams, ToastController, InfiniteScroll, ViewController } from 'ionic-angular';
import { EmployeeData, Employee } from '../../providers/employee-data';
import { EmployeeDetailPage } from '../employee-detail/employee-detail';
import { LoadingController } from 'ionic-angular';

@Component({
  selector: 'page-employee-list',
  templateUrl: 'employee-list.html'
})
export class EmployeeListPage {
  list: Employee[] = [];
  infiniteEnabled = true;
  keyword = '';
  isAdmin = true;
  mode = '';
  cat: string;
  title = '员工';
  constructor(public navCtrl: NavController,
    public toastCtrl: ToastController,
    public loadingCtrl: LoadingController,
    public employeeData: EmployeeData,
    public viewCtrl: ViewController,
    public navParams: NavParams) {
    this.mode = navParams.data.mode;
    this.cat = navParams.data.cat;
    switch (this.cat) {
      case 'doctors': this.title = '医生'; break;
      case 'operater': this.title = '护士'; break;
      case 'designers': this.title = '设计师'; break;
      case 'director': this.title = '设计总监'; break;
      case 'adviser': this.title = '顾问/业务员'; break;
      default: this.cat = null;
    }
  }

  ngAfterViewInit() {
    let loader = this.loadingCtrl.create({
      spinner: 'bubbles',
    });
    loader.present();
    this.getEmployees().then(s => loader.dismiss()).catch(err => loader.dismiss());
  }

  getEmployees(offset: number = 0, key = '') {
    return this.employeeData.getEmployees(offset, key, this.cat).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.list = data.data;
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
    this.getEmployees(0, this.keyword);
  }

  onCancel(ev) {
    this.keyword = '';
  }

  doInfinite(infiniteScroll: InfiniteScroll) {
    this.employeeData.getEmployees(this.list.length, this.keyword, this.cat).then(
      (newData) => {
        let data: any = newData;
        if (data.errcode === 0) {
          let newItems = data.data;
          for (var i = 0; i < newItems.length; i++) {
            this.list.push(newItems[i]);
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

  delete(item) {
    this.employeeData.deleteEmployee(item.id).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          let index = this.list.indexOf(item);
          this.list.splice(index, 1);
        }
        else {
          this.showToast(data.errmsg);
        }
      },
      err => this.showToast());
  }

  add() {
    this.navCtrl.push(EmployeeDetailPage, { list: this.list, employee: { hr_category: this.cat } })
  }

  edit(item) {
    if (this.mode == 'single')
      this.viewCtrl.dismiss(item)
    else
      this.navCtrl.push(EmployeeDetailPage, { list: this.list, employee: item })
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }

  dismiss() {
    this.viewCtrl.dismiss(false);
  }
}
