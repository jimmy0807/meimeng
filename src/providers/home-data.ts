import { Injectable } from '@angular/core';

import { Http } from '@angular/http';
import { AppGlobal } from '../app-global';
import { ApiHttp, ApiResult } from './api-http';

@Injectable()
export class HomeData {

  data: ApiResult;
  constructor(public http: Http,
    public api: ApiHttp) { }

  get_dashboard(refresher = false) {
    if (!refresher) {
      if (this.data) {
        return Promise.resolve(this.data);
      }
    }
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/get_dashboard";
    return new Promise(resolve => {
      let body = new FormData();
      body.append('sid', String(sid));
      this.http.post(url, body).subscribe(res => {
        this.data = res.json();
        resolve(this.data);
      });
    });
  }

  getRooms() {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/get_rooms?sid=" + sid;
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
}
