import { Component, NgZone } from '@angular/core';
import { Platform, ModalController, Events, ActionSheetController, ToastController, Refresher, NavController, AlertController } from 'ionic-angular';
import { NativeStorage } from '@ionic-native/native-storage';
import { Badge } from '@ionic-native/badge';

import { RevenueOperatePage } from '../revenue-operate/revenue-operate';
import { MemberDetailPage } from '../member-detail/member-detail';
import { ReservationPage } from '../reservation/reservation';
import { AuthorizationPage } from '../authorization/authorization';
import { ApplicationPage } from '../application/application';
import { CommissionPage } from '../commission/commission';
import { FeedbackPage } from '../feedback/feedback';
import { RevenuePage } from '../revenue/revenue';
import { FollowPage } from '../follow/follow';
import { VisitPage } from '../visit/visit';
import { KpiPage } from '../kpi/kpi';
import { ShopPage } from '../shop/shop';
import { MemberListPage } from '../member-list/member-list';
import { HomeData } from '../../providers/home-data';
import { VisitData } from '../../providers/visit-data';
import { AppGlobal, AppGroup } from '../../app-global';
import { SmsIndexPage } from '../sms-index/sms-index';
import { DeviceAccessPage } from '../device-access/device-access';
import { ReportIndexPage } from '../report-index/report-index';
import { PartnerPage } from '../partner/partner';

declare var cordova: any;

@Component({
  selector: 'page-home',
  templateUrl: 'home.html'
})
export class HomePage {
  shopName: string = "";
  messageText: string;
  isAdmin = false;
  banners: any[] = [];
  dashboard: any = {
    period_name: "",
    account_amount: 0,
    account_id: 0,
    commission_count: 0,
    commission_money: "0.00",
    customer_count: 0,
    follow_active_member_total: 0,
    follow_member_ids: [],
    follow_member_total: 0,
    follow_my_member_total: 0,
    month_account_amount: "0.00",
    month_account_id: 0,
    month_commission_count: 0,
    month_commission_money: "0.00",
    month_customer_count: 0,
    reservation_count: 0,
    reservation_create_date: "",
    reservation_member_name: "",
    reservation_product_name: "",
    reservation_start_date: "",
    reservation_technician_name: "",
    reservation_telephone: "",
    kpi_royalties_amt: "0",
    kpi_spending_amt: "0",
    current_member_cnt: 0,
    kpi_id: 0,
    kpi_employee_id: 0,
    success_qty: 0,
  };
  showReport = true;
  showAdmin = true;
  groupMedical = false;
  showPartner = false;
  test: boolean;
  g: AppGroup;
  constructor(
    public navCtrl: NavController,
    public modalCtrl: ModalController,
    private toastCtrl: ToastController,
    public asCtrl: ActionSheetController,
    public badge: Badge,
    public homeData: HomeData,
    public visitData: VisitData,
    private ngZone: NgZone,
    public alertCtrl: AlertController,
    public alert: AlertController,
    public events: Events,
    public nativeStorage: NativeStorage,
    private platform: Platform) {
    let user = AppGlobal.getInstance().user;
    let ug = AppGlobal.getInstance().userGroup;
    this.groupMedical = AppGlobal.getInstance().groupMedical;
    this.g = AppGlobal.getInstance().appGroup;
    this.test = !AppGlobal.getInstance().isCordova;
    if (user)
      this.isAdmin = user.role == '1' || user.role == '2' || user.role == '3';
    if (ug) {
      this.showReport = Boolean(ug.sel_groups_94);
      this.showAdmin = ug.sel_groups_95_101_96 === '管理员';
      this.showPartner = ug.sel_groups_99_100 === '经理';
    }
  }

  async ngAfterViewInit() {
    let allBanners = AppGlobal.getInstance().banners;
    if (allBanners != undefined) {
      this.banners = allBanners.filter(function (item) {
        return item.category === 'carousel';
      });
    } else {
      this.nativeStorage.getItem('ds.banners').then(
        info => {
          let allBanners = info;
          if (allBanners != undefined) {
            this.banners = allBanners.filter(function (item) {
              return item.category === 'carousel';
            });
          }
        },
        error => {
        }
      )
    }
    if (AppGlobal.getInstance().user) {
      this.shopName = AppGlobal.getInstance().user.shop_name;
    }
    this.get_dashboard(true);

    try {
      let r = await this.visitData.getVisitCount();
      if (r.errcode === 0) {
        console.info(r);
        if (r.data.count > 0)
          this.badge.set(r.data.count)
        else
          this.badge.clear();
      }
    }
    catch (e) {

    }
  }


  get_dashboard(refresher) {
    this.homeData.get_dashboard(refresher).then(
      result => {
        let res: any = result;
        if (res.errcode === 0) {
          this.dashboard = res.data;
        }
      },
      error => {
      }
    )
  }


  showOperateDailyDetail(id) {
    let param = {
      'did': id,
      'mid': 0
    }
    this.navCtrl.push(RevenueOperatePage, param)
  }

  showOperateMonthDetail(id) {
    let param = {
      'did': 0,
      'mid': id
    }
    this.navCtrl.push(RevenueOperatePage, param)
  }


  onFunctionClick(model) {
    switch (model) {
      case 'reservation':
        this.navCtrl.push(ReservationPage);
        break;
      case 'commission':
        this.navCtrl.push(CommissionPage);
        break;
      case 'follow':
        this.navCtrl.push(FollowPage);
        break;
      case 'kpi':
        let param = {
          'id': this.dashboard.kpi_id,
          'employee_id': this.dashboard.kpi_employee_id,
        }
        this.navCtrl.push(KpiPage, param);
        break;
      case 'feedback':
        this.navCtrl.push(FeedbackPage);
        break;
      case 'all':
        this.navCtrl.push(ApplicationPage);
        break;
      case 'authorization':
        this.navCtrl.push(AuthorizationPage);
        break;
      case 'revenue':
        this.navCtrl.push(RevenuePage);
        break;
      case 'member':
        this.navCtrl.push(MemberListPage);
        break;
      case 'mail':
        this.navCtrl.push(SmsIndexPage);
        break;
      case 'visit':
        this.navCtrl.push('VisitList');
        break;
      case 'deviceAccess':
        this.navCtrl.push(DeviceAccessPage);
        break;
      case 'reportIndex':
        this.navCtrl.push(ReportIndexPage);
        break;
      case 'partner':
        this.navCtrl.push(PartnerPage);
        break;
      case 'order':
        //this.launchNative('order');
        break;
      case 'achieve':
        this.navCtrl.push('AchievementPage');
        break;
      case 'partner_commission':
        this.navCtrl.push('PartnerCommissionPage');
        break;
      case 'test':
        this.navCtrl.push('TestPage');
        break;
      case 'event':
        this.navCtrl.push('EventPage');
        break;
      case 'buy':
        this.navCtrl.push('ChargePage');
        break;
      case 'photo':
        this.navCtrl.push('PhotoPage');
        break;
    }
  }
  launchNative(category, url) {
    var data = {
      'launch_url': AppGlobal.getInstance().server,
      'launch_db': AppGlobal.getInstance().db,
      'launch_cid': AppGlobal.getInstance().user.security_id,
      'launch_category': category,
      'launch_uid': AppGlobal.getInstance().user.uid,
      'launch_sid': AppGlobal.getInstance().sid,
      'launch_mobile': AppGlobal.getInstance().user.login,
      'launch_browser': url
    };

    console.info(data);
    let security = cordova.require("cordova-plugin-security.Security");
    security.launch(data, function (info) {
    }, function (error) {
    });
  }


  doRefresh(refresher: Refresher) {
    this.homeData.get_dashboard(true).then(
      result => {
        let res: any = result;
        this.dashboard = res.data;
        refresher.complete();
      },
      error => {
      }
    )
  }

  doPulling(refresher: Refresher) {
  }

  onChangeShop() {
    let modal = this.modalCtrl.create(ShopPage);
    modal.onDidDismiss(data => {
      if (data.change) {
        this.shopName = data.shop.name;
        this.get_dashboard(true);
      }
    });
    modal.present();
  }

  onBannerClick(item) {
    if (item.link) {
      this.launchNative('browser', item.link);
    }
  }

  showMember(item) {
    let param = {
      'id': item.id
    }
    this.navCtrl.push(MemberDetailPage, param);
  }

  showVisit(item) {
    let param = {
      'id': item.id,
      'name': '',
      'member_name': item.name,
      'mobile': item.mobile,
    }
    let modal = this.modalCtrl.create(VisitPage, param);
    modal.onDidDismiss(data => {
      if (data != undefined) {
        this.get_dashboard(true);
      }
    });
    modal.present();
  }
}
