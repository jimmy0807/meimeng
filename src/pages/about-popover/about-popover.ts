import { Component } from '@angular/core';

import { ViewController } from 'ionic-angular';


@Component({
  templateUrl: 'about-popover.html'
})
export class PopoverPage {

  constructor(public viewCtrl: ViewController) { }

  close() {
    this.viewCtrl.dismiss('item');
  }
  doItem() {
    this.viewCtrl.dismiss('item');
  }
  doKpi() {
    this.viewCtrl.dismiss('kpi');
  }

}
