import { Injectable } from '@angular/core';
import { Http } from '@angular/http';
import 'rxjs/add/operator/map';
import { AppGlobal } from '../app-global';

@Injectable()
export class CompanyData {
  listData: any;
  constructor(public http: Http) {
    console.log('Hello CompanyData Provider');

  }
  getCompanyData() {
    let url = AppGlobal.getInstance().api + "/api/get_company";
    // console.log(url);
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        console.log(res);
        this.listData = res.json();
        resolve(this.listData);
      },
        err => {
          resolve({ errcode: 1, errmsg: '网络异常' });
        })
    });
  }

  updateCompanyData(data: CompanyLists) {
    //let sid = AppGlobal.getInstance().sid;

    let url = AppGlobal.getInstance().api + "/api/update_company";
    return new Promise(resolve => {
      // console.log('updateCompanyData');
      let body = new FormData();
      body.append('id', String(data.id));
      body.append('name', data.name);
      body.append('street', data.street);
      body.append('website', data.website);
      body.append('brand', data.brand);
      body.append('contact_name', data.contact_name);
      body.append('phone', data.phone);
      body.append('fax', data.fax);
      body.append('email', data.email);
      body.append('vat', data.vat);
      body.append('company_registry', data.company_registry);
      body.append('is_auto_weika', String(data.is_auto_weika ? 1 : 0));
      body.append('is_show_card_items', String(data.is_show_card_items ? 1 : 0));
      body.append('no_stock_sale', String(data.no_stock_sale ? 1 : 0));
      body.append('is_deposit', String(data.is_deposit ? 1 : 0));
      body.append('is_line_round', String(data.is_line_round ? 1 : 0));
      body.append('round_accuracy', String(data.round_accuracy));
      body.append('book_operate_time', String(data.book_operate_time));
      body.append('is_book_operate', String(data.is_book_operate ? 1 : 0));
      body.append('active_member_threshold', String(data.active_member_threshold));
      body.append('sleep_member_threshold', String(data.sleep_member_threshold));
      body.append('is_point_shop', String(data.is_point_shop ? 1 : 0));

      //body.append('sid', sid);
      // body.append('technician_id', data.technician_id);
      // body.append('description', data.description ? data.description : '');
      // body.append('start_date', data.start_date);
      // body.append('end_date', data.end_date);
      // body.append('product_ids', data.product_ids);
      // console.log('body:',body);
      this.http.post(url, body).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });

  }
}

export interface CompanyLists {
  id?: number;
  name?: string;
  //partner_id?: number,
  street?: string;
  website?: string;
  brand?: string;
  contact_name?: string;
  phone?: string;
  fax?: string;
  email?: string;
  vat?: string;
  company_registry?: string;
  //parent_id?:string;
  is_auto_weika?: boolean;
  is_show_card_items?: boolean;
  no_stock_sale?: boolean;
  is_deposit?: boolean;
  is_line_round?: boolean;
  round_accuracy?: number;
  book_operate_time?: number;
  is_book_operate?: boolean;
  active_member_threshold?: number;
  sleep_member_threshold?: number;
  is_point_shop?: boolean;
}