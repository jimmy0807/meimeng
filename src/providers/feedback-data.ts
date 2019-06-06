import { Injectable } from '@angular/core';

import { Http } from '@angular/http';
import { AppGlobal } from '../app-global';

@Injectable()
export class FeedbackData {

  constructor(public http: Http) { }

  getFeedbackList(offset) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/feedback_list?sid=" + sid + "&offset=" + offset;
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

  getFeedbackDetail(id) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/feedback_detail?sid=" + sid + "&id=" + id;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  addFeedBack(note, id) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/feedback_add";
    return new Promise(resolve => {
      let body = new FormData();
      body.append('note', note);
      body.append('id', id);
      body.append('sid', String(sid));
      this.http.post(url, body).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

}
