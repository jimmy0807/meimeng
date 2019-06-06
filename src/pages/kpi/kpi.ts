import { Component } from '@angular/core';
import { NavController, NavParams, InfiniteScroll, ModalController, ToastController } from 'ionic-angular';
import { KpiNewcustomerPage } from '../kpi-newcustomer/kpi-newcustomer';
import { FollowMemberPage } from '../follow-member/follow-member';
import { KpiMemberPage } from '../kpi-member/kpi-member';
import { FollowPlanPage } from '../follow-plan/follow-plan';
import { KpiIncomingPage } from '../kpi-incoming/kpi-incoming';

import { KpiOperatePage } from '../kpi-operate/kpi-operate';
import { KpiData } from '../../providers/kpi-data';
import { AppGlobal } from '../../app-global';
import { KpiRecordPage } from '../kpi-record/kpi-record';
import { LoadingController } from 'ionic-angular';

@Component({
  selector: 'page-kpi',
  templateUrl: 'kpi.html'
})
export class KpiPage {

  user_eid: number = 0;
  records: any = [];
  has_member: boolean = false;
  kpi: any;
  segment = 'month';

  constructor(
    public navParams: NavParams,
    public navCtrl: NavController,
    public loadingCtrl: LoadingController,
    public kpiData: KpiData,
    private toastCtrl: ToastController,
    public modalCtrl: ModalController) {
    if (navParams.data) {
      this.kpi = navParams.data;
    }
    if (AppGlobal.getInstance().user != undefined) {
      this.user_eid = AppGlobal.getInstance().user.eid;
    }

  }

  ngAfterViewInit() {
    let loader = this.loadingCtrl.create({
      spinner: 'bubbles',
    });
    loader.present();
    this.getKpiRecord().then(s => loader.dismiss()).catch(err => loader.dismiss());
    this.getKpi();
  }

  ionViewWillEnter() {
    this.getKpiRecord();
    this.getKpi();
  }

  getKpi() {
    let param = {
      'kid': this.kpi.id
    };
    this.kpiData.getKpi(param).then(
      info => {
        let result: any = info;
        if (result.errcode === 0) {
          this.kpi = result.data;
          if (this.kpi.members.length > 0) {
            this.has_member = true;
          }
        }
      }
    )
  }

  getKpiRecord() {
    let param = {
      'eid': this.kpi.employee_id
    };
    return this.kpiData.getKpiRecord(param, 0).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.records = data.data;
        }
      },
      error => {
        this.showToastWithCloseButton("系统繁忙")
      }
    )
  }

  doInfinite(infiniteScroll: InfiniteScroll) {
    let param = {
      'eid': this.kpi.employee_id
    };
    this.kpiData.getKpiRecord(param, this.records.length).then((newData) => {
      let data: any = newData;
      if (data.errcode === 0) {
        let newData = data.data;
        for (var i = 0; i < newData.length; i++) {
          this.records.push(newData[i]);
        }

        if (newData.length <= 0) {
          infiniteScroll.enable(false);
        }

      }
      infiniteScroll.complete();
    });
  }

  doKpi() {
    let modal = this.modalCtrl.create(KpiMemberPage, this.kpi);
    modal.onDidDismiss(data => {
      if (data != undefined) {
        this.getKpiRecord();
        this.getKpi();
      }
    });
    modal.present();
  }

  openFollowMemberPos(item) {
    this.navCtrl.push(FollowMemberPage, item);
  }

  openFollowPlan(item) {
    let member = {
      'id': item.member_id
    }
    let param = { 'kpi': this.kpi, 'member': member };
    let modal = this.modalCtrl.create(FollowPlanPage, param);
    modal.onDidDismiss(data => {
      if (data != undefined) {
        this.getKpiRecord();
        this.getKpi();
      }
    });
    modal.present();
  }

  openSocial(item) {
    this.kpiData.getKpiMemberInfo(this.kpi.id, item.member_id).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          let plant = data.data;
          let modal = this.modalCtrl.create(KpiRecordPage, plant);
          modal.onDidDismiss(data => {
            if (data != undefined) {
              this.getKpiRecord();
              this.getKpi();
            }
          });
          modal.present();
        }
      },
      error => {
        this.showToastWithCloseButton("系统繁忙")
      }
    )
  }

  onOperate(model) {
    switch (model) {
      case 'royalties':
        this.navCtrl.push(KpiOperatePage, this.kpi);
        break;
      case 'spending':
        this.navCtrl.push(KpiOperatePage, this.kpi);
        break;
      case 'coming_customer':
        this.navCtrl.push(KpiOperatePage, this.kpi);
        break;
      case 'new_member':
        this.navCtrl.push(KpiNewcustomerPage, this.kpi);
        break;
      case 'coming_in':
        this.navCtrl.push(KpiIncomingPage, this.kpi);
        break;
    }
  }

  onRecordOperate(model, kpi) {
    switch (model) {
      case 'royalties':
        this.navCtrl.push(KpiOperatePage, kpi);
        break;
      case 'spending':
        this.navCtrl.push(KpiOperatePage, kpi);
        break;
      case 'coming_customer':
        this.navCtrl.push(KpiOperatePage, kpi);
        break;
      case 'new_member':
        this.navCtrl.push(KpiNewcustomerPage, kpi);
        break;
      case 'coming_in':
        this.navCtrl.push(KpiIncomingPage, kpi);
        break;
    }
  }

  showToastWithCloseButton(errcmsg) {
    const toast = this.toastCtrl.create({
      message: errcmsg,
      duration: 3000
    });
    toast.present();
  }
}
