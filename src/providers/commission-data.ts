import { Injectable } from '@angular/core';

import { Http } from '@angular/http';
import { AppGlobal } from '../app-global';

import { ApiHttp, ApiResult } from './api-http';

@Injectable()
export class CommissionData {

  data: any;
  constructor(public http: Http,
    public api: ApiHttp) { }

  getCommissionDay(offset) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/commission_day?sid=" + sid + "&offset=" + offset;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        let data = res.json();
        resolve(data);
      },
        err => {
          resolve({ errcode: 1, errmsg: '网络异常' });
        })
    });
  }

  getCommissionMonth() {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/commission_month?sid=" + sid;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        let data = res.json();
        resolve(data);
      },
        err => {
          resolve({ errcode: 1, errmsg: '网络异常' });
        })
    });
  }

  getCommissionMonthDetail(id) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/commission_month_detail?sid=" + sid + "&id=" + id;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        let data = res.json();
        resolve(data);
      },
        err => {
          resolve({ errcode: 1, errmsg: '网络异常' });
        })
    });
  }


  async achievementDay(start: string = null, end: string = null) {
    let d = {
      sid: this.api.sid,
      eid: AppGlobal.getInstance().user.eid
    };
    if (start)
      d['start'] = start;
    if (end)
      d['end'] = end;
    return this.api.GetAsync('achievement_day', d);
  }

  async achievementMonth(start: string = null, end: string = null) {
    let d = {
      sid: this.api.sid,
      eid: AppGlobal.getInstance().user.eid
    };
    if (start)
      d['start'] = start;
    if (end)
      d['end'] = end;
    return this.api.GetAsync('achievement_month', d);
  }

  async achievementRange(start: string = null, end: string = null) {
    let d = {
      sid: this.api.sid,
      eid: AppGlobal.getInstance().user.eid
    };
    if (start)
      d['start'] = start;
    if (end)
      d['end'] = end;
    return this.api.GetAsync('achievement_range', d);
  }

  async getCommissionTeams() {
    let d = {
      detail: 1,
      sid: this.api.sid
    };
    return this.api.GetAsync('get_commission_teams', d);
  }
}

export interface TeamLine {
  amount?: number;
  parent_ids?: any[];
  manager_ids?: any[];
  employee_ids?: { name?: string, id?: number }[];
  id?: number;
  name?: string;
  visible?: boolean;
  detail?: boolean;
  sequence?: number;
}

export interface Achievement {
  date?: string;
  items?: TeamLine[];
  person?: number;
  people?: any;
}

