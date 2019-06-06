import { Injectable } from '@angular/core';
import { Http } from '@angular/http';
import { AppGlobal } from '../app-global';


@Injectable()
export class PricelistData {
  listData: any;
  constructor(public http: Http) { }

  getPricelists() {
    let url = AppGlobal.getInstance().api + "/api/get_pricelists";
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

  getCouponTmpls() {
    let url = AppGlobal.getInstance().api + "/api/get_coupon_tmpl_list";
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.listData = res.json();
        resolve(this.listData);
      });
    });
  }

  savePricelist(data: Pricelist) {
    let url = AppGlobal.getInstance().api + "/api/save_pricelist";
    return new Promise(resolve => {
      let body = new FormData();
      body.append("name", data.name);
      if (data.id > 0)
        body.append("id", String(data.id));
      if (data.start_money)
        body.append("start_money", String(data.start_money));
      if (data.code)
        body.append("code", data.code);
      body.append("is_member_price", String(data.is_member_price ? 1 : 0));
      if (data.points_change_money)
        body.append("points_change_money", String(data.points_change_money));
      if (data.gift_amount_points)
        body.append("gift_amount_points", String(data.gift_amount_points));
      if (data.first_price_discount)
        body.append("first_price_discount", String(data.first_price_discount));
      if (data.product_points)
        body.append("product_points", String(data.product_points));
      if (data.recharge_points)
        body.append("recharge_points", String(data.recharge_points));
      if (data.course_points)
        body.append("course_points", String(data.course_points));
      if (data.refill_money)
        body.append("refill_money", String(data.refill_money));
      if (data.weika_id_first > 0)
        body.append("weika_id_first", String(data.weika_id_first));
      if (data.discount_days)
        body.append("discount_days", String(data.discount_days));
      if (data.weika_id_other > 0)
        body.append("weika_id_other", String(data.weika_id_other));
      if (data.company_id > 0)
        body.append("company_id", String(data.company_id));

      this.http.post(url, body).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  deletePricelist(id: number) {
    let url = AppGlobal.getInstance().api + "/api/delete_pricelist?id=" + id;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.listData = res.json();
        resolve(this.listData);
      });
    });
  }

  savePricelistItem(data: PricelistItem) {
    let url = AppGlobal.getInstance().api + "/api/save_pricelist_item";
    return new Promise(resolve => {
      let body = new FormData();
      if (data.id > 0)
        body.append("id", String(data.id));
      else
        body.append("pricelist_id", String(data.pricelist_id));
      body.append("name", data.name);
      body.append("applied_on", data.applied_on);
      body.append("first_price_discount", String(data.first_price_discount));
      body.append("sequence", String(data.sequence || 1000));

      switch (data.applied_on) {
        case '2_product_category':
          body.append("categ_id", String(data.categ_id)); break;
        case '1_product':
          body.append("product_tmpl_id", String(data.product_tmpl_id)); break;
        case '0_product_variant':
          body.append("product_id", String(data.product_id)); break;
        case '2_pos_category':
          body.append("pos_categ_id", String(data.pos_categ_id)); break;
      }

      this.http.post(url, body).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  deletePricelistItem(id: number) {
    let url = AppGlobal.getInstance().api + "/api/delete_pricelist_item?id=" + id;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.listData = res.json();
        resolve(this.listData);
      });
    });
  }

  getProductCategories(offset, keyword) {
    let url = AppGlobal.getInstance().api + "/api/get_product_categories?offset=" + offset;
    if (keyword)
      url += "&keyword=" + keyword;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.listData = res.json();
        resolve(this.listData);
      });
    });
  }

  getProducts(offset, keyword) {
    let url = AppGlobal.getInstance().api + "/api/get_products?offset=" + offset;
    if (keyword)
      url += "&keyword=" + keyword;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.listData = res.json();
        resolve(this.listData);
      });
    });
  }

  getProductVariants(offset, keyword) {
    let url = AppGlobal.getInstance().api + "/api/get_product_variants?offset=" + offset;
    if (keyword)
      url += "&keyword=" + keyword;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.listData = res.json();
        resolve(this.listData);
      });
    });
  }
  getPosCategories(offset, keyword) {
    let url = AppGlobal.getInstance().api + "/api/get_pos_categories?offset=" + offset;
    if (keyword)
      url += "&keyword=" + keyword;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.listData = res.json();
        resolve(this.listData);
      });
    });
  }

}

export interface Pricelist {
  start_money?: number;
  code?: string;
  is_member_price?: boolean;
  name?: string;
  points_change_money?: number;
  gift_amount_points?: number;
  first_price_discount?: number;
  product_points?: number;
  recharge_points?: number;
  company_id?: number;
  course_points?: number;
  refill_money?: number;
  shop_id?: boolean;
  company_name?: string;
  weika_id_first?: number;
  discount_days?: number;
  id?: number;
  weika_id_other?: number;
  items?: PricelistItem[];
  item_ids?: string;
}

export interface PricelistItem {
  id?: number;
  pricelist_id?: number;
  name?: string;
  first_price_discount?: number;
  sequence?: number;
  applied_on?: string;
  categ_id?: number;
  product_tmpl_id?: number,
  product_id?: number,
  pos_categ_id?: number,
  display_name?: string,
}