import { Injectable } from '@angular/core';

import { Http } from '@angular/http';
import { AppGlobal } from '../app-global';
import { ApiHttp, ApiResult } from './api-http';

@Injectable()
export class EmployeeData {
  data: ApiResult;

  constructor(public http: Http,
    public api: ApiHttp) { }

  load() {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/reservation_employee?sid=" + sid;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.data = res.json();
        resolve(this.data);
      });
    });
  }

  loadFollowEmployee(params) {
    let sid = AppGlobal.getInstance().sid;
    let url = AppGlobal.getInstance().api + "/api/follow_employee?sid=" + sid + "&month=" + params.month + "&year=" + params.year;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  async getEmployees(offset, keyword, cat = null, isbook = false) {
    let p = {
      sid: this.api.sid,
      offset: offset
    }
    if (keyword)
      p['keyword'] = keyword;
    if (cat)
      p['cat'] = cat;
    if (isbook)
      p['isbook'] = true;
    return this.api.GetAsync('get_employees', p);
  }

  async getAllEmployees(cat: string[] = null) {
    let p = {
      sid: this.api.sid,
    }
    if (cat)
      p['cat'] = JSON.stringify(cat);
    return this.api.GetAsync('get_all_employees', p);
  }

  async getEmployee() {
    return this.api.GetAsync('get_employee');
  }

  saveEmployeeProp(id: number, key: string, value) {
    let url = AppGlobal.getInstance().api + "/api/save_employee_prop";
    return new Promise(resolve => {
      let body = new FormData();
      body.append("id", String(id));
      body.append('key', key);
      body.append('value', value);
      this.http.post(url, body).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  saveUserInfo(user: UserInfo) {
    let url = AppGlobal.getInstance().api + "/api/save_user_info";
    return new Promise(resolve => {
      let body = new FormData();
      body.append("id", String(user.id));
      body.append('is_accept_notice', String(user.is_accept_notice ? 1 : 0));
      body.append('is_accept_push', String(user.is_accept_push ? 1 : 0));
      this.http.post(url, body).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  saveEmployee(e: Employee) {
    let url = AppGlobal.getInstance().api + "/api/save_employee";
    return new Promise(resolve => {
      let body = new FormData();
      if (e.id > 0)
        body.append("id", String(e.id));
      body.append('name', e.name);
      body.append('mobile_phone', e.mobile_phone);
      if (e.birthday)
        body.append('birthday', e.birthday);
      if (e.gender)
        body.append('gender', e.gender);
      body.append('work_email', e.work_email || '');
      if (e.shop_id)
        body.append('shop_id', String(e.shop_id));
      body.append('is_login', String(e.is_login ? 1 : 0));
      if (e.role_option)
        body.append('role_option', e.role_option);
      if (e.password)
        body.append('password', e.password);
      if (e.pos_config_id)
        body.append('pos_config_id', String(e.pos_config_id));
      if (e.department_id)
        body.append('department_id', String(e.department_id));
      if (e.job_id)
        body.append('job_id', String(e.job_id));
      body.append('isbook', String(e.isbook ? 1 : 0));
      this.http.post(url, body).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }

  deleteEmployee(id: number) {
    let url = AppGlobal.getInstance().api + "/api/delete_employee?id=" + id;
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.data = res.json();
        resolve(this.data);
      });
    });
  }

  getPosConfigs() {
    let url = AppGlobal.getInstance().api + "/api/get_pos_configs";
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.data = res.json();
        resolve(this.data);
      });
    });
  }

  getDepartments() {
    let url = AppGlobal.getInstance().api + "/api/get_departments";
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.data = res.json();
        resolve(this.data);
      });
    });
  }

  getJobs() {
    let url = AppGlobal.getInstance().api + "/api/get_jobs";
    return new Promise(resolve => {
      this.http.get(url).subscribe(res => {
        this.data = res.json();
        resolve(this.data);
      });
    });
  }
}

export interface Employee {
  rid?: number;
  id?: number;
  name?: string;
  shop_id?: number;
  shop_name?: string;
  password?: string;
  mobile_phone?: string;
  pos_config_id?: number;
  pos_config_name?: string;
  gender?: string;
  job_id?: number;
  job_name?: string;
  birthday?: string;
  isbook?: boolean;
  role_option?: string;
  work_email?: string;
  is_login?: boolean;
  department_id?: number;
  department_name?: string;
  checked?: boolean;
  image_url?: string;
  book_time?: number;
}

export interface UserInfo {
  id?: number;
  login?: string;
  is_accept_notice?: boolean;
  sel_groups_23_24?: string;
  sel_groups_1_2_3?: string;
  sel_groups_9_34_10?: string;
  is_accept_push?: boolean;
  in_group_55?: boolean;
  in_group_6?: boolean;
  is_allow_login?: boolean;
  role_option?: string;
  sel_groups_110?: string;
  sel_groups_47_48?: string;
  sel_groups_52_53_54?: string;
  in_group_84?: boolean;
  sel_groups_4_104_44_45?: string;
  sel_groups_95_101_96?: string;
  sel_groups_94?: string;
}

export interface EmployeeInfo {
  mobile_phone?: string;
  role_option?: string;
  birthday?: string;
  password?: string;
  work_email?: string;
  id?: number;
  amount_total?: number;
  name?: string;
  member_count?: number;
  gender?: string;
  shop_name?: string;
  user_info?: UserInfo;
  image_url?: string;
  company_name?: string;
}
