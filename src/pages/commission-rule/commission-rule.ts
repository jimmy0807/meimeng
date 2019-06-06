import { Component } from '@angular/core';
import { NavController, NavParams, Refresher, InfiniteScroll, ToastController } from 'ionic-angular';
import { CommissionRuleDetailPage } from '../commission-rule-detail/commission-rule-detail';
import { CommissionRuleData } from '../../providers/commission-rule-data';
import { AppGlobal } from '../../app-global';
import { LoadingController } from 'ionic-angular';

@Component({
  selector: 'page-commission-rule',
  templateUrl: 'commission-rule.html'
})
export class CommissionRulePage {

  eid = 0;
  groups = [];

  constructor(public navCtrl: NavController,
    public navParams: NavParams,
    public loadingCtrl: LoadingController,
    private toastCtrl: ToastController,
    public commissionRuleData: CommissionRuleData) {
    if (AppGlobal.getInstance().user != undefined) {
      this.eid = AppGlobal.getInstance().user.eid;
    }
  }

  ngAfterViewInit() {
    let loader = this.loadingCtrl.create({
      spinner: 'bubbles',
    });
    loader.present();
    this.getCommissionRules(0, undefined).then(s => loader.dismiss()).catch(err => loader.dismiss());
  }

  ionViewWillEnter() {
    this.getCommissionRules(0, undefined);
  }

  getCommissionRules(offset, refresher: Refresher) {
    return this.commissionRuleData.getCommissionRules(offset).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          if (refresher != undefined) {
            refresher.complete();
          }
          this.groups = data.data.commission_rules;
        } else {
          this.showToastWithCloseButton(data.errmsg);
        }
      },
      err => {
        this.showToastWithCloseButton("系统繁忙")
      }
    )
  }

  doRefresh(refresher: Refresher) {
    this.getCommissionRules(0, refresher);
  }

  doInfinite(infiniteScroll: InfiniteScroll) {
    this.commissionRuleData.getCommissionRules(this.groups.length).then((newData) => {
      let data: any = newData;
      if (data.errcode === 0) {
        let _newData = data.data.commission_rules;
        for (var i = 0; i < _newData.length; i++) {
          this.groups.push(_newData[i]);
        }
      } else {
        this.showToastWithCloseButton(data.errmsg);
      }
      infiniteScroll.complete();

      if (this.groups.length >= data.data.count) {
        infiniteScroll.enable(false);
      }
    });
  }

  showDetail(commissionRule) {
    this.navCtrl.push(CommissionRuleDetailPage, commissionRule)
  }

  add() {
    let param = {};
    this.navCtrl.push(CommissionRuleDetailPage, param)
  }

  showToastWithCloseButton(errcmsg) {
    const toast = this.toastCtrl.create({
      message: errcmsg,
      duration: 3000
    });
    toast.present();
  }
}
