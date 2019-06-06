import { Injectable } from '@angular/core';

import { Http } from '@angular/http';
import { AppGlobal } from '../app-global';

@Injectable()
export class AuthData {

  data: any;
  constructor(public http: Http) { }

  getAuthorizationList(offset) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/authorization_list?sid=" + sid + "&offset=" + offset;
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

  updateAuthorization(params) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/authorization";
    return new Promise(resolve => {
      let body = new FormData();
      body.append('sid', String(sid));
      body.append('id', params.id);
      body.append('state', params.state);
      body.append('remark', params.remark);
      this.http.post(url, body).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

}
