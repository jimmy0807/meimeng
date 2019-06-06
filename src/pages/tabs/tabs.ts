import { Component, ViewChild } from '@angular/core';
import { StatusBar } from '@ionic-native/status-bar';
import { HomePage } from '../home/home';
import { AboutPage } from '../about/about';
import { CommunityPage } from '../community/community';
import { MessageListPage } from '../message-list/message-list';
import { MessageData } from '../../providers/message-data'
import { Tabs } from "ionic-angular";

@Component({
  templateUrl: 'tabs.html'
})

export class TabsPage {
  @ViewChild('mainTabs') tabs: Tabs;

  tab1Root: any = HomePage;
  tab2Root: any = MessageListPage;
  tab3Root: any = CommunityPage;
  tab4Root: any = AboutPage;

  msgCount: any = {};

  constructor(public messageData: MessageData,
    public statusBar: StatusBar) {
  }

  ionViewDidLoad() {
    this.statusBar.show();
    this.countMsgs();
  }

  countMsgs() {
    this.messageData.getMessageCount().then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.msgCount = data.data;
          let count = Number(this.msgCount.count);
          if (count > 99)
            this.msgCount.badge = '99+';
          else if (count > 0)
            this.msgCount.badge = count.toString();
          else
            this.msgCount.badge = '';
        }
      }
    )
  }
}
