import { Injectable } from '@angular/core';
import { Http } from '@angular/http';
import { AppGlobal } from '../app-global';
import 'rxjs/add/operator/map';

@Injectable()
export class CommissionRuleData {
  listData: any;

  constructor(public http: Http) { }

  getCommissionRules(offset) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/get_commission_rule_list?sid=" + sid + "&offset=" + offset;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.listData = res.json();
        resolve(this.listData);
      },
        err => {
          resolve({ errcode: 1, errmsg: '网络异常' });
        })
    });
  }

  saveCommissionRule(data) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/commission_rule_save";
    return new Promise(resolve => {
      let body = new FormData();
      body.append('sid', String(sid));
      body.append('name', data.name);
      body.append('sale_price_sel', data.sale_price_sel);
      body.append('is_total_special', String(data.is_total_special ? 1 : 0));
      body.append('fix_named', data.fix_named);
      body.append('percent_named', data.percent_named);
      body.append('fix_percent', data.fix_percent);
      body.append('active', String(data.active ? 1 : 0));
      body.append('total_special', data.total_special);
      this.http.post(url, body).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  updateCommissionRule(data) {

    //let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/commission_rule_update";
    return new Promise(resolve => {
      let body = new FormData();
      console.info(data);
      body.append('id', data.id);
      body.append('name', data.name);
      body.append('sale_price_sel', data.sale_price_sel);
      body.append('is_total_special', String(data.is_total_special ? 1 : 0));
      body.append('fix_named', data.fix_named);
      body.append('percent_named', data.percent_named);
      body.append('fix_percent', data.fix_percent);
      body.append('active', String(data.active ? 1 : 0));
      body.append('total_special', data.total_special);
      this.http.post(url, body).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }
}
