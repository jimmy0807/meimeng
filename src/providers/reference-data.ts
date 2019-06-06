import { Injectable } from '@angular/core';
import { Http } from '@angular/http';

import { AppGlobal } from '../app-global';

@Injectable()
export class PeferenceData {
  constructor(public http: Http) { }

  launch(device_uuid) {
    let commonLaunch = AppGlobal.getInstance().api + "/api/common_launch?device_uuid=" + device_uuid;

    return new Promise(resolve => {
      this.http.get(commonLaunch).subscribe(res => {
        let data = res.json();
        resolve(data);
      });
    });
  }
}
