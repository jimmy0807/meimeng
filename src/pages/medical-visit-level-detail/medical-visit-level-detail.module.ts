import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MedicalVisitLevelDetail } from './medical-visit-level-detail';

@NgModule({
  declarations: [
    MedicalVisitLevelDetail,
  ],
  imports: [
    IonicPageModule.forChild(MedicalVisitLevelDetail),
  ],
  exports: [
    MedicalVisitLevelDetail
  ]
})
export class MedicalVisitLevelDetailModule {}
