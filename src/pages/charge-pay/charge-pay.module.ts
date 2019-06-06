import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { ChargePayPage } from './charge-pay';

@NgModule({
  declarations: [
    ChargePayPage,
  ],
  imports: [
    IonicPageModule.forChild(ChargePayPage),
  ],
  exports: [
    ChargePayPage
  ]
})
export class ChargePayPageModule {}
