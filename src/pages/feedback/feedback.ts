import { Component } from '@angular/core';
import { NavController, ModalController, InfiniteScroll } from 'ionic-angular';

import { FeedbackDetailPage } from '../feedback-detail/feedback-detail';
import { FeedbackData } from '../../providers/feedback-data';
import { KpiData } from '../../providers/kpi-data';
import { LoadingController } from 'ionic-angular';

@Component({
  selector: 'page-feedback',
  templateUrl: 'feedback.html'
})

export class FeedbackPage {

  operates = [];

  constructor(public navCtrl: NavController,
    public kpiData: KpiData,
    public loadingCtrl: LoadingController,
    public modalCtrl: ModalController,
    public feedbackData: FeedbackData) {
  }

  ngAfterViewInit() {
    let loader = this.loadingCtrl.create({
      spinner: 'bubbles',
    });
    loader.present();
    this.getFeedbackList().then(s => loader.dismiss()).catch(err => loader.dismiss());
  }

  getFeedbackList() {
    return this.feedbackData.getFeedbackList(0).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.operates = data.data;
        }
      },
      error => {
      }
    )
  }

  goDetil(operate) {
    let modal = this.modalCtrl.create(FeedbackDetailPage, operate);
    modal.onDidDismiss(data => {
      if (data != undefined) {
        this.getFeedbackList();
      }
    });
    modal.present();
  }

  doInfinite(infiniteScroll: InfiniteScroll) {

    let lg = 0;
    this.operates.forEach(element => {
      lg += element.operates.length;
    });

    this.feedbackData.getFeedbackList(lg).then((newData) => {
      let data: any = newData;
      if (data.errcode === 0) {
        let newData = data.data;
        for (var i = 0; i < newData.length; i++) {

          if (i == 0) {
            let lastTemp = this.operates[this.operates.length - 1];
            let temp = newData[0];
            if (lastTemp.date === temp.date) {
              for (var j = 0; j < temp.operates.length; j++) {
                this.operates[this.operates.length - 1].operates.push(temp.operates[j]);
              }
            } else {
              this.operates.push(newData[i]);
            }
          } else {
            this.operates.push(newData[i]);
          }
        }
        if (newData.length <= 0) {
          infiniteScroll.enable(false);
        }
      }
      infiniteScroll.complete();
    });
  }
}
