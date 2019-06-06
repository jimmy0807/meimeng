import { Component } from '@angular/core';
import { NavController, NavParams, ModalController, ViewController } from 'ionic-angular';
import { KpiData } from '../../providers/kpi-data';
import { FollowPlanPage } from '../follow-plan/follow-plan';

@Component({
  selector: 'page-kpi-member',
  templateUrl: 'kpi-member.html'
})
export class KpiMemberPage {
  kpi: any;
  need_refash:boolean=false;
  members_normal: any=[];
  members_vip: any=[];
  members_mvp: any=[];
  constructor(
    public navParams: NavParams,
    public navCtrl: NavController,
    public kpiData: KpiData,
    public modalCtrl: ModalController,
    public viewCtrl: ViewController) {
    if (navParams.data != undefined) {
      this.kpi = navParams.data;
    }
  }

  ionViewDidLoad() {
  }

  ngAfterViewInit() {
    if (this.kpi) {
      this.load();
    }
  }

  load() {
    this.kpiData.getKpiMember(this.kpi.id).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.members_normal = data.data.filter(function (item) {
            return (item.member_level === 'normal' || item.member_level === false);
          });
          this.members_vip = data.data.filter(function (item) {
            return item.member_level === 'vip';
          });
          this.members_mvp = data.data.filter(function (item) {
            return item.member_level === 'mvp';
          });
        }
      },
      error => {
      }
    )
  }

  dismiss() {
    this.viewCtrl.dismiss();
  }

  onSelectMember(item) {
    let param = { 'kpi': this.kpi, 'member': item };
    let modal = this.modalCtrl.create(FollowPlanPage, param);
    modal.onDidDismiss(data => {
      if (data != undefined) {
        this.viewCtrl.dismiss(data);
      }
    });
    modal.present();

  }


}
