import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MedicalWorkflowDetail } from './medical-workflow-detail';

@NgModule({
  declarations: [
    MedicalWorkflowDetail,
  ],
  imports: [
    IonicPageModule.forChild(MedicalWorkflowDetail),
  ],
  exports: [
    MedicalWorkflowDetail
  ]
})
export class MedicalWorkflowDetailModule {}
