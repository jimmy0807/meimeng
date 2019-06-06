import { Component } from '@angular/core';
import { NavController, ModalController, NavParams, InfiniteScroll } from 'ionic-angular';
import { AuthData } from '../../providers/auth-data';
import { LoadingController } from 'ionic-angular';

import { AuthorizationDetailPage } from '../authorization-detail/authorization-detail';

@Component({
  selector: 'page-authorization',
  templateUrl: 'authorization.html'
})

export class AuthorizationPage {

  authorizations = [];

  constructor(
    public navCtrl: NavController,
    public authData: AuthData,
    public loadingCtrl: LoadingController,
    public modalCtrl: ModalController,
    public navParams: NavParams) { }

  ngAfterViewInit() {
    this.getAuthorizationList();
  }

  getAuthorizationList() {
    let loader = this.loadingCtrl.create({
      spinner: 'bubbles',
    });
    loader.present();
    this.authData.getAuthorizationList(0).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.authorizations = data.data;
          console.info(this.authorizations);
        }
      },
      error => {
      }
    ).then(s => loader.dismiss()).catch(err => loader.dismiss())
  }

  doInfinite(infiniteScroll: InfiniteScroll) {

    let lg = 0;
    this.authorizations.forEach(element => {
      lg += element.authorizations.length;
    });

    this.authData.getAuthorizationList(lg).then((newData) => {
      let data: any = newData;
      if (data.errcode === 0) {
        let newData = data.data;
        for (var i = 0; i < newData.length; i++) {
          if (i == 0) {
            let lastTemp = this.authorizations[this.authorizations.length - 1];
            let temp = newData[0];
            if (lastTemp.date === temp.date) {
              for (var j = 0; j < temp.authorizations.length; j++) {
                this.authorizations[this.authorizations.length - 1].authorizations.push(temp.authorizations[j]);
              }
            } else {
              this.authorizations.push(newData[i]);
            }
          } else {
            this.authorizations.push(newData[i]);
          }
        }
        if (newData.length <= 0) {
          infiniteScroll.enable(false);
        }
      }
      infiniteScroll.complete();
    });
  }

  goDetil(authorization) {
    let modal = this.modalCtrl.create(AuthorizationDetailPage, authorization);
    modal.onDidDismiss(data => {
      if (data != undefined) {
        this.getAuthorizationList();
      }
    });
    modal.present();
  }
}
