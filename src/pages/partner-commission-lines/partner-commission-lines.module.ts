import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { PartnerCommissionLinesPage } from './partner-commission-lines';

@NgModule({
  declarations: [
    PartnerCommissionLinesPage,
  ],
  imports: [
    IonicPageModule.forChild(PartnerCommissionLinesPage),
  ],
  exports: [
    PartnerCommissionLinesPage
  ]
})
export class PartnerCommissionLinesPageModule {}
