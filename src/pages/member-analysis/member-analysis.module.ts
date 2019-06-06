import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MemberAnalysisPage } from './member-analysis';

@NgModule({
  declarations: [
    MemberAnalysisPage,
  ],
  imports: [
    IonicPageModule.forChild(MemberAnalysisPage),
  ],
  exports: [
    MemberAnalysisPage
  ]
})
export class MemberAnalysisPageModule {}
