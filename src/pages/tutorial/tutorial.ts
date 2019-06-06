import { Component } from '@angular/core';
import { NavController } from 'ionic-angular';
import { StatusBar } from '@ionic-native/status-bar';
import { LoadingPage } from '../loading/loading';

export interface Slide {
  title: string;
  description: string;
  image: string;
}

@Component({
  selector: 'page-tutorial',
  templateUrl: 'tutorial.html'
})
export class TutorialPage {
  slides: Slide[];
  showSkip = true;

  constructor(public navCtrl: NavController,
    public statusBar: StatusBar) {
    this.slides = [
      {
        title: '一键预约',
        description: '指间互动，便捷简约。多通道信息收录，移动端、微卡、电脑、电话，联动查询，遗漏不再',
        image: 'assets/img/ica-slidebox-img-1.png',
      },
      {
        title: '快捷收银',
        description: '一体机可直接刷卡，扫码枪、POS机、钱箱等，通过蓝牙连接，无一丝冗余',
        image: 'assets/img/ica-slidebox-img-2.png',
      },
      {
        title: '客户跟进',
        description: '智能客情，悉心提醒。深度高效管理，针对定向服务，发掘每一位顾客的消费潜力。',
        image: 'assets/img/ica-slidebox-img-3.png',
      },
      {
        title: '多维营销',
        description: '营销帮手，营业管家。塑造互联网化，纵览报表数据。电子卡券营销，专属方案，定制营销跑道。',
        image: 'assets/img/ica-slidebox-img-4.png',
      }
    ];
  }

  startApp() {
    this.navCtrl.push(LoadingPage);
  }

  onSlideChangeStart(slider) {
    this.showSkip = !slider.isEnd;
  }

  ionViewDidEnter() {
    this.statusBar.hide();
  }
}
