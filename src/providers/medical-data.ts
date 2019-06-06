import { Injectable } from '@angular/core';
import { ApiHttp, ApiResult } from './api-http';

@Injectable()
export class MedicalData {
  r: ApiResult;
  constructor(public http: ApiHttp) {
  }

  async getMedicalAdvisories(offset = 0) {
    let p = {
      sid: this.http.sid,
      offset: offset
    };
    return this.http.GetAsync('get_medical_advisories', p)
  }

  async saveMedicalAdvisory(i: Advisory) {
    let body = new FormData();
    if (i.id)
      body.append('id', String(i.id));
    if (i.customer_id)
      body.append('customer_id', String(i.customer_id));
    body.append('category', i.category);
    if (i.receiver_id)
      body.append('receiver_id', String(i.receiver_id));
    if (i.split_id)
      body.append('split_id', String(i.split_id));
    if (i.member_id)
      body.append('member_id', String(i.member_id));
    if (i.employee_id)
      body.append('employee_id', String(i.employee_id));
    if (i.designers_id)
      body.append('designers_id', String(i.designers_id));
    if (i.doctor_id)
      body.append('doctor_id', String(i.doctor_id));
    if (i.operate_id)
      body.append('operate_id', String(i.operate_id));
    if (i.reservation_id)
      body.append('reservation_id', String(i.reservation_id));
    body.append('condition', i.condition || '');
    body.append('advice', i.advice || '');
    if (i.product_ids && i.product_ids.length) {
      let ids = i.product_ids.map(p => p.id);
      body.append('product_ids', JSON.stringify(ids));
    }
    return this.http.PostAsync('save_medical_advisory', body);
  }

  async deleteMedicalAdvisory(id: number) {
    return this.http.GetAsync('delete_medical_advisory', { id: id });
  }

  async getMedicalCustomers(offset = 0, keyword = null) {
    let p = {
      sid: this.http.sid,
      offset: offset
    };
    if (keyword)
      p['keyword'] = keyword;
    return this.http.GetAsync('get_medical_customer_list', p)
  }

  async saveMedicalCustomer(i: Customer, changeMobile: boolean) {
    let body = new FormData();
    body.append('sid', String(this.http.sid));
    if (i.id)
      body.append('id', String(i.id));
    body.append('name', i.name);
    if (changeMobile)
      body.append('mobile', i.mobile);
    body.append('phone', i.phone || '');
    body.append('email', i.email || '');
    if (i.parent_id)
      body.append('parent_id', String(i.parent_id));
    if (i.partner_id)
      body.append('partner_id', String(i.partner_id));
    if (i.recommend_member_id)
      body.append('recommend_member_id', String(i.recommend_member_id));
    if (i.channel_id)
      body.append('channel_id', String(i.channel_id));
    if (i.employee_id)
      body.append('employee_id', String(i.employee_id));
    if (i.member_id)
      body.append('member_id', String(i.member_id));
    if (i.photo)
      body.append('photo', i.photo);
    body.append('note', i.note || '');
    return this.http.PostAsync('save_medical_customer', body);
  }

  async deleteMedicalCustomer(id: number) {
    return this.http.GetAsync('delete_medical_customer', { id: id });
  }

  async getMedicalSplits(offset = 0) {
    let p = {
      sid: this.http.sid,
      offset: offset
    };
    return this.http.GetAsync('get_medical_splits', p)
  }

  async saveMedicalSplit(i: Split) {
    let body = new FormData();
    if (i.id)
      body.append('id', String(i.id));
    if (i.customer_id)
      body.append('customer_id', String(i.customer_id));
    if (i.category_id)
      body.append('category_id', String(i.category_id));
    if (i.type_id)
      body.append('type_id', String(i.type_id));
    body.append('customer_category', i.customer_category);
    if (i.reservation_id)
      body.append('reservation_id', String(i.reservation_id));
    if (i.tag_ids && i.tag_ids.length) {
      let ids = i.tag_ids.map(t => t.id);
      body.append('tag_ids', JSON.stringify(ids));
    }
    if (i.receiver_id)
      body.append('receiver_id', String(i.receiver_id));
    body.append('content', i.content || '');
    body.append('result', i.result || '');
    return this.http.PostAsync('save_medical_split', body);
  }

  async deleteMedicalSplit(id: number) {
    return this.http.GetAsync('delete_medical_split', { id: id });
  }

  async getAdvisoryCategories() {
    return this.http.GetAsync('get_advisory_categories');
  }

  async saveAdvisoryCategory(i) {
    let body = new FormData();
    if (i.id)
      body.append('id', i.id);
    body.append('name', i.name);
    return this.http.PostAsync('save_advisory_category', body);
  }

  async deleteAdvisoryCategory(id: number) {
    return this.http.GetAsync('delete_advisory_category', { id: id });
  }

  async getMedicalTypes() {
    return this.http.GetAsync('get_medical_types');
  }

  async saveMedicalType(i) {
    let body = new FormData();
    if (i.id)
      body.append('id', i.id);
    body.append('name', i.name);
    return this.http.PostAsync('save_medical_type', body);
  }

  async deleteMedicalType(id: number) {
    return this.http.GetAsync('delete_medical_type', { id: id });
  }

  async getMedicalReservations(offset = 0) {
    return this.http.GetAsync('get_medical_reservations', { offset: offset });
  }

  async getMedicalTags() {
    return this.http.GetAsync('get_medical_tags');
  }

  async saveMedicalTag(i) {
    let body = new FormData();
    if (i.id)
      body.append('id', i.id);
    body.append('name', i.name);
    return this.http.PostAsync('save_medical_tag', body);
  }

  async deleteMedicalTag(id: number) {
    return this.http.GetAsync('delete_medical_tag', { id: id });
  }

  async getMedicalReceivers(offset = 0, keyword = null) {
    let p = {
      sid: this.http.sid,
      offset: offset
    };
    if (keyword)
      p['keyword'] = keyword;
    return this.http.GetAsync('get_medical_receivers', p);
  }

  async getMedicalPosOperates(offset = 0) {
    return this.http.GetAsync('get_medical_pos_operates', { offset: offset });
  }

  async getMedicalWards(offset = 0) {
    return this.http.GetAsync('get_medical_wards', { offset: offset, sid: this.http.sid });
  }

  async saveMedicalWard(i: Ward) {
    let body = new FormData();
    if (i.id)
      body.append('id', String(i.id));
    else if (i.bed_ids && i.bed_ids.length) {
      let beds = i.bed_ids.map(b => <Bed>{
        name: b.name,
        note: b.note,
        state: b.state,
      });
      body.append('bed_ids', JSON.stringify(beds));
    }
    body.append('name', i.name);
    if (i.departments_id)
      body.append('departments_id', String(i.departments_id));
    if (i.doctors_id)
      body.append('doctors_id', String(i.doctors_id));
    if (i.nurse_id)
      body.append('nurse_id', String(i.nurse_id));
    body.append('category', i.category);
    if (i.note)
      body.append('note', i.note);
    return this.http.PostAsync('save_medical_ward', body);
  }

  async deleteMedicalWard(id: number) {
    return this.http.GetAsync('delete_medical_ward', { id: id });
  }

  async getMedicalBeds(offset = 0) {
    return this.http.GetAsync('get_medical_beds', { offset: offset });
  }

  async saveMedicalBed(i: Bed) {
    let body = new FormData();
    if (i.id)
      body.append('id', String(i.id));
    body.append('name', i.name);
    body.append('ward_id', String(i.ward_id));
    body.append('state', i.state);
    if (i.note)
      body.append('', i.note);
    return this.http.PostAsync('save_medical_bed', body);
  }

  async deleteMedicalBed(id: number) {
    return this.http.GetAsync('delete_medical_bed', { id: id });
  }

  async getCommissionLevels() {
    return this.http.GetAsync('get_commission_levels', { sid: this.http.sid });
  }

  async saveCommissionLevel(i: MedicalCommissionLevel) {
    let body = new FormData();
    body.append('sid', String(this.http.sid));
    if (i.id)
      body.append('id', String(i.id));
    body.append('name', i.name);
    body.append('dj_percent', String(i.dj_percent || 0));
    body.append('dd_percent', String(i.dd_percent || 0));
    body.append('dl1_percent', String(i.dl1_percent || 0));
    body.append('dl2_percent', String(i.dl2_percent || 0));
    body.append('lead_percent', String(i.lead_percent || 0));
    body.append('category', i.category);
    if (i.region_id)
      body.append('region_id', String(i.region_id));
    if (i.sign_end_date)
      body.append('sign_end_date', i.sign_end_date);
    return this.http.PostAsync('save_commission_level', body);
  }

  async deleteCommissionLevel(id: number) {
    return this.http.GetAsync('delete_commission_level', { id: id });
  }

  async getBornDepartments() {
    return this.http.GetAsync('get_born_departments', { sid: this.http.sid });
  }

  async saveBornDepartment(i: Department) {
    let body = new FormData();
    body.append('sid', String(this.http.sid));
    if (i.id)
      body.append('id', String(i.id));
    body.append('name', i.name);
    body.append('code', i.code || '');
    if (i.hr_doctor_id)
      body.append('hr_doctor_id', String(i.hr_doctor_id));
    body.append('is_display_adviser', String(i.is_display_adviser ? 1 : 0));
    if (i.parent_id)
      body.append('parent_id', String(i.parent_id));
    if (i.product_ids && i.product_ids.length) {
      let prds = i.product_ids.map(p => p.id);
      body.append('product_ids', JSON.stringify(prds));
    }
    if (i.hr_operate_ids && i.hr_operate_ids.length) {
      let ops = i.hr_operate_ids.map(p => p.id);
      body.append('hr_operate_ids', JSON.stringify(ops));
    }
    if (i.hr_doctor_ids && i.hr_doctor_ids.length) {
      let docs = i.hr_doctor_ids.map(p => p.id);
      body.append('hr_doctor_ids', JSON.stringify(docs));
    }
    return this.http.PostAsync('save_born_departments', body);
  }

  async deleteBornDepartment(id: number) {
    return this.http.GetAsync('delete_born_departments', { id: id });
  }

  async getBornWorkflows() {
    return this.http.GetAsync('get_born_workflows', { sid: this.http.sid });
  }

  async saveBornWorkflow(i: Workflow) {
    let body = new FormData();
    body.append("sid", String(this.http.sid));
    if (i.id)
      body.append("id", String(i.id));
    body.append("name", i.name);
    if (!i.id && i.activity_ids && i.activity_ids.length) {
      let ids = i.activity_ids.map(a => <WorkflowActivity>{
        flow_end: a.flow_end || false,
        flow_start: a.flow_start || false,
        name: a.name,
        parent_activity_id: a.parent_activity_id || false,
        role_option: a.role_option,
      })
      body.append('activity_ids', JSON.stringify(ids));
    }
    return this.http.PostAsync('save_born_workflow', body);
  }

  async deleteBornWorkflow(id: number) {
    return this.http.GetAsync('delete_born_workflow', { id: id });
  }

  async getWorkflowActivities(offset = 0) {
    return this.http.GetAsync('get_workflow_activities', { sid: this.http.sid, offset: offset });
  }

  async saveWorkflowActivity(i: WorkflowActivity) {
    let body = new FormData();
    if (i.id)
      body.append('id', String(i.id));
    body.append('workflow_id', String(i.workflow_id));
    body.append('name', i.name);
    if (i.parent_activity_id)
      body.append('parent_activity_id', String(i.parent_activity_id));
    body.append('role_option', i.role_option);
    body.append('flow_end', String(i.flow_end ? 1 : 0));
    body.append('flow_start', String(i.flow_start ? 1 : 0));
    return this.http.PostAsync('save_workflow_activity', body);
  }

  async deleteWorkflowActivity(id: number) {
    return this.http.GetAsync('delete_workflow_activity', { id: id });
  }

  async getVisitLevels(offset = 0) {
    return this.http.GetAsync('get_visit_levles', { offset: offset });
  }

  async saveVisitLevel(i: VisitLevel) {
    let body = new FormData();
    if (i.id)
      body.append('id', String(i.id));
    body.append('name', i.name);
    body.append('category', i.category);
    body.append('days', String(i.days));
    let ids = [];
    if (i.category_ids && i.category_ids.length)
      ids = i.category_ids.map(c => c.id);
    body.append('category_ids', JSON.stringify(ids));
    return this.http.PostAsync('save_visit_levle', body);
  }

  async deleteVisitLevel(id: number) {
    return this.http.GetAsync('delete_visit_levle', { id: id });
  }

  async getMedicalOperates(offset = 0) {
    return this.http.GetAsync('get_medical_operates', { offset: offset });
  }

  async saveMedicalOperate(i: Operate) {
    let body = new FormData();
    if (i.id)
      body.append('id', String(i.id));
    body.append('name', i.name);
    if (i.doctor_id)
      body.append('doctor_id', String(i.doctor_id));
    if (i.member_id)
      body.append('member_id', String(i.member_id));
    if (i.records_id)
      body.append('records_id', String(i.records_id));
    if (i.first_treat_date)
      body.append('first_treat_date', i.first_treat_date);
    if (i.expander_in_date)
      body.append('expander_in_date', i.expander_in_date);
    if (i.expander_review_days_1)
      body.append('expander_review_days_1', String(i.expander_review_days_1));
    if (i.expander_review_1)
      body.append('expander_review_1', i.expander_review_1);
    if (i.expander_review_days_2)
      body.append('expander_review_days_2', String(i.expander_review_days_2));
    if (i.expander_review_2)
      body.append('expander_review_2', i.expander_review_2);
    if (i.expander_review_days_3)
      body.append('expander_review_days_3', String(i.expander_review_days_3));
    if (i.expander_review_3)
      body.append('expander_review_3', i.expander_review_3);
    if (i.note)
      body.append('note', i.note);
    if (!i.id && i.line_ids && i.line_ids.length) {
      let ids = i.line_ids.map(l => <OperateLine>{
        doctor_id: l.doctor_id,
        name: i.name,
        note: i.note || '',
        operate_date: l.operate_date || false,
        review_date: l.review_date || false,
        review_days: l.review_days || 0,
      });
      body.append('line_ids', JSON.stringify(ids));
    }
    return this.http.PostAsync('save_medical_operate', body);
  }

  async deleteMedicalOperate(id: number) {
    return this.http.GetAsync('delete_medical_operate', { id: id });
  }

  async saveMedicalOperateLine(i: OperateLine) {
    let body = new FormData();
    if (i.id)
      body.append('id', String(i.id));
    body.append('name', i.name);
    if (i.medical_operate_id)
      body.append('medical_operate_id', String(i.medical_operate_id));
    if (i.doctor_id)
      body.append('doctor_id', String(i.doctor_id));
    if (i.operate_date)
      body.append('operate_date', i.operate_date);
    if (i.review_days)
      body.append('review_days', String(i.review_days));
    if (i.review_date)
      body.append('review_date', i.review_date);
    if (i.note)
      body.append('note', i.note);
    return this.http.PostAsync('save_medical_operate_line', body);
  }

  async deleteMedicalOperateLine(id: number) {
    return this.http.GetAsync('delete_medical_operate_line', { id: id });
  }

  async getBornPrescription(offset = 0, id: number) {
    return this.http.GetAsync('get_prescription_info', { offset: offset, id: id });
  }

  async getMedicalPharmacy(offset = 0) {
    return this.http.GetAsync('get_pharmacy_info', { offset: offset });
  }
  async saveMedicalPharmacy(i: Pharmacy) {
    let body = new FormData();
    if (i.id)
      body.append('id', String(i.id));

    body.append('name', i.name);
    if (i.employee_id)
      body.append('employee_id', String(i.employee_id));
    return this.http.PostAsync('save_medical_pharmacy', body);
  }

  async deleteMedicalPharmacy(id: number) {
    return this.http.GetAsync('delete_medical_pharmacy', { id: id });
  }

  async getMedicalUoms() {
    return this.http.GetAsync('get_medical_uoms');
  }

  async getMedicalHospitalized(offset = 0) {
    return this.http.GetAsync('get_medical_hospitalized', { offset: offset });
  }

  async saveMedicalHospitalized(i: Hospitalized) {
    let body = new FormData();
    this.http.appendStrings(body, i,
      [
        'id',
        'name',
        'member_id',
        'designers_id',
        'employee_id',
        'doctors_id',
        'check_in_date',
        'check_out_date',
        'state',
        'category',
        'medical_plant',
        'reason',
        'doctors_note',
        'operate_id',
        'bed_id',
        'ward_id',
        'records_id',
        'note',
      ]);
    this.http.appendBooleans(body, i, ['is_payment']);
    if (!i.id && i.line_ids && i.line_ids.length) {
      let ids = i.line_ids.map(l => <HospitalizedLine>{
        product_id: l.product_id,
        qty: l.qty || 0,
        price: l.price || 0,
        uom_id: l.uom_id || false,
        note: l.note || false,
        doctors_id: l.doctors_id || false,
      });
      body.append('', JSON.stringify(ids));
    }
    return this.http.PostAsync('save_medical_hospitalized', body);
  }

  async deleteMedicalHospitalized(id: number) {
    return this.http.GetAsync('delete_medical_hospitalized', { id: id });
  }

  async saveMedicalHospitalizedLine(i: HospitalizedLine) {
    let b = new FormData();
    this.http.appendStrings(b, i,
      [
        'hospitalized_id',
        'product_id',
        'qty',
        'price',
        'uom_id',
        'note',
        'doctors_id',
      ]);
    return this.http.PostAsync('save_medical_hospitalized_line', b);
  }

  async getMedicalRecords(offset = 0) {
    return this.http.GetAsync('get_records_info', { offset: offset });
  }
  async saveMedicalRecords(i: Records) {
    let body = new FormData();
    if (i.id)
      body.append('id', String(i.id));
    body.append('name', i.name);
    return this.http.PostAsync('save_medical_records', body);
  }

  async deleteMedicalRecords(id: number) {
    return this.http.GetAsync('delete_medical_records', { id: id });
  }

  async deleteMedicalHospitalizedLine(id: number) {
    return this.http.GetAsync('delete_medical_hospitalized_line', { id: id });
  }

  async getRecordsLine(offset = 0, id: number) {
    return this.http.GetAsync('get_records_line', { offset: offset, id: id });
  }
  async saveMedicalRecordsLine(i: RecordsLine) {
    let body = new FormData();
    if (i.id)
      body.append('id', String(i.id));
    if (i.doctors_id)
      body.append('doctors_id', String(i.doctors_id));
    body.append('reason', i.reason);
    body.append('doctors_note', i.doctors_note);
    return this.http.PostAsync('save_medical_records_line', body);
  }
}

export interface Item {
  id?: number;
  name?: string;
}

export interface Advisory {
  category?: string;
  category_name?: string;
  split_id?: number;
  receiver_id?: number;
  employee_id?: number;
  designers_name?: string;
  doctor_name?: string;
  advice?: string;
  member_name?: string;
  condition?: string;
  split_time?: string;
  product_ids?: any[];
  designers_id?: number;
  operate_id?: number;
  operate_name?: string;
  member_id?: number;
  doctor_id?: number;
  receiver_name?: string;
  customer_id?: number;
  reservation_id?: number;
  id?: number;
  employee_name?: string;
  customer_name?: string;
  reservation_name?: string;
  split_name?: string;
}

export interface Split {
  receiver_id?: number;
  type_id?: number;
  receiver_name?: string;
  reservation_name?: string;
  result?: string;
  reservation_id?: number;
  id?: number;
  category_name?: string;
  content?: string;
  customer_id?: number;
  type_name?: string;
  tag_ids?: any[];
  customer_name?: string;
  customer_category?: string;
  category_id?: number;
}

export interface Customer {
  member_name?: string;
  parent_name?: string;
  recommend_member_name?: string;
  employee_id?: number;
  name?: string;
  parent_id?: number;
  mobile?: string;
  member_id?: number;
  channel_id?: number;
  email?: string;
  note?: string;
  phone?: string;
  photo?: string;
  image_url?: string;
  shop_id?: number;
  employee_name?: string;
  partner_name?: string;
  recommend_member_id?: number;
  shop_name?: string;
  partner_id?: number;
  id?: number;
  channel_name?: string;
}

export interface Ward {
  id?: number;
  name?: string;
  company_id?: number;
  company_name?: string;
  departments_id?: number;
  departments_name?: string;
  doctors_id?: number;
  doctors_name?: string;
  nurse_id?: number;
  nurse_name?: string;
  category?: string;
  category_name?: string;
  bed_ids?: Bed[];
  note?: string;
}

export interface Bed {
  id?: number;
  name?: string;
  ward_id?: number;
  ward_name?: string;
  state?: string;
  state_name?: string;
  note?: string;
}

export interface MedicalCommissionLevel {
  region_name?: string;
  dd_percent?: number;
  id?: number;
  dj_percent?: number;
  region_id?: number;
  category?: string;
  lead_percent?: number;
  name?: string;
  sign_end_date?: string;
  dl2_percent?: number;
  dl1_percent?: number;
  category_name?: string;
}

export interface Department {
  id?: number;
  name?: string;
  code?: string;
  hr_doctor_id?: number;
  hr_doctor_name?: string;
  is_display_adviser?: boolean;
  parent_id?: number;
  parent_name?: string;
  product_ids?: any[];
  hr_operate_ids?: any[];
  hr_doctor_ids?: any[];
}

export interface WorkflowActivity {
  workflow_id?: number;
  name?: string;
  role_option_name?: string;
  flow_end?: boolean;
  workflow_name?: string;
  flow_start?: boolean;
  parent_activity_name?: string;
  id?: number;
  parent_activity_id?: number;
  role_option?: string;
}

export interface Workflow {
  activity_ids?: WorkflowActivity[];
  id?: number;
  name?: string;
}

export interface VisitLevel {
  id?: number;
  name?: string;
  category?: string;
  days?: number;
  category_ids?: Item[];
}

export interface OperateLine {
  id?: number;
  name?: string;
  medical_operate_id?: number;
  doctor_id?: number;
  doctor_name?: string;
  operate_date?: string;
  review_days?: number;
  review_date?: string;
  note?: string;
}

export interface Operate {
  id?: number;
  name?: string;
  doctor_id?: number;
  doctor_name?: string;
  member_id?: number;
  member_name?: string;
  records_id?: number;
  records_name?: string;
  first_treat_date?: string;
  expander_in_date?: string;
  expander_review_days_1?: number;
  expander_review_1?: string;
  expander_review_days_2?: number;
  expander_review_2?: string;
  expander_review_days_3?: number;
  expander_review_3?: string;
  note?: string;
  line_ids?: OperateLine[];
}
export interface Prescription {
  id?: number;
  name?: string;
  company_id?: number;
  company_name?: string;
  operate_id?: number;
  operate_name?: string;
  doctor_id?: number;
  doctor_name?: string;
  member_id?: number;
  memebr_name?: string;
  pharmacy_id?: number;
  pharmacy_name?: string;
  state?: string;
  state_name?: string;
  line_ids?: any[];
}

export interface Pharmacy {
  id?: number;
  name?: string;
  employee_id?: number;
  employee_name?: string;
  prescription_ids?: Prescription[];
}

export interface RecordsLine {
  id?: number;
  doctors_id?: number;
  doctors_name?: string;
  reason?: string;
  doctors_note?: string;
  create_date?: string;
  prescription_ids?: Prescription[];
}

export interface HospitalizedLine {
  id?: number;
  hospitalized_id?: number;
  product_id?: number;
  product_name?: string;
  qty?: number;
  price?: number;
  uom_id?: number;
  uom_name?: string;
  doctors_id?: number;
  doctors_name?: string;
  note?: string;
}

export interface Hospitalized {
  id?: number;
  name?: string;
  member_id?: number;
  member_name?: string;
  designers_id?: number;
  designers_name?: string;
  employee_id?: number;
  employee_name?: string;
  doctors_id?: number;
  doctors_name?: string;
  check_in_date?: string;
  check_out_date?: string;
  state?: string;
  state_name?: string;
  category?: string;
  category_name?: string;
  medical_plant?: string;
  reason?: string;
  doctors_note?: string;
  note?: string;
  operate_id?: number;
  operate_name?: string;
  is_payment?: boolean;
  bed_id?: number;
  bed_name?: string;
  ward_id?: number;
  ward_name?: string;
  records_id?: number;
  records_name?: string;
  line_ids?: HospitalizedLine[];
}

export interface Records {
  id?: number;
  name?: string;
  member_id?: number;
  memebr_name?: string;
  gender?: string;
  mobile?: string;
  company_id?: number;
  company_name?: string;
  line_ids?: RecordsLine[];
}
