import { Component, ViewChild } from '@angular/core';
import { NavController, Scroll, Refresher, ViewController, NavParams, ModalController, AlertController, PopoverController } from 'ionic-angular';

import { KpiFeaturedDetailPage } from '../kpi-featured-detail/kpi-featured-detail';
import { FollowEmployeePage } from '../follow-employee/follow-employee';
import { KpiFeaturedPage } from '../kpi-featured/kpi-featured';
import { KpiAllotPage } from '../kpi-allot/kpi-allot';
import { KpiData } from '../../providers/kpi-data';
import { AppGlobal } from '../../app-global';
import { KpiPage } from '../kpi/kpi';
import { LoadingController } from 'ionic-angular';

@Component({
  selector: 'page-follow',
  templateUrl: 'follow.html'
})
export class FollowPage {

  @ViewChild('chatScroll') chatScroll: Scroll;

  order = "royalties_amt";
  months = [];
  currentDate: any = { 'year': 0, 'month': 0 };
  kpis = [];
  featureds = [];
  user_role: string = '';
  user_eid: number = 0;
  kpi: {
    current_royalties_amt?: number,
    current_spending_amt?: number,
    coming_customer_num?: number,
    new_member_num?: number,
    coming_num?: number,
    employee_name?: string,
    employee_image_url?: string
  } = {};

  constructor(public navParams: NavParams,
    public navCtrl: NavController,
    public viewCtrl: ViewController,
    public loadingCtrl: LoadingController,
    public alertCtrl: AlertController,
    private popoverCtrl: PopoverController,
    public kpiData: KpiData,
    public modalCtrl: ModalController) {
    this.initMonth();
    if (AppGlobal.getInstance().user != undefined) {
      this.user_eid = AppGlobal.getInstance().user.eid;
      this.user_role = AppGlobal.getInstance().user.role;
    }
  }

  ngAfterViewInit() {
    let loader = this.loadingCtrl.create({
      spinner: 'bubbles',
    });
    loader.present();
    this.getKpiList().then(s => loader.dismiss()).catch(err => loader.dismiss());
    this.getFeaturedProduct();
    //this.chatScroll.scrollElement.scrollLeft = this.chatScroll.scrollElement.scrollWidth * 0.5;
  }

  initMonth() {
    var nowDate = new Date();
    this.currentDate.year = nowDate.getFullYear();
    this.currentDate.month = nowDate.getMonth() + 1;
    var temp = new Array();
    this.currentDate.month = nowDate.getMonth() + 1;
    [8, 7, 6, 5, 4, 3, 2, 1, 0, -1, -2].forEach(element => {
      var nowDate = new Date();
      nowDate.setMonth(this.currentDate.month - element);
      let v = {
        'month': 1 + nowDate.getMonth(),
        'year': nowDate.getFullYear()
      }
      temp.push(v)
    });
    this.months = temp;
  }

  changeOrderClick(order) {
    this.order = order;
    this.getKpiList();
  }

  getKpiList(refresher = undefined) {
    return this.kpiData.getKpiList(this.currentDate, this.order).then(
      info => {
        let data: any = info;
        if (data.errcode === 0) {
          this.kpis = data.data;
          if (this.kpis.length > 0) {
            this.kpi = this.kpis[0];
          } else {
            this.kpi.coming_customer_num = 0;
            this.kpi.current_royalties_amt = 0;
            this.kpi.current_spending_amt = 0;
            this.kpi.coming_customer_num = 0;
            this.kpi.new_member_num = 0;
            this.kpi.coming_num = 0;
            this.kpi.employee_name = '快来占领榜首';
            this.kpi.employee_image_url = "";
          }
        }
        if (refresher != undefined) {
          refresher.complete();
        }
      },
      error => {
        if (refresher != undefined) {
          refresher.complete();
        }
      }
    )
  }

  getFeaturedProduct() {
    this.kpiData.getFeaturedProduct(this.currentDate).then(
      info => {
        let data: any = info;
        if (data.errcode === 0) {
          this.featureds = data.data;
        }
      },
      error => {
      }
    )
  }

  onChangerMonth(month) {
    this.currentDate = month;
    this.getKpiList();
    this.getFeaturedProduct();
  }

  add() {
    let modal = this.modalCtrl.create(FollowEmployeePage, this.currentDate);
    modal.onDidDismiss(data => {
      if (data != undefined) {
        this.getKpiList();
        this.getFeaturedProduct();
      }
    });
    modal.present();
  }

  edit(item) {
    let employee = {
      'id': item.employee_id,
      'name': item.employee_name,
    }
    let param = { 'currentDate': this.currentDate, 'employee': employee };
    let modal = this.modalCtrl.create(KpiAllotPage, param);
    modal.onDidDismiss(data => {
      if (data != undefined) {
        this.getKpiList();
        this.getFeaturedProduct();
      }
    });
    modal.present();
  }

  unlink(item) {
    this.kpiData.deleteEmployeeKpi(item.id).then(
      info => {
        let data: any = info;
        if (data.errcode === 0) {
          this.getKpiList();
          this.getFeaturedProduct();
        }
      },
      error => {
      }
    )
  }

  addFeaturedProduct() {
    let modal = this.modalCtrl.create(KpiFeaturedPage, this.currentDate);
    modal.onDidDismiss(data => {
      if (data != undefined) {
        let ids = [];
        data.forEach(function (e) {
          ids.push(e.id);
        })
        let params = {
          'pid': ids,
          'month': this.currentDate.month,
          'year': this.currentDate.year,
        }
        this.kpiData.updateFeaturedProduct(params).then(
          info => {
            let data: any = info;
            if (data.errcode === 0) {
              this.getFeaturedProduct();
            }
          }
        )
      }
    });
    modal.present();
  }

  openKip(item) {
    this.navCtrl.push(KpiPage, item);
  }

  copyfeaturedProduct() {
    this.kpiData.copyfeaturedProduct(this.currentDate).then(
      info => {
        let data: any = info;
        if (data.errcode === 0) {
          this.getFeaturedProduct();
        }
      },
      error => {
      }
    )
  }

  showFeaturedDetail(param) {
    let modal = this.modalCtrl.create(KpiFeaturedDetailPage, param);
    modal.onDidDismiss(data => {
      if (data != undefined) {
        this.getFeaturedProduct();
      }
    });
    modal.present();
  }

  doRefresh(refresher: Refresher) {
    this.getKpiList(refresher);
  }

  doPulling(refresher: Refresher) {
  }
}
