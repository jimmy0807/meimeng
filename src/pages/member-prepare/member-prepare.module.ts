import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MemberPreparePage } from './member-prepare';

@NgModule({
  declarations: [
    MemberPreparePage,
  ],
  imports: [
    IonicPageModule.forChild(MemberPreparePage),
  ],
  exports: [
    MemberPreparePage
  ]
})
export class MemberPreparePageModule {}
