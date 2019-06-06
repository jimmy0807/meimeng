import { Injectable } from '@angular/core';

import { ApiHttp, ApiResult } from './api-http';

@Injectable()
export class DeviceData {

  data: ApiResult;

  constructor(public http: ApiHttp) {
  }

  async getDeviceList(offset = 0) {
    let p = {
      sid: this.http.sid,
      offset: offset || 0,
      limit: 20,
    }
    return this.http.GetAsync('get_deviceLists', p);
  }

  async changeState(params) {
    let p = {
      id: params.id,
      state: params.state,
    }
    return this.http.GetAsync('change_state', p);
  }

  async deleteDevice(id: number) {
    return this.http.GetAsync('delete_device', { id: id });
  }
}
