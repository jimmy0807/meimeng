import { Injectable } from '@angular/core';
import { ApiHttp, ApiResult } from './api-http';
import { ZimgProvider } from './zimg';
import { AppGlobal } from '../app-global';
@Injectable()
export class VisitData {
  r: ApiResult;
  constructor(public http: ApiHttp, public zimg: ZimgProvider) {
  }

  async getVisits(offset = 0) {
    let p = {
      offset: offset,
      eid: AppGlobal.getInstance().user.eid,
    }
    let role = AppGlobal.getInstance().user.role;
    if (role == '1' || role == '2')
      p['all'] = 1;
    return this.http.GetAsync('get_visits', p);
  }

  async getVisitNotes(offset = 0, filter: VisitFilter = null) {
    let p = {
      offset: offset
    };
    if (filter) {
      let f = {};
      for (let key in filter) {
        if (filter[key])
          f[key] = filter[key];
      }
      if (Object.getOwnPropertyNames(f).length) {
        let b = new FormData();
        b.append('filter', JSON.stringify(f));
        return this.http.PostAsync('get_visit_notes', b, p);
      }
    }
    return this.http.GetAsync('get_visit_notes', p);
  }

  async getVisitCount() {
    let p = {
      eid: AppGlobal.getInstance().user.eid
    };
    return this.http.GetAsync('get_visit_count', p);
  }

  async getVisit(id: number) {
    return this.http.GetAsync('get_visit', { id: id });
  }

  async getMemberVisits(mid: number, offset = 0, limit = 10) {
    return this.http.GetAsync('get_member_visits', { mid: mid, offset: offset, limit: limit });
  }

  async saveVisit(i: Visit) {
    let body = new FormData();
    this.http.appendStrings(body, i, [
      'name',
      'member_id',
      'operate_id',
      'category',
      'area_city',
      'question',
      'team_id',

      'do_state_id',
      'authorizer_id',
      'solve_date',
    ])
    this.http.appendBooleans(body, i, ['is_refunds']);
    if (i.operate_question_ids && i.operate_question_ids.length) {
      body.append('operate_question_ids', JSON.stringify(i.operate_question_ids.map(q => q.id)))
    }
    if (!i.id) {
      if (i.note_ids && i.note_ids.length) {
        body.append('note_ids', JSON.stringify(i.note_ids.map(n => <VisitNote>{
          employee_id: n.employee_id,
          plant_visit_user_id: n.plant_visit_user_id || false,
          levle_id: n.levle_id,
          plant_visit_date: n.plant_visit_date
        })))
      }
      if (i.plan_ids && i.plan_ids.length) {
        body.append('plan_ids', JSON.stringify(i.plan_ids.map(p => <VisitPlan>{
          note: p.note,
          visit_date: p.visit_date
        })))
      }
    }
    return this.http.PostAsync('save_visit', body);
  }

  async saveVisitNote(n: VisitNote) {
    let body = new FormData();
    if (n.id)
      body.append('id', String(n.id));
    let d = <VisitNote>{
      employee_id: n.employee_id,
      plant_visit_user_id: n.plant_visit_user_id || false,
      levle_id: n.levle_id,
      plant_visit_date: n.plant_visit_date,
      note: n.note || false
    };
    if (!n.id)
      d.visit_id = n.visit_id;
    body.append('data', JSON.stringify(d));
    if (n.added_images && n.added_images.length) {
      for (let img of n.added_images) {
        let r = await this.zimg.uploadBase64(img.image);
        if (r.ret)
          img.image_url = r.url
        else
          return this.zimg.Error();
      }
      let imgs = n.added_images.map(img => <Image>{ image_url: img.image_url })
      body.append('added_images', JSON.stringify(imgs));
    }
    if (n.deleted_images && n.deleted_images.length) {
      let imgs = n.deleted_images.map(img => img.id)
      body.append('deleted_images', JSON.stringify(imgs));
    }
    return this.http.PostAsync('save_visit_note', body);
  }

  async deleteVisitNote(id) {
    return this.http.GetAsync('delete_visit_note', { id: id });
  }

  async saveVisitPlan(p: VisitPlan) {
    let body = new FormData();
    if (p.id)
      body.append('id', String(p.id));
    body.append('data', JSON.stringify(<VisitPlan>{
      visit_id: p.visit_id,
      note: p.note || '',
      visit_date: p.visit_date || false,
    }))
    return this.http.PostAsync('save_visit_plan', body);
  }

  async deleteVisitPlan(id) {
    return this.http.GetAsync('delete_visit_plan', { id: id });
  }

  async doneVisitNote(i: VisitNote) {
    let body = new FormData();
    this.http.appendStrings(body, i, ['id', 'note']);
    body.append('state', 'done');
    if (i.added_images && i.added_images.length) {
      for (let img of i.added_images) {
        let r = await this.zimg.uploadBase64(img.image);
        if (r.ret)
          img.image_url = r.url
        else
          return this.zimg.Error();
      }
      let imgs = i.added_images.map(img => <Image>{ image_url: img.image_url })
      body.append('added_images', JSON.stringify(imgs));
    }
    if (i.deleted_images && i.deleted_images.length) {
      let imgs = i.deleted_images.map(img => img.id)
      body.append('deleted_images', JSON.stringify(imgs));
    }
    return this.http.PostAsync('do_visit_note', body);
  }

  async finishVisitNote(i: VisitNote) {
    let body = new FormData();
    body.append('id', String(i.id));
    if (i.review)
      body.append('review', i.review);
    body.append('state', 'finish');
    return this.http.PostAsync('do_visit_note', body);
  }

  async draftVisitNote(i: VisitNote) {
    let body = new FormData();
    body.append('id', String(i.id));
    body.append('state', 'draft');
    return this.http.PostAsync('do_visit_note', body);
  }

  async finishVisit(i: Visit) {
    let body = new FormData();
    this.http.appendStrings(body, i, ['id', 'review', 'comments'])
    return this.http.PostAsync('finish_visit', body);
  }

  async getVisitLevels() {
    return this.http.GetAsync('get_visit_levels');
  }

  async getMedicalAdvisory(mid: number) {
    return this.http.GetAsync('get_medical_advisory', { mid: mid });
  }

  async getMedicalOperate(mid: number) {
    return this.http.GetAsync('get_medical_operate', { mid: mid });
  }

  async getMedicalCustomers() {
    return this.http.GetAsync('get_medical_customers');
  }

  async getMedicalUsers() {
    return this.http.GetAsync('get_medical_users', { sid: this.http.sid });
  }

  async getVisitQuestions() {
    return this.http.GetAsync('get_visit_dictionary', { type: 1 });
  }

  async getDoStates() {
    return this.http.GetAsync('get_visit_dictionary', { type: 2 });
  }

  async getCommissionTeams() {
    return this.http.GetAsync('get_commission_teams', { sid: this.http.sid });
  }
}

export interface Visit {
  id?: number;
  name?: string;
  member_id?: number;
  member_name?: string;
  operate_id?: number;
  operate_name?: string;
  member_type?: string;
  member_type_name?: string;
  mobile?: string;
  shop_name?: string;
  operate_create_date?: string;
  doctor_id?: number;
  doctor_name?: string;
  designers_id?: number;
  designers_name?: string;
  director_employee_id?: number;
  director_employee_name?: string;
  employee_id?: number;
  employee_name?: string;

  category?: string;
  category_name?: string;
  consume_amount?: number;
  area_city?: string;
  product_names?: string;
  visit_user_name?: string;
  visit_date?: string;
  plant_visit_date?: string;

  do_state_id?: number,
  do_state_name?: string,
  authorizer_id?: number,
  authorizer_name?: string,
  solve_date?: string,
  is_refunds?: boolean,
  refund_amount?: number,

  state?: string;
  state_name?: string;

  note?: string;
  question?: string;
  review?: string;
  comments?: string;

  note_ids?: VisitNote[];
  plan_ids?: VisitPlan[];
  operate_question_ids?: { id?: number; name?: string }[];
  question_names?: string;

  dj_partner_name?: string;
  dd_partner_name?: string;
  dl_partner_name?: string;
  dl_partner_name_1?: string;
  dl_partner_name_2?: string;
  dl_partner_name_3?: string;
  team_id?: number;
  team_name?: string;

  isMine?: boolean;
  hidden?: boolean;
  employees_names?: string;
}

export interface VisitNote {
  id?: number;
  visit_id?: number;
  levle_id?: number;
  levle_name?: string;
  employee_id?: number;
  employee_name?: string;
  plant_visit_date?: string;
  plant_visit_user_id?: string;
  plant_visit_user_name?: string;
  note?: string;
  review?: string;
  state?: string;
  state_name?: string;
  visit_image_ids?: Image[];
  added_images?: Image[];
  deleted_images?: Image[];

  isMine?: boolean;
}

export interface VisitPlan {
  id?: number;
  visit_id?: number;
  visit_date?: string;
  note?: string;
}

export interface Image {
  id?: number;
  image?: string;
  image_url?: string;
}

export interface VisitFilter {
  m?: string | boolean;
  l?: string | boolean;
  t?: string | boolean;
  e?: string | boolean;
  p?: string | boolean;
  s?: string | boolean;
  ds?: string | boolean;
  de?: string | boolean;
}

