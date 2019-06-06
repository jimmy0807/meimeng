import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { CommissionLevelDetail } from './commission-level-detail';

@NgModule({
  declarations: [
    CommissionLevelDetail,
  ],
  imports: [
    IonicPageModule.forChild(CommissionLevelDetail),
  ],
  exports: [
    CommissionLevelDetail
  ]
})
export class CommissionLevelDetailModule {}
