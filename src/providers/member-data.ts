import { Injectable } from '@angular/core';
import { Http } from '@angular/http';
import { AppGlobal } from '../app-global';
import { ApiHttp, ApiResult } from './api-http';

@Injectable()
export class MemberData {
  listData: ApiResult;
  constructor(public http: Http,
    public apiHttp: ApiHttp) { }

  async getMemberList(offset, keyword, filters = null, simple = false) {
    if (!filters)
      filters = {};
    let gl = AppGlobal.getInstance();
    let f = {
      shop_id: this.apiHttp.sid,
      simple: simple,
      offset: offset || 0,
      medical: gl.groupMedical,

      keyword: keyword || false,
      birthday_month: Number(filters.birthday_month) || false,
      employee_id: Number(filters.employee_id) || false,
      un_consume_day: Number(filters.un_consume_day) || false,
      consume_day: Number(filters.consume_day) || false,
      max_amount: Number(filters.max_amount) || false,
      min_amount: Number(filters.min_amount) || false,
      max_recharge_amount: Number(filters.max_recharge_amount) || false,
      min_recharge_amount: Number(filters.min_recharge_amount) || false,
      max_consumption_amount: Number(filters.max_consumption_amount) || false,
      min_consumption_amount: Number(filters.min_consumption_amount) || false,
    }
    let body = new FormData();
    body.append('filters', JSON.stringify(f));
    return this.apiHttp.PostAsync('get_member_list', body);
  }

  async getAllMembers(keyword = null) {
    let p = {
      sid: this.apiHttp.sid,
    };
    if (keyword)
      p['keyword'] = keyword;
    return this.apiHttp.GetAsync('get_all_members', p);
  }

  async getMemberInfo(mid: number) {
    let p = {
      sid: this.apiHttp.sid,
      mid: mid,
    }
    return this.apiHttp.GetAsync('get_member_info', p);
  }

  async saveMember(m: Member, changeMobile = false, changeImage = false) {
    let p = {
      sid: this.apiHttp.sid,
      medical: AppGlobal.getInstance().groupMedical ? 1 : 0,
    };
    let body = new FormData();
    this.apiHttp.appendStrings(body, m, [
      'id',
      'name',
      'employee_id',
      'technician_id',
      'birth_date',
      'gender',
      'member_level',
      'qq',
      'wx',
      'email',
      'id_card_no',
      'street',
      'recommend_type',
      'parent_id',
      'category',
      'member_source',
      'dj_partner_id',
      'designers_id',
      'director_employee_id',
      'member_type',
      'belong_id',

      'sign_date',
      'blood_type',
      'astro',
      'note',
    ])
    //m.
    this.apiHttp.appendBooleans(body, m, [
      'is_ad'
    ]);
    if (changeMobile && m.mobile)
      body.append('mobile', m.mobile);
    if (changeImage && m.image)
      body.append('image', m.image);
    return this.apiHttp.PostAsync("save_member", body, p);
  }

  async getMemberSource() {
    return this.apiHttp.GetAsync('get_member_source');
  }

  async getMemberBelongs() {
    return this.apiHttp.GetAsync('get_member_belongs');
  }

  async getMemberCards(mid: number) {
    return this.apiHttp.GetAsync('get_member_cards', { mid: mid });
  }

  async importMemberCard(mid: number, card: Card) {
    let body = new FormData();
    body.append('no', card.no);
    body.append('pricelist_id', String(card.pricelist_id));
    body.append('amount', String(card.amount || 0));
    body.append('give_amount', String(card.give_amount || 0));
    body.append('points', String(card.points || 0));
    if (card.invalid_date)
      body.append('invalid_date', card.invalid_date);
    if (card.product_ids && card.product_ids.length) {
      let ids = card.product_ids.map(p => <CardLine>{
        limited_date: p.limited_date || false,
        product_id: p.product_id,
        limited_qty: p.limited_qty || false,
        qty: p.qty || 1,
        price_unit: p.price_unit || 0,
      })
      body.append('product_ids', JSON.stringify(ids));
    }
    if (card.arrears_ids && card.arrears_ids.length) {
      body.append('arrears_ids', JSON.stringify(card.arrears_ids));
    }
    return this.apiHttp.PostAsync('import_member_card', body, { mid: mid })
  }

  async getMemberVisits(mid: number, offset = 0) {
    return this.apiHttp.GetAsync('get_member_visits', { mid: mid, offset: offset });
  }

  async getMemberExtendedss(mid: number, offset = 0) {
    return this.apiHttp.GetAsync('get_member_extendeds', { mid: mid, offset: offset });
  }

  async getMemberRelatives(mid: number, offset = 0) {
    return this.apiHttp.GetAsync('get_member_relatives', { mid: mid, offset: offset });
  }

  async getMemberImages(mid: number, offset = 0) {
    return this.apiHttp.GetAsync('get_member_images', { mid: mid, offset: offset });
  }

  async saveMemberImage(img) {
    let body = new FormData();
    this.apiHttp.appendStrings(body, img, [
      'member_id',
      'image',
      'operate_id',
      'take_time'
    ]);
    return this.apiHttp.PostAsync('save_member_image', body);
  }

  async getPadOrders(mid: number, offset: number = 0) {
    return this.apiHttp.GetAsync('get_pad_orders', { mid: mid, offset: offset });
  }

  async savePadOrder(p: PadOrder) {
    let body = new FormData();
    p.shop_id = this.apiHttp.sid;
    this.apiHttp.appendStrings(body, p, [
      'id',
      'member_id',
      'shop_id',
      'employee_id',
      'designers_id',
      'doctor_id',
      'director_employee_id',
      'departments_id',
      'remark',
      'note',
    ]);
    p.pad_order_line_ids = p.card_lines.concat(p.lines);
    if (p.pad_order_line_ids && p.pad_order_line_ids.length) {
      let lines = p.pad_order_line_ids.map(l => <PadOrderLine>{
        born_product_id: l.born_product_id || 0,
        open_price: l.open_price || 0,
        product_id: l.product_id,
        qty: l.qty || 1
      });
      body.append('pad_order_line_ids', JSON.stringify(lines));
    }
    return this.apiHttp.PostAsync('save_pad_order', body);
  }

  async deletePadOrder(id) {
    return this.apiHttp.GetAsync('delete_pad_order', { id: id });
  }

  async getMemberOperates(mid: number, offset = 0) {
    return this.apiHttp.GetAsync('get_member_operates', { mid: mid, offset: offset });
  }

  async getMemberStatements(mid: number, offset = 0) {
    return this.apiHttp.GetAsync('get_member_statements', { mid: mid, offset: offset });
  }

  async getMemberPoints(mid: number, offset = 0) {
    return this.apiHttp.GetAsync('get_member_points', { mid: mid, offset: offset });
  }

  async getMemberCommissions(mid: number, offset = 0) {
    return this.apiHttp.GetAsync('get_member_commissions', { mid: mid, offset: offset });
  }

  async getMemberProductLines(mid: number, offset = 0) {
    return this.apiHttp.GetAsync('get_member_product_lines', { mid: mid, offset: offset });
  }

  async getMemberCardProducts(mid: number) {
    return this.apiHttp.GetAsync('get_member_card_products', { mid: mid });
  }

  async getMemberMedicalRecord(mid: number) {
    return this.apiHttp.GetAsync('get_member_medical_record', { mid: mid });
  }

  async getMemberPrepares(mid: number, offset = 0) {
    return this.apiHttp.GetAsync('get_member_prepares', { mid: mid, offset: offset });
  }

  async saveMemberPrepare(p: MemberPrepare) {
    let data = new FormData()
    this.apiHttp.appendStrings(data, p, [
      'id',
      'member_id',
      'employee_id',
      'prepare_date',
    ]);
    this.apiHttp.appendBooleans(data, p, ['is_consume']);
    if (p.be_part_ids)
      data.append('be_part_ids', JSON.stringify(p.be_part_ids.map(i => i.id)));
    if (p.be_resist_ids)
      data.append('be_resist_ids', JSON.stringify(p.be_resist_ids.map(i => i.id)));
    return this.apiHttp.PostAsync('save_member_prepare', data);
  }

  async getMemberMedicalInfo(mid: number) {
    return this.apiHttp.GetAsync('get_member_medical_info', { mid: mid });
  }

  async saveMemberMedicalInfo(m: MemberMedicalInfo) {
    let data = new FormData()
    this.apiHttp.appendStrings(data, m, [
      'id',
      'be_beauty_cnt',
      'be_years_cnt',
      'be_month_consume_cnt',
      'be_year_consume_amount',
      'be_total_consume_amount',
    ]);
    if (m.be_beauty_ids)
      data.append('be_beauty_ids', JSON.stringify(m.be_beauty_ids.map(i => i.id)));
    if (m.be_character_ids)
      data.append('be_character_ids', JSON.stringify(m.be_character_ids.map(i => i.id)));
    if (m.be_consumption_ids)
      data.append('be_consumption_ids', JSON.stringify(m.be_consumption_ids.map(i => i.id)));
    if (m.be_interest_ids)
      data.append('be_interest_ids', JSON.stringify(m.be_interest_ids.map(i => i.id)));
    if (m.be_attention_ids)
      data.append('be_attention_ids', JSON.stringify(m.be_attention_ids.map(i => i.id)));
    return this.apiHttp.PostAsync('save_member_medical_info', data);
  }

  async getBeauty() {
    return this.apiHttp.GetAsync('get_visit_dictionary', { type: 4 });
  }
  async getCharacter() {
    return this.apiHttp.GetAsync('get_visit_dictionary', { type: 5 });
  }
  async getConsumption() {
    return this.apiHttp.GetAsync('get_visit_dictionary', { type: 6 });
  }
  async getInterest() {
    return this.apiHttp.GetAsync('get_visit_dictionary', { type: 7 });
  }
  async getAttention() {
    return this.apiHttp.GetAsync('get_visit_dictionary', { type: 8 });
  }
  async getPart() {
    return this.apiHttp.GetAsync('get_visit_dictionary', { type: 9 });
  }
  async getResist() {
    return this.apiHttp.GetAsync('get_visit_dictionary', { type: 10 });
  }
}

export interface Member {
  rid?: number;
  create_date?: string;
  street?: string;
  id_card_no?: string;
  id?: number;
  technician_id?: number;
  category?: string;
  employee_id?: number;
  last_date?: string;
  shop_name?: string;
  member_level?: string;
  recommend_type?: number;
  recommend_type_name?: string;
  email?: string;
  product_amount?: number;
  technician_name?: string;
  employee_name?: string;
  member_source?: number;
  referee_name_name?: string;
  wx?: string;
  qq?: string;
  name?: string;
  mobile?: string;
  gender?: string;
  referee_name?: number;
  member_source_name?: string;
  is_ad?: boolean;
  amount?: number;
  shop_id?: number;
  image?: string;
  image_url?: string;
  birth_date?: string;

  checked?: boolean;

  belong_id?: number;
  belong_name?: string;
  dj_partner_id?: number,
  dj_partner_name?: string,
  dd_partner_id?: number,
  dd_partner_name?: string,
  dl_partner_id?: number,
  dl_partner_name?: string,
  parent_id?: number,
  parent_name?: string,
  designers_id?: number,
  designers_name?: string,
  director_employee_id?: number;
  director_employee_name?: string;
}

export interface Card {
  id?: number;
  member_id?: number;
  no?: string;
  pricelist_id?: number;
  pricelist_name?: string;
  amount?: number;
  give_amount?: number;
  points?: number;
  invalid_date?: string;
  is_invalid?: boolean;
  product_ids?: CardLine[];
  arrears_ids?: Arrears[];
}

export interface CardLine {
  id?: number;
  product_id?: number;
  name?: string;
  qty?: number;
  remain_qty?: number;
  price_unit?: number;
  lst_price?: number;
  limited_qty?: boolean;
  limited_date?: string;
  checked?: boolean;
}

export interface Arrears {
  type?: string,
  name?: string,
  arrears_amount?: number,
  remark?: string,
}

export interface PadOrder {
  id?: number,
  no?: string,
  date?: string,
  time?: string,
  line_names?: string,
  member_id?: number,
  member_name?: string,
  shop_id?: number,

  employee_id?: number,
  employee_name?: string,
  designers_id?: number,
  designers_name?: string,
  doctor_id?: number,
  doctor_name?: string,
  director_employee_id?: number,
  director_employee_name?: string,
  departments_id?: number;
  departments_name?: string;

  remark?: string,
  note?: string,

  pad_order_line_ids?: PadOrderLine[];

  lines?: PadOrderLine[];
  card_lines?: PadOrderLine[];
}

export interface PadOrderLine {
  product_id?: number;
  born_product_id?: number;
  qty?: number;
  open_price?: number;
  name?: string;
  limit?: number;
}

export interface MemberPrepare {
  id?: number;
  member_id?: number;
  member_name?: string;
  employee_id?: number;
  employee_name?: string;
  be_part_ids?: DictItem[];
  part_names?: string;
  be_resist_ids?: DictItem[];
  resist_names?: string;
  prepare_date?: string;
  is_consume?: boolean;
}

export interface MemberMedicalInfo {
  id?: number;
  be_beauty_ids?: DictItem[];
  beauty_names?: string;
  be_character_ids?: DictItem[];
  character_names?: string;
  be_consumption_ids?: DictItem[];
  consumption_names?: string;
  be_interest_ids?: DictItem[];
  interest_names?: string;
  be_attention_ids?: DictItem[];
  attention_names?: string;
  be_beauty_cnt?: string;
  be_years_cnt?: number;
  be_month_consume_cnt?: number;
  be_year_consume_amount?: number;
  be_total_consume_amount?: number;
}

export interface DictItem {
  id?: number,
  name?: string,
}
