import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { ChargeLogPage } from './charge-log';

@NgModule({
  declarations: [
    ChargeLogPage,
  ],
  imports: [
    IonicPageModule.forChild(ChargeLogPage),
  ],
  exports: [
    ChargeLogPage
  ]
})
export class ChargeLogPageModule {}
