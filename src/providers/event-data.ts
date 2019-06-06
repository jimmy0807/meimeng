import { Injectable } from '@angular/core';
import { AppGlobal } from '../app-global';
import { ApiHttp, ApiResult } from './api-http';

@Injectable()
export class EventData {
  data: ApiResult;
  constructor(public api: ApiHttp) { }

  async getEventList(offset = 0) {
    //event_barcode/events
    let url = `${this.api.api}/event_barcode/events`;
    return this.api.Get(url);
  }

  async getEvent(id: number) {
    //event_barcode/event/<int:event_id>
    let url = `${this.api.api}/event_barcode/event/${id}`;
    return this.api.Get(url);
  }

  async eventSign(eid: number, code: string) {
    ///event_barcode/register_attendee/<int:event_id>/<string:barcode>
    let url = `${this.api.api}/event_barcode/register_attendee/${eid}/${code}?uid=${this.api.uid}`;
    return this.api.Get(url);
  }

  async getEventRecord(eid: number, offset = 0, type = 'register') {
    //event_barcode/attendees/<string:type>/<int:event_id>
    //'register', 'buy'
    let url = `${this.api.api}/event_barcode/attendees/${type}/${eid}?offset=${offset}`;
    return this.api.Get(url);
  }
}

export interface Event {
  id?: number;
  name?: string;
  start_date?: string;
  end_date?: string;
  type?: string;
  count?: number;
  total_attendee?: number;
  image?: string;
  state?: string;
  state_name?: string
}
