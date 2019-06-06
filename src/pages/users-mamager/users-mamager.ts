import { Component } from '@angular/core';
import { NavController, NavParams, Refresher, InfiniteScroll, ToastController } from 'ionic-angular';
import { UsersMamagerDetailPage } from '../users-mamager-detail/users-mamager-detail';
import { ConsumerData } from '../../providers/consumer-data';
import { LoadingController } from 'ionic-angular';

@Component({
  selector: 'page-users-mamager',
  templateUrl: 'users-mamager.html'
})
export class UsersMamagerPage {

  consumers: any = [];
  sid: number = 0;
  complete = false;
  constructor(public navCtrl: NavController,
    public toastCtrl: ToastController,
    public loadingCtrl: LoadingController,
    public navParams: NavParams,
    public consumerData: ConsumerData) { }

  ngAfterViewInit() {
    let loader = this.loadingCtrl.create({
      spinner: 'bubbles',
    });
    loader.present();
    this.getUserLists(undefined, 0)
      .then(s => loader.dismiss()).catch(err => loader.dismiss());
  }

  doRefresh(refresher: Refresher) {
    this.getUserLists(refresher, 0);
    this.complete = false;
  }
  getUserLists(refresher: Refresher, offset) {
    return this.consumerData.getConsumerList(offset).then(
      info => {
        let data: any = info;
        if (refresher != undefined)
          refresher.complete();
        if (data.errcode == 0) {
          this.consumers = data.data;
        }
        else {
          //show error message
          this.showToastWithCloseButton(data.errmsg);
        }
      }, error => {
        if (refresher != undefined)
          refresher.complete();
        //show error message
        this.showToastWithCloseButton("系统繁忙");
      }
    )
  }
  doInfinite(infiniteScroll: InfiniteScroll) {
    // console.log(this.consumers.length);
    this.consumerData.getConsumerList(this.consumers.length).then(info => {
      let data: any = info;
      if (data.errcode === 0) {
        let newData = data.data;
        for (var i = 0; i < newData.length; i++) {
          this.consumers.push(newData[i]);
        }
        if (newData.length <= 0) {
          this.complete = true;
        }
        infiniteScroll.complete();
      }
    }, err => {

    });
    // this.productData.getReservationProducts(this.products.length, this.keyword).then((newData) => {
    //   let data: any = newData;
    //   if (data.errcode === 0) {
    //     let newData = data.data.all_products;
    //     for (var i = 0; i < newData.length; i++) {
    //       this.products.push(newData[i]);
    //     }


    //     if (newData.length <= 0) {
    //       infiniteScroll.enable(false);
    //     }
    //   }
    //   infiniteScroll.complete();
    // });
  }
  create_user() {
    this.navCtrl.push(UsersMamagerDetailPage);

  }
  showDetail(consumer) {
    this.navCtrl.push(UsersMamagerDetailPage, consumer);
  }
  showToastWithCloseButton(errcmsg) {
    const toast = this.toastCtrl.create({
      message: errcmsg,
      duration: 3000
    });
    toast.present();
  }

}
