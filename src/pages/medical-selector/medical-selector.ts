import { Component } from '@angular/core';
import { NavController, NavParams, InfiniteScroll, ToastController, ViewController, LoadingController } from 'ionic-angular';
import { PartnerData } from '../../providers/partner-data';
import { EmployeeData } from '../../providers/employee-data';
import { MemberData } from '../../providers/member-data';
import { ProductData } from '../../providers/product-data';
import { ApiResult } from '../../providers/api-http';
import { MedicalData } from '../../providers/medical-data';
import { ConsumerData } from '../../providers/consumer-data';
import { PosCategoryData } from '../../providers/pos-category-data';
import { VisitData } from '../../providers/visit-data';

export enum SelectorType {
  Customer,
  Member,
  Partner,
  Employee,
  BookEmployee,
  Reservation,
  Receiver,
  Tags,
  Split,
  Product,
  Operate,
  VisitOperate,
  Doctor,
  Nurse,
  Ward,
  Bed,
  Department,
  Workflow,
  Activity,
  PosCategory,
  Records,
  Uom,
  DD,
  DJ,
  DL,
  Designer,
  Business,
  Director,
  VisitQuestion,
  CommissionTeam,
  User,
  MemberBeauty,
  MemberCharacter,
  MemberConsumption,
  MemberInterest,
  MemberAttention,
  MemberPart,
  MemberResist
}

@Component({
  selector: 'page-medical-selector',
  templateUrl: 'medical-selector.html'
})
export class MedicalSelectorPage {
  r: ApiResult;
  title: string;
  keyword = '';
  data;
  items: {
    id?: number,
    name?: string,
    note?: string;
    checked?: boolean,
  }[] = [];
  infiniteEnabled = true;
  singleMode = true;
  searchHolder: string = '按姓名，手机搜索';
  showSearch = true;
  type: SelectorType = SelectorType.Member;
  typeName: string;
  constructor(public navCtrl: NavController,
    public viewCtrl: ViewController,
    public loadingCtrl: LoadingController,
    public partnerData: PartnerData,
    public employeeData: EmployeeData,
    public memberData: MemberData,
    public posCategoryData: PosCategoryData,
    public productData: ProductData,
    public medicalData: MedicalData,
    public consumerData: ConsumerData,
    public toastCtrl: ToastController,
    public visitData: VisitData,
    public navParams: NavParams) {
    this.singleMode = navParams.data.single;
    this.type = navParams.data.type;
    this.data = navParams.data.data;
    this.typeName = SelectorType[this.type];
    this.initView();
  }

  initView() {
    switch (this.type) {
      case SelectorType.Member:
        this.title = '会员';
        break;
      case SelectorType.Employee:
        this.title = '员工';
        break;
      case SelectorType.Customer:
        this.title = '客户';
        break;
      case SelectorType.Partner:
        this.title = '渠道商';
        this.searchHolder = '按名称搜索';
        break;
      case SelectorType.Reservation:
        this.title = '预约';
        this.showSearch = false;
        break;
      case SelectorType.Receiver:
        this.title = '咨询师';
        break;
      case SelectorType.Tags:
        this.title = '标签';
        this.showSearch = false;
        break;
      case SelectorType.Split:
        this.title = '分诊单';
        this.showSearch = false;
      case SelectorType.Product:
        this.title = '项目';
        break;
      case SelectorType.Operate:
        this.title = '订单';
        break;
      case SelectorType.Doctor:
        this.title = '医生';
        break;
      case SelectorType.Nurse:
        this.title = '护士';
        break;
      case SelectorType.Ward:
        this.title = '病房';
        this.showSearch = false;
        break;
      case SelectorType.Bed:
        this.showSearch = false;
        this.title = '床位';
        break;
      case SelectorType.Department:
        this.showSearch = false;
        this.title = '诊室';
        break;
      case SelectorType.Workflow:
        this.showSearch = false;
        this.title = '工作流';
        break;
      case SelectorType.Activity:
        this.showSearch = false;
        this.title = '流程';
        break;
      case SelectorType.PosCategory:
        this.title = '分类';
        this.searchHolder = '按名称搜索';
        break;
      case SelectorType.Records:
        this.title = '病历卡';
        this.showSearch = false;
        break;
      case SelectorType.Uom:
        this.title = '单位';
        this.showSearch = false;
        break;
      case SelectorType.DD:
        this.title = '督导';
        this.searchHolder = '按名称搜索';
        break;
      case SelectorType.DJ:
        this.title = '店家';
        this.searchHolder = '按名称搜索';
        break;
      case SelectorType.DL:
        this.title = '代理';
        this.searchHolder = '按名称搜索';
        break;
      case SelectorType.Business:
        this.title = '业务员';
        this.searchHolder = '按名称搜索';
        break;
      case SelectorType.Designer:
        this.title = '设计师';
        this.searchHolder = '按名称搜索';
        break;
      case SelectorType.Director:
        this.title = '设计总监';
        this.searchHolder = '按名称搜索';
        break;
      case SelectorType.VisitQuestion:
        this.title = '术后问题类型';
        this.showSearch = false;
        break;
      case SelectorType.CommissionTeam:
        this.title = '市场团队';
        this.showSearch = false;
        break;
      case SelectorType.VisitOperate:
        this.title = '治疗记录';
        this.showSearch = false;
        break;
      case SelectorType.BookEmployee:
        this.title = '预约对象';
        break;
      case SelectorType.User:
        this.title = '用户';
        this.showSearch = false;
        break;
      case SelectorType.MemberBeauty:
        this.title = '求美初发心';
        this.showSearch = false;
        break;
      case SelectorType.MemberCharacter:
        this.title = '性格分析';
        this.showSearch = false;
        break;
      case SelectorType.MemberConsumption:
        this.title = '消费习惯';
        this.showSearch = false;
        break;
      case SelectorType.MemberInterest:
        this.title = '兴趣爱好';
        this.showSearch = false;
        break;
      case SelectorType.MemberAttention:
        this.title = '消费关注';
        this.showSearch = false;
        break;
      case SelectorType.MemberPart:
        this.title = '铺垫部位';
        this.showSearch = false;
        break;
      case SelectorType.MemberResist:
        this.title = '主要抗拒点';
        this.showSearch = false;
        break;
    }
  }

  async ngAfterViewInit() {
    let loader = this.loadingCtrl.create({ spinner: 'bubbles' });
    loader.present();
    try {
      await this.getItems();
    }
    finally {
      loader.dismiss();
    }
  }

  async getItems(offset = 0) {
    let r = await this.switchActions(offset);
    if (r.errcode === 0) {
      this.items = this.formatItems(r.data);
      this.infiniteEnabled = this.items.length === 20;
    }
    else {
      this.showToast(r.errmsg);
    }
  }

  async switchActions(offset: number) {
    switch (this.type) {
      case SelectorType.Partner: return this.partnerData.getBornPartnerNames(offset, this.keyword);
      case SelectorType.DD: return this.partnerData.getBornPartnerNames(offset, this.keyword, 'dd', this.data);
      case SelectorType.DJ: return this.partnerData.getBornPartnerNames(offset, this.keyword, 'dj', this.data);
      case SelectorType.DL: return this.partnerData.getBornPartnerNames(offset, this.keyword, 'dl', this.data);
      case SelectorType.Employee: return this.employeeData.getEmployees(offset, this.keyword);
      case SelectorType.Member: return this.memberData.getAllMembers(this.keyword);
      case SelectorType.Customer: return this.medicalData.getMedicalCustomers(offset, this.keyword);
      case SelectorType.Receiver: return this.medicalData.getMedicalReceivers(offset, this.keyword);
      case SelectorType.Reservation: return this.medicalData.getMedicalReservations(offset);
      case SelectorType.Tags: return this.medicalData.getMedicalTags();
      case SelectorType.Split: return this.medicalData.getMedicalSplits(offset);
      case SelectorType.Product: return this.productData.getAllProduct(offset, this.keyword);
      case SelectorType.Operate: return this.medicalData.getMedicalPosOperates(offset);
      case SelectorType.Doctor: return this.employeeData.getEmployees(offset, this.keyword, 'doctors');
      case SelectorType.Nurse: return this.employeeData.getEmployees(offset, this.keyword, 'operater');
      case SelectorType.Ward: return this.medicalData.getMedicalWards(offset);
      case SelectorType.Bed: return this.medicalData.getMedicalBeds(offset);
      case SelectorType.Department: return this.medicalData.getBornDepartments();
      case SelectorType.Workflow: return this.medicalData.getBornWorkflows();
      case SelectorType.Activity: return this.medicalData.getWorkflowActivities(offset);
      case SelectorType.PosCategory: return this.posCategoryData.getPosCategories(offset, this.keyword);
      case SelectorType.Records: return this.medicalData.getMedicalRecords(offset);
      case SelectorType.Uom: return this.medicalData.getMedicalUoms();
      case SelectorType.Business: return this.partnerData.getBusinessEmployees(offset, this.keyword);
      case SelectorType.Designer: return this.employeeData.getEmployees(offset, this.keyword, 'designers');
      case SelectorType.Director: return this.employeeData.getEmployees(offset, this.keyword, 'director');
      case SelectorType.VisitQuestion: return this.visitData.getVisitQuestions();
      case SelectorType.CommissionTeam: return this.visitData.getCommissionTeams();
      case SelectorType.VisitOperate: return this.visitData.getMedicalOperate(this.data);
      case SelectorType.BookEmployee: return this.employeeData.getEmployees(offset, this.keyword, null, true);
      case SelectorType.User: return this.consumerData.getConsumerList(offset);
      case SelectorType.MemberBeauty: return this.memberData.getBeauty();
      case SelectorType.MemberCharacter: return this.memberData.getCharacter();
      case SelectorType.MemberConsumption: return this.memberData.getConsumption();
      case SelectorType.MemberInterest: return this.memberData.getInterest();
      case SelectorType.MemberAttention: return this.memberData.getAttention();
      case SelectorType.MemberPart: return this.memberData.getPart();
      case SelectorType.MemberResist: return this.memberData.getResist();
    }
  }

  onSelected(item) {
    if (this.singleMode)
      this.viewCtrl.dismiss(item);
  }

  save() {
    let data = this.items.filter(i => i.checked);
    this.viewCtrl.dismiss(data);
  }


  onInput(ev) {
    this.getItems();
  }

  onCancel(ev) {
    this.keyword = '';
  }

  formatItems(data) {
    let arr = <any[]>data;
    switch (this.type) {
      case SelectorType.Split:
        arr.forEach(i => i['name'] = i['customer_name']); break;
      case SelectorType.PosCategory:
        arr.forEach(i => i['name'] = i['complete_name']); break;
    }
    return arr;
  }

  async doInfinite(infiniteScroll: InfiniteScroll) {
    try {
      let r = await this.switchActions(this.items.length);
      if (r.errcode === 0) {
        let arr = this.formatItems(r.data);
        for (var i = 0; i < arr.length; i++) {
          this.items.push(arr[i]);
        }
        this.infiniteEnabled = arr.length === 20;
      }
      else {
        this.showToast(r.errmsg)
      }
    } catch (e) {
      this.showToast();
    }
    finally {
      infiniteScroll.complete();
    }
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }

  dismiss() {
    this.viewCtrl.dismiss(false);
  }
}
