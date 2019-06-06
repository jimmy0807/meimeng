import { Component } from '@angular/core';
import { NavController, NavParams, ModalController, ToastController, ViewController } from 'ionic-angular';
import { KpiData } from '../../providers/kpi-data';
import { KpiRecordPage } from '../kpi-record/kpi-record';
import { AppGlobal } from '../../app-global';

@Component({
  selector: 'page-follow-plan',
  templateUrl: 'follow-plan.html'
})
export class FollowPlanPage {

  user_eid:number=0;
  need_refash: boolean = false;
  recharge_amount: number = 0;
  other_amount: number = 0;
  kpi: any;
  member: any;
  mode = 'view';
  plant = {
    'id': 0,
    'name': '',
    'planning_id': 0,
    'member_id': 0,
    'create_date': '',
    'card_products': [],
    'featured_products': [],
    'record_ids': [],
    'recharge_amount': 0,
    'other_amount': 0,
    'amount': 0,
    'royalties_amount': 0,
    'spending_amount': 0,
    'card_amount':0,
    'employee_id':0,
  };

  constructor(
    public kpiData: KpiData,
    public navParams: NavParams,
    private toastCtrl: ToastController,
    public viewCtrl: ViewController,
    public modalCtrl: ModalController,
    public navCtrl: NavController) {

    if (navParams.data != undefined) {
      this.kpi = navParams.data.kpi;
      this.member = navParams.data.member;
    }

     if (AppGlobal.getInstance().user != undefined) {
      this.user_eid = AppGlobal.getInstance().user.eid;
    }

  }

  ngAfterViewInit() {
    if (this.kpi) {
      this.getKpiMemberInfo();
    }
  }

  getKpiMemberInfo() {
    this.kpiData.getKpiMemberInfo(this.kpi.id, this.member.id).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.plant = data.data;
          if (this.plant.id <= 0){
            this.mode='edit';
          }
          this.recharge_amount = this.plant.recharge_amount;
          this.other_amount = this.plant.other_amount;
        }
      },
      error => {
      }
    )
  }

  dismiss() {
    if (this.need_refash) {
      this.viewCtrl.dismiss(this.plant.id);
    } else {
      this.viewCtrl.dismiss();
    }
  }

  addProduct(index) {
    let qty: number = this.plant.card_products[index].total_qty;
    if (qty > this.plant.card_products[index].select_qty) {
      this.plant.card_products[index].select_qty += 1;
    }
  }
  clearProduct(index) {
    this.plant.card_products[index].select_qty = 0;
  }
  addFeatured(index) {
    this.plant.featured_products[index].select_qty += 1;
  }

  addCashFeatured(index) {
    this.plant.featured_products[index].select_cash_qty += 1;
  }
  clearFeatured(index) {
    this.plant.featured_products[index].select_qty = 0;
     this.plant.featured_products[index].select_cash_qty = 0;
  }

  swich_edit() {
    if (this.mode == 'view')
      this.mode = 'edit';
    else if (this.mode == 'edit')
      this.mode = 'view';
  }

  saveKpiMemberInfo() {
    let card_products = [];
    let featured_products = [];
    if (this.mode == 'view')
      this.mode = 'edit';
    else if (this.mode == 'edit')
      this.mode = 'view';
    this.plant.card_products.forEach(function (e) {
      if (e.select_qty > 0) {
        card_products.push(e.id + "|" + e.select_qty+"|0");
      }
    })
    this.plant.featured_products.forEach(function (e) {
      if (e.select_qty > 0 || e.select_cash_qty>0) {
        featured_products.push(e.id + "|" + e.select_qty+"|"+e.select_cash_qty);
      }
    })
    let param = {
      'id': this.plant.id,
      'planning_id': this.plant.planning_id,
      'member_id': this.plant.member_id,
      'recharge_amount': this.recharge_amount,
      'other_amount': this.other_amount,
      'card_products': card_products,
      'featured_products': featured_products,
    };
    this.kpiData.saveKpiMemberInfo(param).then((info) => {
      let data: any = info;
      if (data.errcode === 0) {
        this.need_refash = true;
        if (this.plant.id === 0) {
          this.plant.id = data.data.id;
        } else {
          this.plant.id = data.data.id;
          this.viewCtrl.dismiss(this.plant.id);
        }
      }
      this.showToastWithCloseButton(data.errmsg);
    });

  }

  openSocial() {
    let modal = this.modalCtrl.create(KpiRecordPage,this.plant);
    modal.onDidDismiss(data => {

      if (data != undefined) {
          this.getKpiMemberInfo();
      }
    });
    modal.present();
  }

  showToastWithCloseButton(errcmsg) {
    const toast = this.toastCtrl.create({
      message: errcmsg,
      duration: 3000
    });
    toast.present();
  }

}
