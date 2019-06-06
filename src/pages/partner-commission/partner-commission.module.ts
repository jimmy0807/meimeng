import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { PartnerCommissionPage } from './partner-commission';

@NgModule({
  declarations: [
    PartnerCommissionPage,
  ],
  imports: [
    IonicPageModule.forChild(PartnerCommissionPage),
  ],
  exports: [
    PartnerCommissionPage
  ]
})
export class PartnerCommissionPageModule {}
