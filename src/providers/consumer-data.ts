import { Injectable } from '@angular/core';
import { ApiHttp, ApiResult } from './api-http';

@Injectable()
export class ConsumerData {
  listData: ApiResult;

  constructor(public http: ApiHttp) { }

  async getConsumerList(offset) {
    return this.http.GetAsync('get_userLists', { offset: offset });
  }

  async getConsumerDetail(consumerID) {
    return this.http.GetAsync('user_detail', { id: consumerID });
  }

  async getCompanyList() {
    return this.http.GetAsync('get_companyLists');
  }


  async updateConsumerData(data) {
    let body = new FormData();
    if (data.id > 0)
      body.append("id", data.id);
    if (data.name)
      body.append('name', data.name);
    if (data.login)
      body.append('login', data.login);
    if (data.password && data.password != "")
      body.append('password', data.password);
    if (data.role_option)
      body.append('role_option', data.role_option);
    if (data.company_id > 0)
      body.append('company_id', data.company_id);
    if (data.shop_id > 0)
      body.append('shop_id', data.shop_id);
    if (data.email)
      body.append('email', data.email);
    if (data.is_allow_login)
      body.append('is_allow_login', String(data.is_allow_login ? 1 : 0));
    if (data.shop_ids) {
      let shops = [];
      data.shop_ids.forEach(function (e) {
        shops.push(e.id);
      });
      body.append('shop_ids', shops.join(','));
    }
    return this.http.PostAsync('update_user', body);
  }

  async get_companylist() {
    return this.http.GetAsync('get_compnay_list_inuser');
  }

  async get_shopLists() {
    return this.http.GetAsync('get_shop_list_inuser');
  }
}

export interface ConsumerLists {
  id?: number;
  name?: string;
  login?: string;
  password?: string;
  role_option?: string;
  company_id?: number;
  company_name?: string;
  shop_id?: number;
  shop_name?: string;
  email?: string;
  is_allow_login?: boolean;
  login_date?: Date;
  shop_ids?: ShopLists[];
}

export interface ShopLists {
  id?: number;
  name?: string;
  active?: boolean;

}
