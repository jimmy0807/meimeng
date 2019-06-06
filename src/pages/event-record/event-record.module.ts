import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { EventRecordPage } from './event-record';

@NgModule({
  declarations: [
    EventRecordPage,
  ],
  imports: [
    IonicPageModule.forChild(EventRecordPage),
  ],
  exports: [
    EventRecordPage
  ]
})
export class EventRecordPageModule {}
