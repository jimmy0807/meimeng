import { Injectable } from '@angular/core';

import { Http } from '@angular/http';
import { AppGlobal } from '../app-global';

@Injectable()
export class RevenueData {

  constructor(public http: Http) { }

  getRevenueDay(offset) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/revenue_day?sid=" + sid + "&offset=" + offset;
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

  getRevenueMonth() {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/revenue_month?sid=" + sid;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  getRevenueOperates(param) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/get_revenue_operates?sid=" + sid + "&did=" + param.did + "&mid=" + param.mid;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }



}
