import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MedicalWorkflowActivityDetail } from './medical-workflow-activity-detail';

@NgModule({
  declarations: [
    MedicalWorkflowActivityDetail,
  ],
  imports: [
    IonicPageModule.forChild(MedicalWorkflowActivityDetail),
  ],
  exports: [
    MedicalWorkflowActivityDetail
  ]
})
export class MedicalWorkflowActivityDetailModule {}
