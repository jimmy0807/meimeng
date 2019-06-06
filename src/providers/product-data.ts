import { Injectable } from '@angular/core';

import { Http } from '@angular/http';
import { AppGlobal } from '../app-global';
import { ApiHttp, ApiResult } from './api-http';

@Injectable()
export class ProductData {
  products: any;
  listData: ApiResult;
  constructor(public http: Http,
    public api: ApiHttp) { }

  async getReservationProducts(offset, keyword, mid = null) {
    let p = {
      sid: this.api.sid,
      offset: offset,
      keyword: keyword
    }
    if (mid)
      p['mid'] = mid;
    return this.api.GetAsync('reservation_product', p);
  }

  getProductList(offset, keyword) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/get_product_list?sid=" + sid + "&offset=" + offset;
    if (keyword)
      url += "&keyword=" + keyword;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.products = res.json();
        resolve(this.products);
      },
        err => {
          resolve({ errcode: 1, errmsg: '网络异常' });
        })
    });
  }

  saveProduct(p: ProductTemplate) {
    let url = AppGlobal.getInstance().api + "/api/save_product";
    return new Promise(resolve => {

      let body = new FormData();
      if (p.id > 0)
        body.append("id", String(p.id));
      body.append('name', p.name);
      body.append('category_id', String(p.category_id));
      if (p.pos_categ_id)
        body.append('pos_categ_id', p.pos_categ_id);
      if (p.categ_id)
        body.append('categ_id', String(p.categ_id));
      body.append('list_price', String(p.list_price));
      body.append('member_price', String(p.member_price || 0));
      if (p.default_code)
        body.append('default_code', p.default_code);
      if (p.barcode)
        body.append('barcode', p.barcode);
      body.append('type', p.type);
      body.append('sale_ok', String(p.sale_ok ? 1 : 0));
      body.append('book_ok', String(p.book_ok ? 1 : 0));
      body.append('available_in_pos', String(p.available_in_pos ? 1 : 0));
      body.append('exchange', String(p.exchange || 0));

      body.append('percent_card', String(p.percent_card || 0));
      body.append('fix_card', String(p.fix_card || 0));
      body.append('percent_not_card', String(p.percent_not_card || 0));
      body.append('fix_not_card', String(p.fix_not_card || 0));
      body.append('do_percent', String(p.do_percent || 0));
      body.append('do_fix', String(p.do_fix || 0));
      body.append('limit_price', String(p.limit_price || 0));
      body.append('do_fix_gift', String(p.do_fix_gift || 0));
      body.append('fix_commission', String(p.fix_commission || 0));
      body.append('is_add', String(p.is_add ? 1 : 0));
      body.append('is_gift_commission', String(p.is_gift_commission ? 1 : 0));

      if (!(p.id > 0)) {
        switch (Number(p.category_code)) {
          case 2:
            if (p.consumables_ids.length > 0) {
              let ids = [];
              p.consumables_ids.forEach(i => ids.push({
                product_id: i.product_id,
                qty: i.qty,
              }));
              body.append('consumables_ids', JSON.stringify(ids));
            }
            break;
          case 3: case 4: case 5: case 6:
            if (p.pack_line_ids.length > 0) {
              let ids = [];
              p.pack_line_ids.forEach(i => ids.push({
                product_id: i.product_id,
                quantity: i.qty,
              }));
              body.append('pack_line_ids', JSON.stringify(ids));
            }
            break;
        }
      }

      this.http.post(url, body).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  deleteProduct(id: number) {
    let url = AppGlobal.getInstance().api + "/api/delete_product?id=" + id;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.listData = res.json();
        resolve(this.listData);
      });
    });
  }

  addPackLines(prd_id, lines: ProductLine[]) {
    let url = AppGlobal.getInstance().api + "/api/add_lines";
    return new Promise(resolve => {
      let body = new FormData();
      body.append("id", prd_id);
      let ids = [];
      lines.forEach(i => ids.push({
        product_id: i.product_id,
        quantity: i.qty || 1,
      }));
      body.append('pack_line_ids', JSON.stringify(ids));
      this.http.post(url, body).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  addConsumeLines(prd_id, lines: ProductLine[]) {
    let url = AppGlobal.getInstance().api + "/api/add_lines";
    return new Promise(resolve => {
      let body = new FormData();
      body.append("id", prd_id);
      let ids = [];
      lines.forEach(i => ids.push({
        product_id: i.product_id,
        qty: i.qty || 1,
      }));
      body.append('consumables_ids', JSON.stringify(ids));
      this.http.post(url, body).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  savePackLine(p: ProductLine) {
    let url = AppGlobal.getInstance().api + "/api/save_pack_line";
    return new Promise(resolve => {
      let body = new FormData();
      body.append("id", String(p.id));
      body.append('product_id', String(p.product_id));
      body.append('quantity', String(p.qty));
      body.append('is_show_more', String(p.is_show_more ? 1 : 0));
      body.append('limited_qty', String(p.limited_qty ? 1 : 0));
      body.append('same_price_replace', String(p.same_price_replace ? 1 : 0));
      body.append('limited_date', String(p.limited_date || 0));
      let same_ids = [];
      if (p.same_ids)
        same_ids = p.same_ids.map(i => i.id);
      body.append('same_ids', JSON.stringify(same_ids));
      this.http.post(url, body).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  deletePackLine(id: number) {
    let url = AppGlobal.getInstance().api + "/api/delete_pack_line?id=" + id;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.listData = res.json();
        resolve(this.listData);
      });
    });
  }

  saveConsumeLine(p: ProductLine) {
    let url = AppGlobal.getInstance().api + "/api/save_consume_line";
    return new Promise(resolve => {
      let body = new FormData();
      body.append("id", String(p.id));
      body.append('product_id', String(p.product_id));
      body.append('qty', String(p.qty));
      this.http.post(url, body).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  deleteConsumeLine(id: number) {
    let url = AppGlobal.getInstance().api + "/api/delete_consume_line?id=" + id;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.listData = res.json();
        resolve(this.listData);
      });
    });
  }

  getBornCategories() {
    let url = AppGlobal.getInstance().api + "/api/get_born_categories";
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.listData = res.json();
        resolve(this.listData);
      });
    });
  }

  getConsumeProduct(offset, keyword) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/get_product_variants?sid=" + sid + "&type=normal&pre=0&offset=" + offset;
    if (keyword)
      url += "&keyword=" + keyword;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.listData = res.json();
        resolve(this.listData);
      });
    });
  }

  getPackProduct(offset, keyword) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/get_product_variants?sid=" + sid + "&type=normal&offset=" + offset;
    if (keyword)
      url += "&keyword=" + keyword;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.listData = res.json();
        resolve(this.listData);
      });
    });
  }

  getSameProduct(offset, keyword) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/get_product_variants?sid=" + sid + "&born_category=2&offset=" + offset;
    if (keyword)
      url += "&keyword=" + keyword;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.listData = res.json();
        resolve(this.listData);
      });
    });
  }

  async getAllProduct(offset = 0, keyword = null) {
    let p = {
      sid: this.api.sid,
      offset: offset,
    }
    if (keyword)
      p['keyword'] = keyword;
    return this.api.GetAsync('get_product_variants', p)
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

  getProductCategories() {
    let url = AppGlobal.getInstance().api + "/api/get_product_categories";
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.listData = res.json();
        resolve(this.listData);
      });
    });
  }
}

export interface ProductLine {
  id?: number;
  tmpl_id?: number;
  product_id?: number;
  product_name?: string;
  lst_price?: number;
  qty?: number;
  is_show_more?: boolean;
  limited_qty?: boolean;
  limited_date?: number;
  same_ids?: any[];
  same_price_replace?: boolean;
}

export interface ProductTemplate {
  id?: number;
  name?: string;
  category_id?: number;
  category_name?: string;
  category_code?: number;
  pos_categ_id?: string;
  pos_categ_name?: string;
  list_price?: number;
  member_price?: number;
  image_url?: string;
  default_code?: string;
  barcode?: string;
  type?: string;
  sale_ok?: boolean;
  book_ok?: boolean;
  available_in_pos?: boolean;
  exchange?: number;
  pack_line_ids?: ProductLine[];
  consumables_ids?: ProductLine[];
  categ_id?: number;
  percent_card?: number;
  fix_card?: number;
  percent_not_card?: number;
  fix_not_card?: number;
  do_percent?: number;
  do_fix?: number;
  limit_price?: number;
  is_add?: boolean;
  do_fix_gift?: number;
  is_gift_commission?: boolean;
  fix_commission?: number;

  checked?: boolean;
}
