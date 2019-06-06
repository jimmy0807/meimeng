import { Component } from '@angular/core';
import { NavController, NavParams, ToastController } from 'ionic-angular';
import { CompanyDetailPage } from '../company-detail/company-detail';
import { CompanyData } from '../../providers/company-data';
import { LoadingController } from 'ionic-angular';

@Component({
  selector: 'page-company',
  templateUrl: 'company.html'
})
export class CompanyPage {

  company = [];
  constructor(public navCtrl: NavController,
    public loadingCtrl: LoadingController,
    public navParams: NavParams,
    private toastCtrl: ToastController,
    public companyData: CompanyData) { }

  ionViewDidLoad() {
    let loader = this.loadingCtrl.create({
      spinner: 'bubbles',
    });
    loader.present();
    this.getCompanyData().then(s => loader.dismiss()).catch(err => loader.dismiss());
  }

  getCompanyData() {
    return this.companyData.getCompanyData().then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.company = data.data;
        } else {
          this.showToastWithCloseButton(data.errmsg);
        }
      },
      err => {
        this.showToastWithCloseButton("系统繁忙");
      }
    );
  }

  companySelected(data) {
    this.navCtrl.push(CompanyDetailPage, data);
  }

  showToastWithCloseButton(errcmsg) {
    const toast = this.toastCtrl.create({
      message: errcmsg,
      duration: 3000
    });
    toast.present();
  }
}
