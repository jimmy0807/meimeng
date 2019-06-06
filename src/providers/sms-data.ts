import { Injectable } from '@angular/core';

import { Http } from '@angular/http';
import { AppGlobal } from '../app-global';
import { ApiHttp, ApiResult } from './api-http'

@Injectable()
export class SmsData {
  data: ApiResult;
  constructor(public http: Http, public apiHttp: ApiHttp) {
  }

  getSmsList(offset: number = 0) {
    let sid = AppGlobal.getInstance().sid;
    let cid = AppGlobal.getInstance().user.company_id;
    let url = AppGlobal.getInstance().api + "/api/get_sms_list?sid=" + sid + "&cid=" + cid + "&offset=" + offset;
    return new Promise(resolve => {
      this.http.get(url).subscribe(
        res => {
          this.data = res.json();
          resolve(this.data);
        },
        err => {
          resolve({ errcode: 1, errmsg: '网络异常' });
        })
    });
  }

  async getAllBirthday() {
    return this.apiHttp.GetAsync("get_all_birthday", { sid: this.apiHttp.sid });
  }

  async getSmsConfigList() {
    let cid = AppGlobal.getInstance().user.company_id;
    return this.apiHttp.GetAsync("get_sms_config_list", { cid: cid });
  }

  getSmsTemplateCategoryList() {
    let sid = AppGlobal.getInstance().sid;
    let cid = AppGlobal.getInstance().user.company_id;
    let url = AppGlobal.getInstance().api + "/api/get_sms_template_category_list?sid=" + sid + "&cid=" + cid;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.data = res.json();
        resolve(this.data);
      },
        err => {
          resolve({ errcode: 1, errmsg: '网络异常' });
        })
    });
  }

  saveSmsCategory(cat) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/save_sms_category?sid=" + sid;
    return new Promise(resolve => {
      let body = new FormData();
      if (cat.id)
        body.append('id', cat.id);
      body.append('name', cat.name);
      this.http.post(url, body).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  deleteSmsCategory(id: number) {
    let url = AppGlobal.getInstance().api + "/api/delete_sms_category?id=" + id;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.data = res.json();
        resolve(this.data);
      });
    });
  }

  getSmsTemplateList(cat_id: number) {
    let sid = AppGlobal.getInstance().sid;
    let cid = AppGlobal.getInstance().user.company_id;
    let url = AppGlobal.getInstance().api + "/api/get_sms_template_list?sid=" + sid + "&cid=" + cid;
    if (cat_id)
      url += "&category_id=" + cat_id;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.data = res.json();
        resolve(this.data);
      },
        err => {
          resolve({ errcode: 1, errmsg: '网络异常' });
        })
    });
  }

  saveSmsTemplate(tmpl: SmsTemplate) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/save_sms_template?sid=" + sid;
    return new Promise(resolve => {
      let body = new FormData();
      if (tmpl.id)
        body.append('id', String(tmpl.id));
      body.append('template_id', tmpl.template_id);
      body.append('template_name', tmpl.template_name);
      body.append('template_type', tmpl.template_type);
      body.append('config_id', String(tmpl.config_id));
      if (tmpl.category_id)
        body.append('category_id', String(tmpl.category_id));
      body.append('template_content', tmpl.template_content);
      if (tmpl.param_desc_ids && tmpl.param_desc_ids.length) {
        let ps = tmpl.param_desc_ids.map(p => <SmsTemplateParam>{
          params_desc: p.params_desc,
          params_name: p.params_name,
        })
        body.append('param_desc_ids', JSON.stringify(ps));
      }
      this.http.post(url, body).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  deleteSmsTemplate(id: number) {
    let url = AppGlobal.getInstance().api + "/api/delete_sms_template?id=" + id;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.data = res.json();
        resolve(this.data);
      });
    });
  }

  saveSmsConfig(cfg: SmsConfig) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/save_sms_config?sid=" + sid;
    return new Promise(resolve => {
      let body = new FormData();
      if (cfg.id)
        body.append('id', String(cfg.id));
      body.append('name', cfg.name);
      body.append('supplier', cfg.supplier);
      switch (cfg.supplier) {
        case 'dianxin':
          body.append('dx_app_id', cfg.dx_app_id);
          body.append('dx_app_secret', cfg.dx_app_secret);
          break;
        case 'aliyun':
          body.append('aliyun_access_key_id', cfg.aliyun_access_key_id);
          body.append('aliyun_access_key_secret', cfg.aliyun_access_key_secret);
          body.append('aliyun_is_company', String(cfg.aliyun_is_company ? 1 : 0));
          if (cfg.aliyun_sign_name_ids && cfg.aliyun_sign_name_ids.length) {
            let signs = cfg.aliyun_sign_name_ids.map(s => <any>{
              name: s.name,
              type: s.type
            });
            body.append('aliyun_sign_name_ids', JSON.stringify(signs));
          }
          break;
      }
      this.http.post(url, body).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  deleteSmsConfig(id: number) {
    let url = AppGlobal.getInstance().api + "/api/delete_sms_config?id=" + id;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.data = res.json();
        resolve(this.data);
      });
    });
  }

  getSmsSignNameList(config_id: number) {
    let url = AppGlobal.getInstance().api + "/api/get_sms_sign_name_list?config_id=" + config_id;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.data = res.json();
        resolve(this.data);
      });
    });
  }

  sendSms(sms: SmsEntity) {
    let app = AppGlobal.getInstance();
    let sid = app.sid;
    let cid = app.user.company_id;
    let uid = app.user.uid;

    let url = AppGlobal.getInstance().api + "/api/send_sms";
    return new Promise(resolve => {
      let body = new FormData();
      body.append('sid', String(sid));
      body.append('cid', String(cid));
      body.append('uid', String(uid));
      body.append("template_id", sms.template.template_id);
      if (sms.members && sms.members.length)
        body.append("member_ids", sms.members.join(','));
      if (sms.employees && sms.employees.length)
        body.append("employee_ids", sms.employees.join(','));
      if (sms.reminding_ids && sms.reminding_ids.length)
        body.append("reminding_ids", JSON.stringify(sms.reminding_ids));
      if (sms.sign_id)
        body.append("sign_name", String(sms.sign_id));
      let p = {};
      let params = sms.template.param_desc_ids;
      for (var i = 0; i < params.length; i++) {
        p[params[i].params_name] = sms.params[i];
      }
      body.append("params", JSON.stringify(p));
      this.http.post(url, body).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }
}

export interface SmsTemplateParam {
  params_desc?: string;
  params_name?: string;
  index?: number;
}

export interface SmsTemplate {
  id?: number;
  config_id?: number;
  template_content?: string;
  template_name?: string;
  category_display_name?: string;
  template_id?: string;
  template_type?: string;
  supplier_display_name?: string;
  supplier?: string;
  category_id?: number;
  param_desc_ids?: SmsTemplateParam[];
  template_type_display_name?: string;
}

export interface SmsSignName {
  id?: number;
  type?: string;
  name?: string;
  type_display_name?: string;
}

export interface SmsEntity {
  reminding_ids?: number[];
  sign_id?: number;
  members?: number[];
  employees?: number[];
  config_id?: number;
  supplier?: string;
  category_id?: number;
  template?: SmsTemplate;
  content?: string;
  params?: string[];
}

export interface Sms {
  sign_name?: string;
  member_ids?: string[];
  create_date?: string;
  employee_ids?: any[];
  template_content?: string;
  template_name?: string;
  sent_date?: string;
  id?: number;
  no?: string;
  template_type?: string;
  template_type_name?: string;
  state?: string;
  supplier?: string;
  supplier_name?: string;
  user_name?: string;
  template_id?: string;
}

export interface SmsConfig {
  dx_access_token?: string;
  dx_token_expires_at?: string;
  aliyun_is_company?: boolean;
  shop_id?: number;
  dx_app_secret?: string;
  dx_app_id?: string;
  id?: number;
  name?: string;
  company_id?: number;
  aliyun_access_key_secret?: string;
  aliyun_access_key_id?: string;
  supplier?: string;
  supplier_name?: string;
  aliyun_sign_name_ids?: SmsSignName[];
}

