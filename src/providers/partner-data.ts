import { Injectable } from '@angular/core';
import { ApiHttp, ApiResult } from './api-http';
import { ZimgProvider } from './zimg';

@Injectable()
export class PartnerData {
  r: ApiResult;
  constructor(public http: ApiHttp, public zimg: ZimgProvider) {
  }

  async getBornPartners(offset = 0, keyword = '') {
    let p = {
      sid: this.http.sid,
      offset: offset
    };
    if (keyword)
      p['keyword'] = keyword;
    return this.http.GetAsync('get_born_partners', p);
  }

  async getBornPartnerNames(offset = 0, keyword = null, cat = null, parentId = null) {
    let p = { offset: offset };
    if (keyword)
      p['keyword'] = keyword;
    if (cat)
      p['cat'] = cat;
    if (parentId)
      p['parent_id'] = parentId;
    return this.http.GetAsync('get_born_partner_names', p);
  }

  async saveBornPartner(i: Partner) {
    let body = new FormData();
    this.http.appendStrings(body, i, [
      'id',
      'name',
      'mobile',
      'partner_category',
      'city_region',
      'sign_address',
      'identification',
      'used_to_name',
      'introducer',
      'sign_date',
      'last_active_date',
      'designer_employee_id',
      'business_employee_id',
      'bank',
      'bank_name',
      'bank_account',
      'bank_user',
      'street',
      'note',
      'dj_percent',
      'dj_parent_percent',
      'dd_partner_id',
      'dd_percent',
      'dl_partner_id_1',
      'dl_partner_id_2',
      'dl_partner_id_3',
      'dl1_percent',
      'dl2_percent',
      'dl3_percent',
      'representative',
      'parent_id',

      'shop_size',
      'shop_create_date',
      'shop_main_product',
      'shop_member_cnt',
      'shop_employee_cnt',
      'shop_operating_note',
    ]);

    this.http.appendBooleans(body, i, [
      'is_in',
      'is_end',
      'is_referral',
      'is_referral_shop',
      'is_self_shop',
    ]);
    if (!i.id && i.image_ids && i.image_ids.length) {
      for (let img of i.image_ids) {
        let r = await this.zimg.uploadBase64(img.image);
        if (r.ret)
          img.image_url = r.url;
        else
          return this.zimg.Error();
      }
      let ids = i.image_ids.map(img => <PartnerImage>{ image_url: img.image_url, name: img.name, type: img.type });
      body.append('image_ids', JSON.stringify(ids));
    }
    if (i.designer_employee_ids) {
      let ids = i.designer_employee_ids.map(e => e.id);
      body.append('designer_employee_ids', JSON.stringify(ids));
    }
    return this.http.PostAsync('save_born_partner', body);
  }

  async deleteBornPartner(id) {
    return this.http.GetAsync('delete_born_partner', { id: id });
  }

  async savePartnerImage(i: PartnerImage, pid: number) {
    let body = new FormData();
    if (i.id)
      body.append('id', String(i.id));
    if (i.image) {
      let r = await this.zimg.uploadBase64(i.image);
      if (r.ret)
        i.image_url = r.url;
      else
        return this.zimg.Error();
      body.append('image_url', i.image_url);
    }
    body.append('partner_id', String(pid));
    body.append('name', i.name);
    if (i.type)
      body.append('type', String(i.type));
    return this.http.PostAsync('save_partner_image', body);
  }

  async deletePartnerImage(id: number) {
    return this.http.GetAsync('delete_partner_image', { id: id });
  }

  async getBornRegions() {
    return this.http.GetAsync('get_born_regions');
  }

  async getDesignerEmployees(offset = 0, keyword = null) {
    let p = { offset: offset };
    if (keyword)
      p['keyword'] = keyword;
    return this.http.GetAsync('get_designer_employees', p);
  }

  async getBusinessEmployees(offset = 0, keyword = null) {
    let p = { offset: offset };
    if (keyword)
      p['keyword'] = keyword;
    return this.http.GetAsync('get_business_employees', p);
  }

  async getCommissionLevels() {
    return this.http.GetAsync('get_commission_levels');
  }

  async getPartnerCommission(id, offset = 0) {
    return this.http.GetAsync('get_partner_commission', { id: id, offset: offset });
  }

  async getPartnersCommission(ids: number[]) {
    let data = new FormData();
    data.append('ids', JSON.stringify(ids));
    return this.http.PostAsync('get_partners_commission', data);
  }

  async getPartnerCommissionDay(start = '', end = '') {
    return this.http.GetAsync('get_partner_commission_day', {
      start: start,
      end: end
    });
  }

  async getImageTypes() {
    return this.http.GetAsync('get_visit_dictionary', { type: 3 });
  }
}

export interface PartnerImage {
  id?: number;
  image_url?: string;
  image?: string;
  partner_id?: number;
  name?: string;
  type?: number;
  type_name?: string;
}

export interface Partner {
  id?: number;
  name?: string;
  mobile?: string;
  display_mobile?: string;
  partner_category?: string;
  partner_category_name?: string;
  city_region?: string;
  sign_address?: string;
  identification?: string;
  used_to_name?: string;
  introducer?: string;
  sign_date?: string;
  last_active_date?: string;
  is_in?: boolean;
  is_end?: boolean;
  designer_employee_id?: number;
  designer_employee_name?: string;
  designer_employee_ids?: {
    id?: null;
    name?: string;
  }[];
  designer_employee_names?: string;
  business_employee_id?: number;
  business_employee_name?: string;

  image_ids?: PartnerImage[];
  bank?: string;
  bank_name?: string;
  bank_account?: string;
  bank_user?: string;
  street?: string;
  note?: string;

  //dj
  shop_name?: string;
  shop_address?: string;

  dj_percent?: number;
  dj_parent_percent?: number;
  dd_percent?: number;
  dd_partner_id?: number;
  dd_partner_name?: string;

  dl_partner_id_1?: number;
  dl_partner_name_1?: string;
  dl_partner_id_2?: number;
  dl_partner_name_2?: string;
  dl_partner_id_3?: number;
  dl_partner_name_3?: string;
  dl1_percent?: number;
  dl2_percent?: number;
  dl3_percent?: number;

  is_referral_shop?: boolean;
  is_self_shop?: boolean;

  shop_size?: string;
  shop_create_date?: string;
  shop_main_product?: string;
  shop_member_cnt?: string;
  shop_employee_cnt?: string;
  shop_operating_note?: string;

  //dd
  representative?: string;
  //dl
  parent_id?: number;

  parent_name?: string;
  is_referral?: boolean;
}

export interface PartnerCommission {
  base_amount?: number;
  date?: string;
  dj_name?: string;
  create_date?: string;
  partner_category?: string;
  partner_name?: string;
  partner_id?: number;
  member_name?: string;
  id?: number;
  shop_name?: string;
}

export interface PartnerCommissionDay {
  date?: string;
  count?: number;
  amount?: number;
  ids?: number[];
}


