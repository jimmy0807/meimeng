import { Injectable } from '@angular/core';

import { Http } from '@angular/http';
import { AppGlobal } from '../app-global';

@Injectable()
export class ShopData {

  constructor(public http: Http) { }

  getShopList() {
    // let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/get_shopLists?";
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  getShopDetail(shopID) {
    let url = AppGlobal.getInstance().api + "/api/shop_detail?" + "id=" + shopID;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  updateShopData(data) {
    let url = AppGlobal.getInstance().api + "/api/update_shop";
    return new Promise(resolve => {
      let body = new FormData();
      body.append('id', data.id);
      body.append('name', data.name);
      body.append('street', data.street);
      body.append('mobile', data.mobile);
      body.append('phone', data.phone);
      body.append('brand', data.brand);

      this.http.post(url, body).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  createShopData(data) {
    let url = AppGlobal.getInstance().api + "/api/create_shop";
    return new Promise(resolve => {
      let body = new FormData();
      body.append('name', data.name ? 'undefined' : '');
      body.append('street', data.street ? 'undefined' : '');
      body.append('mobile', data.mobile ? 'undefined' : '');
      body.append('phone', data.phone ? 'undefined' : '');
      body.append('brand', data.brand ? 'undefined' : '');

      this.http.post(url, body).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  appandData(list, key, value) {

  }
}
