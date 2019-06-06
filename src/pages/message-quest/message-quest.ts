import { Component } from '@angular/core';
import { NavController, NavParams } from 'ionic-angular';
import { MessageData, MessageCount } from '../../providers/message-data';
import { HomeData } from '../../providers/home-data';
import { MessageDetailPage } from '../message-detail/message-detail';
import { MessageDetailLinePage } from '../message-detail-line/message-detail-line';

@Component({
  selector: 'page-message-quest',
  templateUrl: 'message-quest.html'
})
export class MessageQuestPage {
  msgCount: MessageCount;
  dashboard: Dashboard = {};
  noItem: boolean = true;
  constructor(public navCtrl: NavController,
    public messageData: MessageData,
    public homeData: HomeData,
    public navParams: NavParams) {
    this.msgCount = navParams.data.count;
  }

  async ngAfterViewInit() {
    let r = await this.messageData.getMessageCount();
    if (r.errcode == 0) {
      for (let p in r.data)
        this.msgCount[p] = r.data[p];
      this.changeCount();
    }
    if (this.msgCount.cat5 || this.msgCount.cat6 || this.msgCount.cat7 || this.msgCount.cat8)
      this.get_dashboard();
    this.countItem();
  }

  countItem() {
    let cats = [4, 5, 6, 7, 8, 9, 10];
    this.noItem = !cats.some(c => this.msgCount['cat' + c]);
  }

  showPage(type: number) {
    switch (type) {
      case 4:
        this.navCtrl.push(MessageDetailLinePage, { mode: String(type), count: this.msgCount });
        break;
      case 5:
        this.readMessages(this.msgCount.cat5, type);
        this.navCtrl.push(MessageDetailPage, { mode: String(type), count: this.msgCount, members: this.dashboard.follow_member_ids });
        break;
      case 6:
        this.readMessages(this.msgCount.cat6, type);
        this.navCtrl.push(MessageDetailPage, { mode: String(type), count: this.msgCount, members: this.dashboard.follow_member_ids });
        break;
      case 7:
        this.navCtrl.push(MessageDetailLinePage, { mode: String(type), count: this.msgCount });
        break;
      case 8:
        let param = {
          'id': this.dashboard.kpi_id,
          'employee_id': this.dashboard.kpi_employee_id,
        }
        this.navCtrl.push(MessageDetailLinePage, { mode: String(type), count: this.msgCount, param: param });
        break;
      case 9:
        let kpi = {
          'id': this.dashboard.kpi_id,
          'employee_id': this.dashboard.kpi_employee_id,
        }
        this.readMessages(this.msgCount.cat9, type);
        this.navCtrl.push(MessageDetailPage, { mode: String(type), count: this.msgCount, kpi: kpi });
        break;
      case 10:
        this.navCtrl.push(MessageDetailLinePage, { mode: String(type), count: this.msgCount });
        break;
    }
  }

  readMessages(ids: number[], type: number) {
    let key = 'cat' + String(type);
    if (ids && ids.length > 0) {
      this.messageData.readMessage(ids).then(
        info => {
          let data: any = info;
          if (data.errcode == 0) {
            this.msgCount.count -= data.data.count;
            this.changeCount();
          }
        });
      this.msgCount[key] = undefined;
    }
  }

  changeCount() {
    let count = this.msgCount.count;
    if (count > 99)
      this.msgCount.badge = '99+';
    else if (count > 0)
      this.msgCount.badge = count.toString();
    else
      this.msgCount.badge = '';
  }

  get_dashboard() {
    if (this.dashboard) {
      return;
    }
    this.homeData.get_dashboard(true).then(
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
}

export interface Dashboard {
  period_name?: string;
  account_amount?: number;
  account_id?: number;
  commission_count?: number;
  commission_money?: string;
  customer_count?: number;
  follow_active_member_total?: number;
  follow_member_ids?: any[];
  follow_member_total?: number;
  follow_my_member_total?: number;
  month_account_amount?: string;
  month_account_id?: number;
  month_commission_count?: number;
  month_commission_money?: string;
  month_customer_count?: number;
  reservation_count?: number;
  reservation_create_date?: string;
  reservation_member_name?: string;
  reservation_product_name?: string;
  reservation_start_date?: string;
  reservation_technician_name?: string;
  reservation_telephone?: string;
  kpi_royalties_amt?: string;
  kpi_spending_amt?: string;
  current_member_cnt?: number;
  kpi_id?: number;
  kpi_employee_id?: number;
  success_qty?: number;
}
