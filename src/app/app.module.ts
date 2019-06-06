import { NgModule, ErrorHandler } from '@angular/core';
import { IonicApp, IonicModule, IonicErrorHandler } from 'ionic-angular';
import { DsApp } from './app.component';
import { BrowserModule } from '@angular/platform-browser'
import { HttpModule } from '@angular/http';
import { SplashScreen } from '@ionic-native/splash-screen';
import { Network } from '@ionic-native/network';
import { StatusBar } from '@ionic-native/status-bar';
import { Keyboard } from '@ionic-native/keyboard';
import { Device } from '@ionic-native/device';
import { NativeStorage } from '@ionic-native/native-storage';
import { Camera } from '@ionic-native/camera';
import { BLE } from '@ionic-native/ble';
import { SMS } from '@ionic-native/sms';
import { CallNumber } from '@ionic-native/call-number';
import { BarcodeScanner } from '@ionic-native/barcode-scanner';
import { PhotoLibrary } from '@ionic-native/photo-library';
import { Badge } from '@ionic-native/badge';
import { QRScanner } from '@ionic-native/qr-scanner';
import { Alipay } from '@ionic-native/alipay';

import { ReservationProductPage } from '../pages/reservation-product/reservation-product';
import { KpiFeaturedDetailPage } from '../pages/kpi-featured-detail/kpi-featured-detail';
import { CommissionDetailPage } from '../pages/commission-detail/commission-detail';
import { CommissionMonthPage } from '../pages/commission-month/commission-month';
import { ReservationTimePage } from '../pages/reservation-time/reservation-time';
import { ReservationAddPage } from '../pages/reservation-add/reservation-add';
import { FeedbackDetailPage } from '../pages/feedback-detail/feedback-detail';
import { KpiNewcustomerPage } from '../pages/kpi-newcustomer/kpi-newcustomer';
import { AuthorizationPage } from '../pages/authorization/authorization';
import { AuthorizationDetailPage } from '../pages/authorization-detail/authorization-detail';

import { FollowEmployeePage } from '../pages/follow-employee/follow-employee';
import { MemberPage } from '../pages/member/member';
import { MemberDetailPage } from '../pages/member-detail/member-detail';
import { FollowMemberPage } from '../pages/follow-member/follow-member';
import { KpiFeaturedPage } from '../pages/kpi-featured/kpi-featured';
import { KpiIncomingPage } from '../pages/kpi-incoming/kpi-incoming';
import { FollowPlanPage } from '../pages/follow-plan/follow-plan';
import { ApplicationPage } from '../pages/application/application';
import { ReservationPage } from '../pages/reservation/reservation';
import { PopoverPage } from '../pages/about-popover/about-popover';
import { KpiOperatePage } from '../pages/kpi-operate/kpi-operate';
import { KpiRecordPage } from '../pages/kpi-record/kpi-record';
import { CommissionPage } from '../pages/commission/commission';
import { KpiMemberPage } from '../pages/kpi-member/kpi-member';
import { CommunityPage } from '../pages/community/community';
import { KpiAllotPage } from '../pages/kpi-allot/kpi-allot';
import { TutorialPage } from '../pages/tutorial/tutorial';
import { EmployeePage } from '../pages/employee/employee';
import { FeedbackPage } from '../pages/feedback/feedback';
import { LoadingPage } from '../pages/loading/loading';
import { SettingPage } from '../pages/setting/setting';
import { RankingPage } from '../pages/ranking/ranking';
import { RevenuePage } from '../pages/revenue/revenue';
import { FollowPage } from '../pages/follow/follow';
import { AboutPage } from '../pages/about/about';
import { AboutDetailPage } from '../pages/about-detail/about-detail';
import { AboutConfigPage } from '../pages/about-config/about-config';
import { AboutPermissionPage } from '../pages/about-permission/about-permission';
import { AboutEditPage } from '../pages/about-edit/about-edit';
import { AboutImagePage } from '../pages/about-image/about-image';
import { LoginPage } from '../pages/login/login';
import { VisitPage } from '../pages/visit/visit';
import { HomePage } from '../pages/home/home';
import { TabsPage } from '../pages/tabs/tabs';
import { ShopPage } from '../pages/shop/shop';
import { KpiPage } from '../pages/kpi/kpi';
import { BlePage } from '../pages/ble/ble';
import { RoomPage } from '../pages/room/room';
import { ShopManagerPage } from '../pages/shop-manager/shop-manager';
import { ShopManagerDetailPage } from '../pages/shop-manager-detail/shop-manager-detail';
import { CommissionRulePage } from '../pages/commission-rule/commission-rule';
import { CommissionRuleDetailPage } from '../pages/commission-rule-detail/commission-rule-detail';
import { DeviceAccessPage } from '../pages/device-access/device-access';
import { DeviceAccessDetailPage } from '../pages/device-access-detail/device-access-detail';
import { UsersMamagerPage } from '../pages/users-mamager/users-mamager';
import { UsersMamagerDetailPage } from '../pages/users-mamager-detail/users-mamager-detail';
import { UserPermitshopPage } from '../pages/user-permitshop/user-permitshop';
import { UserPermitscompanyPage } from '../pages/user-permitscompany/user-permitscompany';
import { PricelistPage } from '../pages/pricelist/pricelist';
import { PricelistDetailPage } from '../pages/pricelist-detail/pricelist-detail';
import { PricelistItemsPage } from '../pages/pricelist-items/pricelist-items';
import { PricelistItemsDetailPage } from '../pages/pricelist-items-detail/pricelist-items-detail';
import { CompanyPage } from '../pages/company/company';
import { CompanyDetailPage } from '../pages/company-detail/company-detail';
import { RevenueOperatePage } from '../pages/revenue-operate/revenue-operate';
import { MessagePage } from '../pages/message/message';
import { MessageListPage } from '../pages/message-list/message-list';
import { MessageDetailPage } from '../pages/message-detail/message-detail';
import { MessageQuestPage } from '../pages/message-quest/message-quest';
import { MessageMemberPage } from '../pages/message-member/message-member';
import { MessageDetailLinePage } from '../pages/message-detail-line/message-detail-line';
import { ScheduleEmployeePage } from '../pages/schedule-employee/schedule-employee';
import { SchedulePage } from '../pages/schedule/schedule';
import { ReportIndexPage } from '../pages/report-index/report-index';
import { ProductPage } from '../pages/product/product';
import { ProductDetailPage } from '../pages/product-detail/product-detail';
import { ProductDetailLinePage } from '../pages/product-detail-line/product-detail-line';
import { ProductDetailSelectorPage } from '../pages/product-detail-selector/product-detail-selector';
import { PosCategoryPage } from '../pages/pos-category/pos-category';
import { PosCategoryDetailPage } from '../pages/pos-category-detail/pos-category-detail';
import { ReportEquityPage } from '../pages/report-equity/report-equity';
import { ReportIncomePage } from '../pages/report-income/report-income';
import { ReportSalePage } from '../pages/report-sale/report-sale';
import { ReportPctPage } from '../pages/report-pct/report-pct';
import { ReportMemberNewPage } from '../pages/report-member-new/report-member-new';
import { ReportFilterPage } from '../pages/report-filter/report-filter';
import { EmployeeListPage } from '../pages/employee-list/employee-list';
import { EmployeeDetailPage } from '../pages/employee-detail/employee-detail';
import { EmployeeSelectorPage } from '../pages/employee-selector/employee-selector';
import { MemberListPage } from '../pages/member-list/member-list';
import { MemberAddPage } from '../pages/member-add/member-add';
import { MemberFilterPage } from '../pages/member-filter/member-filter';
import { MemberSelectorPage } from '../pages/member-selector/member-selector';
import { MemberCardsPage } from '../pages/member-cards/member-cards';
import { MemberCardDetailPage } from '../pages/member-card-detail/member-card-detail';
import { MemberCardLinePage } from '../pages/member-card-line/member-card-line';
import { MemberCardArrearsPage } from '../pages/member-card-arrears/member-card-arrears';
import { MemberDetailTypesPage } from '../pages/member-detail-types/member-detail-types';
import { MemberDetailListPage } from '../pages/member-detail-list/member-detail-list';

import { SmsPage } from '../pages/sms/sms';
import { SmsSelectorPage } from '../pages/sms-selector/sms-selector';
import { SmsTemplatePage } from '../pages/sms-template/sms-template';
import { SmsTemplateEditPage } from '../pages/sms-template-edit/sms-template-edit';

import { SmsIndexPage } from '../pages/sms-index/sms-index';
import { SmsTemplateListPage } from '../pages/sms-template-list/sms-template-list';
import { SmsTemplateDetailPage } from '../pages/sms-template-detail/sms-template-detail';
import { SmsSignDetailPage } from '../pages/sms-sign-detail/sms-sign-detail';
import { SmsConfigPage } from '../pages/sms-config/sms-config';
import { SmsConfigDetailPage } from '../pages/sms-config-detail/sms-config-detail';
import { SmsCategoryPage } from '../pages/sms-category/sms-category';
import { SmsDetailPage } from '../pages/sms-detail/sms-detail';

import { StockPage } from '../pages/stock/stock';
import { StockLocationPage } from '../pages/stock-location/stock-location';
import { StockLocationDetailPage } from '../pages/stock-location-detail/stock-location-detail';
import { StockWarehousePage } from '../pages/stock-warehouse/stock-warehouse';
import { StockInternalPage } from '../pages/stock-internal/stock-internal';
import { StockInternalDetailPage } from '../pages/stock-internal-detail/stock-internal-detail';
import { StockProductPage } from '../pages/stock-product/stock-product';
import { StockPartnerPage } from '../pages/stock-partner/stock-partner';
import { StockInventoryPage } from '../pages/stock-inventory/stock-inventory';
import { StockInventoryDetailPage } from '../pages/stock-inventory-detail/stock-inventory-detail';

import { PartnerPage } from '../pages/partner/partner';
import { PartnerDetailPage } from '../pages/partner-detail/partner-detail';
import { PartnerDetailImagePage } from '../pages/partner-detail-image/partner-detail-image';
import { MedicalIndexPage } from '../pages/medical-index/medical-index';
import { MedicalAdvisoryPage } from '../pages/medical-advisory/medical-advisory';
import { MedicalAdvisoryDetailPage } from '../pages/medical-advisory-detail/medical-advisory-detail';
import { MedicalCustomerPage } from '../pages/medical-customer/medical-customer';
import { MedicalCustomerDetailPage } from '../pages/medical-customer-detail/medical-customer-detail';
import { MedicalSelectorPage } from '../pages/medical-selector/medical-selector';
import { MedicalSplitPage } from '../pages/medical-split/medical-split';
import { MedicalSplitDetailPage } from '../pages/medical-split-detail/medical-split-detail';

import { ApiHttp } from '../providers/api-http';

import { ReservationData } from '../providers/reservation-data';
import { CommissionData } from '../providers/commission-data';
import { PeferenceData } from '../providers/reference-data';
import { EmployeeData } from '../providers/employee-data';
import { FeedbackData } from '../providers/feedback-data';
import { ProductData } from '../providers/product-data';
import { PosCategoryData } from '../providers/pos-category-data';
import { RevenueData } from '../providers/revenue-data';
import { HomeData } from '../providers/home-data';
import { UserData } from '../providers/user-data';
import { KpiData } from '../providers/kpi-data';
import { AuthData } from '../providers/auth-data';
import { CommissionRuleData } from '../providers/commission-rule-data';
import { ShopData } from '../providers/shop-data';
import { DeviceData } from '../providers/device-data'
import { PricelistData } from '../providers/pricelist-data';
import { ConsumerData } from '../providers/consumer-data';
import { CompanyData } from '../providers/company-data';
import { MemberData } from '../providers/member-data';
import { MessageData } from '../providers/message-data';
import { ReportData } from '../providers/report-data';
import { SmsData } from '../providers/sms-data';
import { StockData } from '../providers/stock-data';
import { PartnerData } from '../providers/partner-data';
import { VisitData } from '../providers/visit-data';
import { MedicalData } from '../providers/medical-data';
import { ChartModule } from 'ng2-chartjs2';
import { ZimgProvider } from '../providers/zimg';
import { EventData } from '../providers/event-data';
import { ChargeData } from '../providers/charge-data';

@NgModule({
  declarations: [
    DsApp,
    AboutPage,
    AboutEditPage,
    AboutImagePage,
    AboutDetailPage,
    AboutConfigPage,
    AboutPermissionPage,
    CommunityPage,
    HomePage,
    TutorialPage,
    LoadingPage,
    TabsPage,
    LoginPage,
    SettingPage,
    ShopPage,
    ReservationPage,
    ReservationAddPage,
    ReservationProductPage,
    EmployeePage,
    PopoverPage,
    ApplicationPage,
    CommissionPage,
    FollowPage,
    FeedbackPage,
    RevenuePage,
    ReservationTimePage,
    CommissionDetailPage,
    CommissionMonthPage,
    FeedbackDetailPage,
    MemberPage,
    MemberDetailPage,
    KpiAllotPage,
    RankingPage,
    KpiPage,
    KpiMemberPage,
    FollowMemberPage,
    FollowPlanPage,
    KpiOperatePage,
    FollowEmployeePage,
    KpiFeaturedPage,
    KpiFeaturedDetailPage,
    KpiRecordPage,
    VisitPage,
    KpiIncomingPage,
    KpiNewcustomerPage,
    BlePage,
    RoomPage,
    AuthorizationPage,
    AuthorizationDetailPage,
    ShopManagerPage,
    ShopManagerDetailPage,
    CommissionRulePage,
    CommissionRuleDetailPage,
    DeviceAccessPage,
    DeviceAccessDetailPage,
    UsersMamagerPage,
    UsersMamagerDetailPage,
    UserPermitshopPage,
    UserPermitscompanyPage,
    PricelistPage,
    PricelistDetailPage,
    PricelistItemsPage,
    PricelistItemsDetailPage,
    CompanyPage,
    CompanyDetailPage,
    RevenueOperatePage,
    MessagePage,
    MessageListPage,
    MessageDetailPage,
    MessageQuestPage,
    MessageMemberPage,
    MessageDetailLinePage,
    ScheduleEmployeePage,
    SchedulePage,
    ReportIndexPage,
    ProductPage,
    ProductDetailPage,
    ProductDetailLinePage,
    ProductDetailSelectorPage,
    PosCategoryPage,
    PosCategoryDetailPage,
    ReportEquityPage,
    ReportIncomePage,
    ReportSalePage,
    ReportPctPage,
    ReportMemberNewPage,
    ReportFilterPage,
    MemberListPage,
    MemberAddPage,
    MemberFilterPage,
    MemberSelectorPage,
    MemberCardsPage,
    MemberCardLinePage,
    MemberCardDetailPage,
    MemberCardArrearsPage,
    MemberDetailListPage,
    MemberDetailTypesPage,

    EmployeeListPage,
    EmployeeDetailPage,
    EmployeeSelectorPage,
    SmsPage,
    SmsSelectorPage,
    SmsTemplateEditPage,
    SmsTemplatePage,
    SmsIndexPage,
    SmsTemplateListPage,
    SmsTemplateDetailPage,
    SmsSignDetailPage,
    SmsConfigPage,
    SmsConfigDetailPage,
    SmsCategoryPage,
    SmsDetailPage,

    StockPage,
    StockLocationPage,
    StockLocationDetailPage,
    StockWarehousePage,
    StockInternalPage,
    StockInternalDetailPage,
    StockPartnerPage,
    StockProductPage,
    StockInventoryPage,
    StockInventoryDetailPage,

    PartnerPage,
    PartnerDetailPage,
    PartnerDetailImagePage,
    MedicalIndexPage,
    MedicalAdvisoryPage,
    MedicalAdvisoryDetailPage,
    MedicalCustomerPage,
    MedicalCustomerDetailPage,
    MedicalSplitPage,
    MedicalSplitDetailPage,
    MedicalSelectorPage,
  ],
  imports: [
    BrowserModule,
    HttpModule,
    IonicModule.forRoot(DsApp, {
      backButtonText: '返回',
      tabsPlacement: 'bottom',
      tabsHideOnSubPages: true,
    }),
    ChartModule
  ],
  bootstrap: [IonicApp],
  entryComponents: [
    DsApp,
    AboutPage,
    AboutEditPage,
    AboutImagePage,
    AboutDetailPage,
    AboutConfigPage,
    AboutPermissionPage,
    CommunityPage,
    HomePage,
    TutorialPage,
    LoadingPage,
    TabsPage,
    LoginPage,
    SettingPage,
    ShopPage,
    ReservationPage,
    ReservationAddPage,
    ReservationProductPage,
    EmployeePage,
    PopoverPage,
    ApplicationPage,
    CommissionPage,
    FollowPage,
    FeedbackPage,
    RevenuePage,
    ReservationTimePage,
    CommissionDetailPage,
    CommissionMonthPage,
    FeedbackDetailPage,
    MemberPage,
    MemberDetailPage,
    KpiAllotPage,
    RankingPage,
    KpiPage,
    KpiMemberPage,
    FollowMemberPage,
    FollowPlanPage,
    KpiOperatePage,
    FollowEmployeePage,
    KpiFeaturedPage,
    KpiFeaturedDetailPage,
    KpiRecordPage,
    VisitPage,
    KpiIncomingPage,
    KpiNewcustomerPage,
    BlePage,
    RoomPage,
    AuthorizationPage,
    AuthorizationDetailPage,
    ShopManagerPage,
    ShopManagerDetailPage,
    CommissionRulePage,
    CommissionRuleDetailPage,
    DeviceAccessPage,
    DeviceAccessDetailPage,
    UsersMamagerPage,
    UsersMamagerDetailPage,
    UserPermitshopPage,
    UserPermitscompanyPage,
    PricelistPage,
    PricelistDetailPage,
    PricelistItemsPage,
    PricelistItemsDetailPage,
    CompanyPage,
    CompanyDetailPage,
    RevenueOperatePage,
    MessagePage,
    MessageListPage,
    MessageDetailPage,
    MessageQuestPage,
    MessageMemberPage,
    MessageDetailLinePage,
    ScheduleEmployeePage,
    SchedulePage,
    ReportIndexPage,
    ProductPage,
    ProductDetailPage,
    ProductDetailLinePage,
    ProductDetailSelectorPage,
    PosCategoryPage,
    PosCategoryDetailPage,
    ReportEquityPage,
    ReportIncomePage,
    ReportSalePage,
    ReportPctPage,
    ReportMemberNewPage,
    ReportFilterPage,
    MemberListPage,
    MemberAddPage,
    MemberFilterPage,
    MemberSelectorPage,
    MemberCardsPage,
    MemberCardLinePage,
    MemberCardDetailPage,
    MemberCardArrearsPage,
    MemberDetailListPage,
    MemberDetailTypesPage,

    EmployeeListPage,
    EmployeeDetailPage,
    EmployeeSelectorPage,
    SmsPage,
    SmsSelectorPage,
    SmsTemplateEditPage,
    SmsTemplatePage,
    SmsIndexPage,
    SmsTemplateListPage,
    SmsTemplateDetailPage,
    SmsSignDetailPage,
    SmsConfigPage,
    SmsConfigDetailPage,
    SmsCategoryPage,
    SmsDetailPage,

    StockPage,
    StockLocationPage,
    StockLocationDetailPage,
    StockWarehousePage,
    StockInternalPage,
    StockInternalDetailPage,
    StockPartnerPage,
    StockProductPage,
    StockInventoryPage,
    StockInventoryDetailPage,

    PartnerPage,
    PartnerDetailPage,
    PartnerDetailImagePage,
    MedicalIndexPage,
    MedicalAdvisoryPage,
    MedicalAdvisoryDetailPage,
    MedicalCustomerPage,
    MedicalCustomerDetailPage,
    MedicalSplitPage,
    MedicalSplitDetailPage,
    MedicalSelectorPage,
  ],
  providers: [
    BarcodeScanner,
    BLE,
    CallNumber,
    Camera,
    Device,
    Keyboard,
    NativeStorage,
    Network,
    SMS,
    SplashScreen,
    StatusBar,
    PhotoLibrary,
    Badge,
    QRScanner,
    Alipay,

    ApiHttp,
    KpiData,
    FeedbackData,
    RevenueData,
    PeferenceData,
    UserData,
    HomeData,
    ReservationData,
    EmployeeData,
    ProductData,
    PosCategoryData,
    CommissionData,
    AuthData,
    CommissionRuleData,
    ShopData,
    DeviceData,
    PricelistData,
    ConsumerData,
    CompanyData,
    MemberData,
    MessageData,
    ReportData,
    SmsData,
    StockData,
    PartnerData,
    VisitData,
    MedicalData,
    EventData,
    ChargeData,
    { provide: ErrorHandler, useClass: IonicErrorHandler },
    ZimgProvider]
})
export class AppModule { }

