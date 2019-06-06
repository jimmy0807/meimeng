import { Injectable } from '@angular/core';
import { Http } from '@angular/http';
import { AppGlobal } from '../app-global';
import 'rxjs/add/operator/map';

@Injectable()
export class ReportData {
  listData: any;

  constructor(public http: Http) { }

  getReportIndexDatas() {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/get_report_index_datas?sid=" + sid;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.listData = res.json();
        resolve(this.listData);
      });
    });
  }
  getEquityData(start, end) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/get_equity_data?sid=" + sid + "&start=" + start + "&end=" + end;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.listData = res.json();
        resolve(this.listData);
      });
    });
  }
  getIncomeData(start, end) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/get_income_data?sid=" + sid + "&start=" + start + "&end=" + end;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.listData = res.json();
        resolve(this.listData);
      });
    });
  }
  getSaleData(start, end) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/get_sale_data?sid=" + sid + "&start=" + start + "&end=" + end;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.listData = res.json();
        resolve(this.listData);
      });
    });
  }
  getPctData(start, end) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/get_pct_data?sid=" + sid + "&start=" + start + "&end=" + end;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.listData = res.json();
        resolve(this.listData);
      });
    });
  }
  getMemberNewData(start, end) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/get_member_new_data?sid=" + sid + "&start=" + start + "&end=" + end;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.listData = res.json();
        resolve(this.listData);
      });
    });
  }
}
