import {Injectable} from '@angular/core';
import {AppGlobal, Utils} from '../app-global';
import {ApiHttp, ApiResult} from './api-http';

@Injectable()
export class ChargeData {
  data: ApiResult;

  constructor(public api: ApiHttp) {
  }

  async getFeeRemain() {
    return this.api.GetAsync('get_fee_remain', {cid: this.api.cid});
  }

  async getFeeRecharge(offset = 0) {
    return this.api.GetAsync('get_fee_recharge', {offset: offset, cid: this.api.cid});
  }

  async getFeeRecord(offset = 0) {
    return this.api.GetAsync('get_fee_record', {offset: offset, cid: this.api.cid});
  }

  async getPayInfo(amount: number, type: string) {

    let body = new FormData();
    let params = {
      type: type,
      amount: amount,
      duuid: this.api.duuid,
      cuuid: this.api.cuuid,
      timestamp: Utils.getTimestamp(),
    };
    let args = '';

    let key: string;
    for (key in params)
      args += key + "=" + params[key] + "&";

    args = args.substring(0, args.length - 1);

    let sign = Utils.Encrypt(args, AppGlobal.getInstance().AES_KEY);
    body.append('sign', sign);
    return this.api.PostTopAsync('get_pay_info', body);
  }
}


export interface FeeRecord {
  id?: number;
  company_id?: number;
  amount?: number;
  commission_amount?: number;
  operate_create_date?: string;
  month?: string;
  member_name?: string;
  member_mobile?: string;
  partner_name?: string;
  operate_no?: string;
}

export interface FeeRecharge {
  id?: number;
  company_id?: number;
  amount?: number;
  recharge_type?: string;
  recharge_type_str?: string;
  serial_number?: string;
  create_date?: string;
}
