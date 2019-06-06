import { Injectable } from '@angular/core';
import { ApiHttp, ApiResult } from './api-http';

@Injectable()
export class StockData {
  r: ApiResult;
  constructor(public apiHttp: ApiHttp) {
  }

  async getWarehouseList(withShop = true) {
    let p = withShop ? { sid: this.apiHttp.sid } : null;
    return this.apiHttp.GetAsync('get_warehouse_list', p);
  }

  async getStockLocations(withShop = true) {
    let p = withShop ? { sid: this.apiHttp.sid } : null;
    return this.apiHttp.GetAsync('get_stock_locations', p);
  }

  async getRemovalStrategies() {
    return this.apiHttp.GetAsync('get_removal_strategies');
  }

  async getPutawayStrategies() {
    return this.apiHttp.GetAsync('get_putaway_strategies');
  }

  async getPartners(keyword: string = null, offset = 0) {
    let p: any = { offset: offset };
    if (keyword)
      p.keyword = keyword;
    return this.apiHttp.GetAsync('get_partners', p);
  }

  async getStockProducts(offset = 0, keyword = '') {
    let p: any = { offset: offset };
    if (keyword)
      p.keyword = keyword;
    return this.apiHttp.GetAsync('get_stock_products', p);
  }

  async get_picking_types() {
    return this.apiHttp.GetAsync('get_picking_types', { sid: this.apiHttp.sid })
  }

  async saveStockLocation(item: Location) {
    let f = new FormData();
    if (item.id)
      f.append('id', String(item.id));
    f.append('name', item.name);
    f.append('usage', item.usage);
    if (item.location_id)
      f.append('location_id', String(item.location_id));
    if (item.partner_id)
      f.append('partner_id', String(item.partner_id));
    f.append('scrap_location', String(item.scrap_location ? 1 : 0));
    f.append('return_location', String(item.return_location ? 1 : 0));
    f.append('consumable_location', String(item.consumable_location ? 1 : 0));
    f.append('is_temp_translation', String(item.is_temp_translation ? 1 : 0));
    if (item.removal_strategy_id)
      f.append('removal_strategy_id', String(item.removal_strategy_id));
    if (item.putaway_strategy_id)
      f.append('putaway_strategy_id', String(item.putaway_strategy_id));
    return this.apiHttp.PostAsync('save_stock_location', f);
  }
}

export interface Location {
  scrap_location?: boolean;
  putaway_strategy_id?: boolean;
  usage_name?: string;
  location_name?: string;
  name?: string;
  removal_strategy_name?: boolean;
  partner_name?: string;
  partner_id?: boolean;
  company_id?: number;
  putaway_strategy_name?: boolean;
  shop_name?: string;
  consumable_location?: boolean;
  shop_id?: number;
  company_name?: string;
  usage?: string;
  is_temp_translation?: boolean;
  return_location?: boolean;
  location_id?: boolean;
  id?: number;
  removal_strategy_id?: boolean;
}

export interface Warehouse {
  code?: string;
  lot_stock_id?: number;
  shop_id?: number;
  partner_id?: number;
  id?: number;
  name?: string;
  lot_stock_name?: string;
  partner_name?: string;
  company_id?: number;
  shop_name?: string;
  company_name?: string;
}

