import { Injectable } from '@angular/core';
import { ApiHttp, ApiResult } from './api-http';

@Injectable()
export class MessageData {
  listData: ApiResult;

  constructor(public http: ApiHttp) { }

  async getMessages(offset, key = '', cat = '', limit = 20) {
    let p = {
      offset: offset,
      limit: limit,
    }
    if (cat)
      p['category'] = cat;
    if (key)
      p['class'] = key;
    return this.http.GetAsync('get_messages', p);
  }

  async getMessageCount() {
    return this.http.GetAsync('get_message_count');
  }

  async readMessage(ids: number[]) {
    let body = new FormData();
    body.append("ids", JSON.stringify(ids));
    return this.http.PostAsync('save_message', body, { state: 'unlink' })
  }

  async deleteMessage(ids: number[]) {
    let body = new FormData();
    body.append("ids", JSON.stringify(ids));
    return this.http.PostAsync('save_message', body, { active: 0 });
  }
}

export interface Message {
  content?: string;
  phone?: string;
  state?: string;
  shop_id?: number;
  shop_id_name?: string;
  title?: string;
  id?: number;
  create_date?: string;
  display_date?: string;
  category?: string;
  key?: string;
  value?: string;
}

export interface MessageCount {
  count?: number;
  badge?: string;

  reservation?: number;
  reservation_time?: string;
  commission?: number;
  commission_time?: string;
  system?: number;
  system_time?: string;
  quest?: number;
  quest_time?: string;

  cat1?: number[];
  cat2?: number[];
  cat3?: number[];
  cat4?: number[];
  cat5?: number[];
  cat6?: number[];
  cat7?: number[];
  cat8?: number[];
  cat9?: number[];
  cat10?: number[];
}
