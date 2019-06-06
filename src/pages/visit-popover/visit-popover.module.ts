import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { VisitPopoverPage } from './visit-popover';

@NgModule({
  declarations: [
    VisitPopoverPage,
  ],
  imports: [
    IonicPageModule.forChild(VisitPopoverPage),
  ],
  exports: [
    VisitPopoverPage
  ]
})
export class VisitPopoverPageModule {}
