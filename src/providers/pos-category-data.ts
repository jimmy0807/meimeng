import { Injectable } from '@angular/core';

import { Http } from '@angular/http';
import { AppGlobal } from '../app-global';
import { ApiHttp, ApiResult } from './api-http';
@Injectable()
export class PosCategoryData {
  listData: any;
  r: ApiResult;
  constructor(public http: Http, public api: ApiHttp) { }

  getPosCategories(offset, keyword) {
    let p = {
      offset: offset,
    }
    if (keyword)
      p['keyword'] = keyword;
    return this.api.GetAsync('get_pos_categories', p);
  }

  savePosCategory(p: PosCategory) {
    let url = AppGlobal.getInstance().api + "/api/save_pos_category";
    return new Promise(resolve => {
      let body = new FormData();
      if (p.id > 0)
        body.append("id", String(p.id));
      body.append('name', p.name);
      if (p.parent_id)
        body.append('parent_id', String(p.parent_id));
      body.append('sequence', String(p.sequence || 0));
      body.append('description', p.description || '');

      this.http.post(url, body).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  deletePosCategory(id: number) {
    let url = AppGlobal.getInstance().api + "/api/delete_pos_category?id=" + id;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.listData = res.json();
        resolve(this.listData);
      });
    });
  }
}

export interface PosCategory {
  id?: number;
  name?: string;
  complete_name?: string;
  parent_id?: number;
  parent_name?: string;
  sequence?: number;
  description?: string;
}
