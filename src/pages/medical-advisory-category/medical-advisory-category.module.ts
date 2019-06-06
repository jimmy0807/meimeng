import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MedicalAdvisoryCategory } from './medical-advisory-category';

@NgModule({
  declarations: [
    MedicalAdvisoryCategory,
  ],
  imports: [
    IonicPageModule.forChild(MedicalAdvisoryCategory),
  ],
  exports: [
    MedicalAdvisoryCategory
  ]
})
export class MedicalAdvisoryCategoryModule {}
