import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { ChargePage } from './charge';

@NgModule({
  declarations: [
    ChargePage,
  ],
  imports: [
    IonicPageModule.forChild(ChargePage),
  ],
  exports: [
    ChargePage
  ]
})
export class ChargePageModule {}
