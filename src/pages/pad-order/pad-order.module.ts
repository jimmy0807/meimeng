import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { PadOrderPage } from './pad-order';

@NgModule({
  declarations: [
    PadOrderPage,
  ],
  imports: [
    IonicPageModule.forChild(PadOrderPage),
  ],
  exports: [
    PadOrderPage
  ]
})
export class PadOrderPageModule {}
