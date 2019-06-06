import { Injectable } from '@angular/core';

import { Http } from '@angular/http';
import { ApiHttp, ApiResult } from './api-http';

@Injectable()
export class ReservationData {
  listData: ApiResult;

  constructor(public http: Http,
    public api: ApiHttp) { }

  async getReservations(offset) {
    return this.api.GetAsync('get_reservation_list', { sid: this.api.sid, offset: offset })
  }

  async updateReservationState(data) {
    let body = new FormData();
    body.append('sid', String(this.api.sid));
    body.append('id', String(data.id));
    body.append('state', data.state);
    return this.api.PostAsync('update_reservation_state', body);
  }

  async getEmployeeTimes(id: number) {
    return this.api.GetAsync('reservation_employee_time', { id: id })
  }

  async getMemberInfo(mobile: string = null, name: string = null) {
    let p = {
      sid: this.api.sid
    }
    if (mobile)
      p['mobile'] = mobile;
    if (name)
      p['name'] = name;
    return this.api.GetAsync('reservation_search_member', p)
  }

  async saveReservation(data: Reservation) {
    let body = new FormData();
    body.append('sid', String(this.api.sid));
    body.append('description', data.description || '');
    body.append('is_partner', data.is_partner ? '1' : '0');
    this.api.appendStrings(body, data, [
      'technician_id',
      'start_date',
      'end_date',
      'product_ids',
      'member_type',
      'designers_id',
      'designers_service_id',
      'director_employee_id',
      'doctor_id',
    ]);
    if (data.id) {
      body.append('id', String(data.id));
      return this.api.PostAsync('reservation_update', body);
    }
    else {
      body.append('telephone', data.telephone);
      body.append('member_id', String(data.member_id ? data.member_id : 0));
      body.append('member_name', data.member_name);
      return this.api.PostAsync('reservation_save', body);
    }
  }

  async updateReservation(data) {
  }

  async getSchedule(schedule_date) {
    return this.api.GetAsync('get_schedule', { sid: this.api.sid, schedule_date: schedule_date })
  }

  async getScheduleEmployee(params) {
    return this.api.GetAsync('get_schedule_employee', { sid: this.api.sid, id: params.id });
  }

  async updateScheduleEmployee(data) {
    let body = new FormData();
    body.append('line_id', data.line_id);
    body.append('sid', String(this.api.sid));
    body.append('employees', data.employees);
    return this.api.PostAsync('update_schedule_employee', body);
  }

  async deleteScheduleEmployee(data) {
    let body = new FormData();
    body.append('line_id', data.line_id);
    body.append('sid', String(this.api.sid));
    body.append('id', data.id);
    return this.api.PostAsync('delete_schedule_employee', body);
  }
}

export interface Reservation {
  reservation_date?: string;
  start_date?: string;
  end_date?: string;
  state?: string;
  id?: number;
  name?: string;
  telephone?: string;
  is_partner?: boolean;
  member_type?: string;
  product_names?: string;
  product_ids?: any;
  products?: any[];
  designers_id?: number;
  designers_name?: string;
  designers_service_id?: number;
  designers_service_name?: string;
  director_employee_id?: number;
  director_employee_name?: string;
  doctor_id?: number;
  doctor_name?: string;

  technician_id?: number;
  technician_name?: string;
  member_name?: string;
  member_id?: number;

  service_datetime?: string;
  ampm?: string;
  create_date?: string;
  description?: string;
  state_display?: string;
  refuse_desc?: string;
  approve_id?: number;
  approve_name?: string;
  approve_date?: string;
}

export interface ReservationTime {
  time?: string;
  events?: Time[];
}

export interface Time {
  id?: number;
  start?: string;
  end?: string;
  info?: string;
}
