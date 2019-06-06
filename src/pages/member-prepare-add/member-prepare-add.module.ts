import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MemberPrepareAddPage } from './member-prepare-add';

@NgModule({
  declarations: [
    MemberPrepareAddPage,
  ],
  imports: [
    IonicPageModule.forChild(MemberPrepareAddPage),
  ],
  exports: [
    MemberPrepareAddPage
  ]
})
export class MemberPrepareAddPageModule {}
