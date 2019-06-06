import { Component } from '@angular/core';
import { NavController, AlertController } from 'ionic-angular';
import { ReservationPage } from '../reservation/reservation';
import { CommissionPage } from '../commission/commission';
import { FeedbackPage } from '../feedback/feedback';
import { RevenuePage } from '../revenue/revenue';
import { FollowPage } from '../follow/follow';
import { RoomPage } from '../room/room';
import { AppGlobal } from '../../app-global';
import { AuthorizationPage } from '../authorization/authorization';
import { ShopManagerPage } from '../shop-manager/shop-manager';
import { CommissionRulePage } from '../commission-rule/commission-rule';
import { DeviceAccessPage } from '../device-access/device-access';
import { UsersMamagerPage } from '../users-mamager/users-mamager';
import { PricelistPage } from '../pricelist/pricelist';
import { CompanyPage } from '../company/company';
import { SchedulePage } from '../schedule/schedule';
import { ReportIndexPage } from '../report-index/report-index';
import { ProductPage } from '../product/product';
import { Platform } from 'ionic-angular';
import { PosCategoryPage } from '../pos-category/pos-category';
import { EmployeeListPage } from '../employee-list/employee-list';
import { MemberListPage } from '../member-list/member-list';
import { SmsIndexPage } from '../sms-index/sms-index';
import { StockPage } from '../stock/stock';
import { PartnerPage } from '../partner/partner';
import { MedicalIndexPage } from '../medical-index/medical-index';

declare var cordova: any;

@Component({
  selector: 'page-application',
  templateUrl: 'application.html'
})
export class ApplicationPage {
  isAdmin = false;
  showSys = true;
  groupMedical = false;
  constructor(public navCtrl: NavController,
    public plt: Platform,
    public alertCtrl: AlertController) {
    let user = AppGlobal.getInstance().user;
    let ug = AppGlobal.getInstance().userGroup;
    this.groupMedical = AppGlobal.getInstance().groupMedical;
    if (user)
      this.isAdmin = user.role == '1' || user.role == '2' || user.role == '3';
    if (ug) {
      this.showSys = ug.sel_groups_1_2_3 === '设置';
    }
  }

  ionViewDidLoad() {
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
      case 'feedback':
        this.navCtrl.push(FeedbackPage);
        break;
      case 'all':
        this.navCtrl.push(ApplicationPage);
        break;
      case 'revenue':
        this.navCtrl.push(RevenuePage);
        break;
      case 'room':
        this.navCtrl.push(RoomPage);
        break;
      case 'authorization':
        this.navCtrl.push(AuthorizationPage);
        break;
      case 'member':
        this.navCtrl.push(MemberListPage);
        break;
      case 'mail':
        this.navCtrl.push(SmsIndexPage);
        break;
      case 'order':
        this.launchNative('order');
        break;
      case 'product':
        this.navCtrl.push(ProductPage);
        break;
      case 'poscategory':
        this.navCtrl.push(PosCategoryPage, { allowEdit: true, manageMode: true });
        break;
      case 'historypos':
        this.launchNative('historypos');
        break;
      case 'hr':
        this.navCtrl.push(EmployeeListPage);
        break;
      case 'inventory':
        this.launchNative('inventory');
        break;
      case 'shopManager':
        this.navCtrl.push(ShopManagerPage);
        break;
      case 'commissionRule':
        this.navCtrl.push(CommissionRulePage);
        break;
      case 'deviceAccess':
        this.navCtrl.push(DeviceAccessPage);
        break;
      case 'usersMamager':
        this.navCtrl.push(UsersMamagerPage);
        break;
      case 'pricelist':
        this.navCtrl.push(PricelistPage);
        break;
      case 'company':
        this.navCtrl.push(CompanyPage);
        break;
      case 'schedule':
        this.navCtrl.push(SchedulePage);
        break;
      case 'reportIndex':
        this.navCtrl.push(ReportIndexPage);
        break;
      case 'stock':
        this.navCtrl.push(StockPage);
        break;
      case 'partner':
        this.navCtrl.push(PartnerPage);
        break;
      case 'medical':
        this.navCtrl.push(MedicalIndexPage);
        break;
      case 'visit':
        this.navCtrl.push('VisitList');
        break;
      case 'other':
        let al = this.alertCtrl.create({
          title: '敬请期待',
          subTitle: '我们正在努力上线中...',
          buttons: ['确认']
        })
        al.present();
        break;
    }
  }

  launchNative(category) {
    var data = {
      'launch_url': AppGlobal.getInstance().server,
      'launch_db': AppGlobal.getInstance().db,
      'launch_cid': AppGlobal.getInstance().user.security_id,
      'launch_category': category,
      'launch_uid': AppGlobal.getInstance().user.uid,
      'launch_sid': AppGlobal.getInstance().sid,
      'launch_mobile': AppGlobal.getInstance().user.login,
    };

    console.info(data);
    let security = cordova.require("cordova-plugin-security.Security");
    security.launch(data, function (info) {
    }, function (error) {
    });
  }
}
