import { Component } from '@angular/core';
import { NavController, NavParams, ViewController, ToastController } from 'ionic-angular';
import { CompanyData, CompanyLists } from '../../providers/company-data';
import { ShopManagerPage } from '../shop-manager/shop-manager';
import { AppGlobal } from '../../app-global';

@Component({
  selector: 'page-company-detail',
  templateUrl: 'company-detail.html'
})
export class CompanyDetailPage {
  company: CompanyLists = {};
  company_old = {};
  company_json: any;
  is_saved = false;
  is_readonly = true;
  mode = 'view';
  flag_role = false;
  constructor(public viewCtrl: ViewController,
    public navCtrl: NavController,
    public navParams: NavParams,
    private toastCtrl: ToastController,
    public companyData: CompanyData) {
    if (navParams.data) {
      this.company = navParams.data;
    }
  }
  ionViewDidLoad() {
    if (AppGlobal.getInstance().user != undefined) {
      this.flag_role = (AppGlobal.getInstance().user.role == "1");   
    }
    this.info_backup(this.company_old, this.company);
  }
  ionViewWillLeave() {
    if (!this.is_saved) {
      this.info_recover(this.company_old, this.company);
      this.is_saved = false;
    }

  }
  editCompanyData() {
    if (this.mode == 'view')
      this.mode = 'edit';
    else if (this.mode == 'edit')
      this.mode = 'view';
  }

  updateCompanyData() {
    if (this.company.name === "") {
      this.showToastWithCloseButton("公司名不能为空")
      return;
    }

    if (this.mode == 'view')
      this.mode = 'edit';
    else if (this.mode == 'edit')
      this.mode = 'view';

    if (this.info_equal(this.company_old, this.company)) {
      this.showToastWithCloseButton("没有任何改动")
      return;
    }
    this.companyData.updateCompanyData(this.company).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.is_saved = true;
          console.log(data.data.id);
          this.info_backup(this.company_old, this.company);
          //show message
          this.showToastWithCloseButton("保存成功");
        } else {
          //show message
          this.showToastWithCloseButton(data.errmsg);
        }
      },
      err => {
        this.showToastWithCloseButton("系统繁忙");
      }
    )
  }
  gotoShop() {
    this.navCtrl.push(ShopManagerPage);
  }

  // dismiss() {
  //   if (!this.is_saved) {
  //     this.info_recover(this.company_old, this.company);
  //     this.is_saved = false;
  //   }

  //   this.viewCtrl.dismiss();
  // }

  // get Info() {
  //   this.company_json = JSON.stringify(this.company);
  //   //console.log(this.company_json);
  //   return this.company_json;
  // }

  info_backup(data1, data2) {
    for (var name in data2) {
      data1[name] = data2[name];
    }
    console.log(data1);
  }

  info_recover(data1, data2) {
    for (var name in data1) {
      data2[name] = data1[name];
    }
    console.log(data2);
  }

  info_equal(data1, data2) {
    for (var name in data1) {
      if (data2[name] != data1[name])
        return false;
    }
    console.log(data2);
    return true;
  }

  showToastWithCloseButton(errcmsg) {
    const toast = this.toastCtrl.create({
      message: errcmsg,
      duration: 3000
    });
    toast.present();
  }


}
