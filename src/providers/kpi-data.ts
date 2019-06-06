import { Injectable } from '@angular/core';
import { AppGlobal } from '../app-global';
import { Http } from '@angular/http';

@Injectable()
export class KpiData {
  data: any;
  products: any;
  constructor(public http: Http) { }

  getKpiList(params, order) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/get_kpi_list?sid=" + sid + "&month=" + params.month + "&year=" + params.year + "&order=" + order;
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

  getFeaturedProduct(params) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/get_featured_product?sid=" + sid + "&month=" + params.month + "&year=" + params.year;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  getEmployeeKpi(params) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/get_employee_kpi?sid=" + sid + "&month=" + params.month + "&year=" + params.year + "&eid=" + params.eid;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  deleteEmployeeKpi(kid) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/delete_employee_kpi?sid=" + sid + "&kid=" + kid;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  updateEmployeeKpi(params) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/update_employee_kpi";
    return new Promise(resolve => {
      let body = new FormData();
      body.append('sid', String(sid));
      body.append('month', params.month);
      body.append('year', params.year);
      body.append('eid', params.eid);
      body.append('kid', params.kid);
      body.append('royalties', params.royalties);
      body.append('spending', params.spending);
      body.append('operate', params.operate);
      body.append('new_card', params.new_card);
      body.append('customer', params.customer);
      body.append('kpi_type', params.kpi_type);

      this.http.post(url, body).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  copyfeaturedProduct(params) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/dump_featured_kpi?sid=" + sid + "&month=" + params.month + "&year=" + params.year;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  cancelFeaturedProduct(params) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/cancel_featured?sid=" + sid + "&pid=" + params.pid + "&fid=" + params.fid;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  updateFeaturedProduct(params) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/update_featured?sid=" + sid + "&month=" + params.month + "&year=" + params.year + "&pid=" + params.pid;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  getFollowProduct(params, offset, keyword) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/get_follow_product?sid=" + sid + "&month=" + params.month + "&year=" + params.year + "&offset=" + offset + "&keyword=" + keyword;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  getKpi(params) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/get_kpi?sid=" + sid + "&kid=" + params.kid;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  getKpiRecord(params, offset) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/get_kpi_record?sid=" + sid + "&eid=" + params.eid + "&offset=" + offset;
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

  getKpiMember(kid) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/get_kpi_member?sid=" + sid + "&kid=" + kid;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  getKpiMemberInfo(kid, mid) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/get_kpi_member_info?sid=" + sid + "&kid=" + kid + "&mid=" + mid;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  saveKpiMemberInfo(params) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/save_kpi_member_info";
    return new Promise(resolve => {
      let body = new FormData();
      body.append('sid', String(sid));
      body.append('id', params.id);
      body.append('planning_id', params.planning_id);
      body.append('member_id', params.member_id);
      body.append('recharge_amount', params.recharge_amount);
      body.append('card_products', params.card_products);
      body.append('featured_products', params.featured_products);
      body.append('other_amount', params.other_amount);
      this.http.post(url, body).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }


  getKpiOperates(params) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/get_kpi_operates?sid=" + sid + "&kid=" + params.kid;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  getProductSaleinfo(params) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/get_product_saleinfo?sid=" + sid + "&pid=" + params.pid + "&fid=" + params.fid;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  getMemberPos(params) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/get_member_pos?sid=" + sid + "&pid=" + params.pid;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  getKpiMemberinfo(params) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/get_kpi_memberinfo?sid=" + sid + "&mid=" + params.mid;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  saveKpiRecord(params) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/save_kpi_record";
    return new Promise(resolve => {
      let body = new FormData();
      body.append('sid', String(sid));
      body.append('planning_id', params.planning_id);
      body.append('is_success', params.is_success);
      body.append('note', params.note);
      body.append('type', params.type);
      body.append('reservation_id', params.reservation_id);
      this.http.post(url, body).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  getKpiPosIncoming(params) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/get_kpi_pos_incoming?sid=" + sid + "&kid=" + params.kid;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  getKpiPosNewcustomer(params) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/get_kpi_pos_newcustomer?sid=" + sid + "&kid=" + params.kid;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }
}
