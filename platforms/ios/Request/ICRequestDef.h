//
//  ICRequestDef.h
//  BetSize
//
//  Created by jimmy on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef IC_ICRequestDef_h
#define IC_ICRequestDef_h

#import "NSDictionary+NullObj.h"

#define SERVER_ADD @""

#ifdef BossTest
#define SERVER_IP @"http://139.196.143.200:8088"
#define FILE_IP @"http://139.196.143.200"
#else
#define SERVER_IP @"http://we-erp.com:8088"
#define FILE_IP @"http://54.223.144.173"
#endif

#define SHORT_CONNECTION_PORT   @"8090"
#define LONG_CONNECTION_PORT    8080
#define UploadFile_Port         @"8080"

#define FetchPicUrl @""

#define kCBLocationManagerSuccess       @"kCBLocationManagerSuccess"
/* HTTP */
#pragma mark - HTTP
#define kBSLoginResponse                    @"kBSLoginResponse"
#define kBSFetchPersonalInfoResponse        @"kBSFetchPersonalInfoResponse"
#define kBSUpdatePersonalInfoResponse       @"kBSUpdatePersonalInfoResponse"
#define kBSFetchUserResponse                @"kBSFetchUserResponse"
#define kBSFetchUsersResponse               @"kBSFetchUsersResponse"
#define kBSFetchUserDetailInfoResponse      @"kBSFetchUserDetailInfoResponse"

// BSOptionSelect
#pragma mark - BSOptionSelect
#define kBSPorjectInfoTypeSelected          @"kBSPorjectInfoTypeSelected"
#define kBSPorjectUomInfoTypeSelected       @"kBSPorjectUomInfoTypeSelected"
#define kBSCardOverdraftTypeSelected        @"kBSCardOverdraftTypeSelected"

// PadRequestControl
#pragma mark - PadRequestControl
#define kBSOrderRequestSuccess              @"kBSOrderRequestSuccess"
#define kBSOrderRequestFailed               @"kBSOrderRequestFailed"
#define kBSMemberRequestSuccess             @"kBSMemberRequestSuccess"
#define kBSMemberRequestFailed              @"kBSMemberRequestFailed"
#define kBSRestaurantRequestSuccess         @"kBSRestaurantRequestSuccess"
#define kBSRestaurantRequestFailed          @"kBSRestaurantRequestFailed"
#define kBSProjectRequestSuccess            @"kBSProjectRequestSuccess"
#define kBSProjectRequestFailed             @"kBSProjectRequestFailed"
#define kBSPadDataRequestSuccess            @"kBSPadDataRequestSuccess"
#define kBSPadDataRequestFailed             @"kBSPadDataRequestFailed"
#define kBSPadDataRequestFinishCount        @"kBSPadDataRequestFinishCount"
#define kBSCardItemCountChanged             @"kBSCardItemCountChanged"
#define kBSPadDidHandNumberChange           @"kBSPadDidHandNumberChange"
#define kBSPadDidFreeCombinationChange      @"kBSPadDidFreeCombinationChange"
#define kBSPadDidBlueToothKeyBoardChange    @"kBSPadDidBlueToothKeyBoardChange"
#define kBSPadCashierSuccess                @"kBSPadCashierSuccess"
#define kBSPadAllotPerformance              @"kBSPadAllotPerformance"
#define kBSCashMemberAgain                  @"kBSCashMemberAgain"
#define kBSPadGiveGiftCard                  @"kBSPadGiveGiftCard"
#define kBSPopToRootAllocPos                @"kBSPopToRootAllocPos"
#define kBSPopToRootGiveGiftCard            @"kBSPopToRootGiveGiftCard"

// PadOrderRequest
#pragma mark - PadOrderRequest
#define kBSFetchPadOrderResponse            @"kBSFetchPadOrderResponse"
#define kBSFetchPadOrderLineResponse        @"kBSFetchPadOrderLineResponse"

// ProjectRequest
#pragma mark - ProjectRequest
#define kBSBornCategoryResponse             @"kBSBornCategoryResponse"
#define kBSProjectCheckResponse             @"kBSProjectCheckResponse"
#define kBSProjectCategoryResponse          @"kBSProjectCategoryResponse"
#define kBSProjectUomCategoryResponse       @"kBSProjectUomCategoryResponse"
#define kBSProjectUomResponse               @"kBSProjectUomResponse"
#define kBSProjectConsumableResponse        @"kBSProjectConsumableResponse"
#define kBSProjectRelatedItemResponse       @"kBSProjectRelatedItemResponse"
#define kBSProjectAttributePriceResponse    @"kBSProjectAttributePriceResponse"
#define kBSProjectAttributeValueResponse    @"kBSProjectAttributeValueResponse"
#define kBSProjectAttributeResponse         @"kBSProjectAttributeResponse"
#define kBSProjectAttributeLineResponse     @"kBSProjectAttributeLineResponse"
#define kBSProjectTemplateResponse          @"kBSProjectTemplateResponse"
#define kBSProjectTemplateIDResponse        @"kBSProjectTemplateIDResponse"
#define kBSProjectItemResponse              @"kBSProjectItemResponse"
#define kBSProjectItemIDResponse            @"kBSProjectItemIDResponse"
#define kBSPosCategoryCreateResponse        @"kBSPosCategoryCreateResponse"
#define kBSAttributeCreateResponse          @"kBSAttributeCreateResponse"
#define kBSAttributeValueCreateResponse     @"kBSAttributeValueCreateResponse"
#define kBSAttributePriceCreateResponse     @"kBSAttributePriceCreateResponse"
#define kBSConsumableCreateResponse         @"kBSConsumableCreateResponse"
#define kBSUomCreateResponse                @"kBSUomCreateResponse"
#define kBSUomCategoryCreateResponse        @"kBSUomCategoryCreateResponse"
#define kBSProjectTemplateCreateResponse    @"kBSProjectTemplateCreateResponse"
#define kBSProjectItemCreateResponse        @"kBSProjectItemCreateResponse"
#define kBSProjectItemPriceResponse         @"kBSProjectItemPriceResponse"
#define kBSProductOnHandResponse            @"kBSProductOnHandResponse"

// Account
#pragma mark - Account
#define kPadAccountLogoutResponse           @"kPadAccountLogoutResponse"
#define kPadAccountChangeResponse           @"kPadAccountChangeResponse"

// PosConfig
#pragma mark - PosConfig
#define kBSFetchStartInfoResponse           @"kBSFetchStartInfoResponse"
#define kBSFetchStartPosResponse            @"kBSFetchStartPosResponse"
#define kBSFetchPosConfigResponse           @"kBSFetchPosConfigResponse"
#define kBSFetchPayModeResponse             @"kBSFetchPayModeResponse"
#define kBSFetchPosSessionResponse          @"kBSFetchPosSessionResponse"
#define kBSPosSessionOperateResponse        @"kBSPosSessionOperateResponse"
#define kBSFetchPayStatementResponse        @"kBSFetchPayStatementResponse"

// ProjectEdit
#pragma mark - ProjectEdit
#define kBSProjectPosCategoryEditFinish     @"kBSProjectPosCategoryEditFinish"
#define kBSParentPosCategoryEditFinish      @"kBSParentPosCategoryEditFinish"
#define kBSAttributeLinesEditFinish         @"kBSAttributeLinesEditFinish"
#define kBSAttributeLineEditFinish          @"kBSAttributeLineEditFinish"
#define kBSAttributeEditFinish              @"kBSAttributeEditFinish"
#define kBSAttributeValueEditFinish         @"kBSAttributeValueEditFinish"
#define kBSAttributePriceEditFinish         @"kBSAttributePriceEditFinish"
#define kBSProjectConsumableEditFinish      @"kBSProjectConsumableEditFinish"
#define kBSConsumablesEditFinish            @"kBSConsumablesEditFinish"
#define kBSProjectUomEditFinish             @"kBSProjectUomEditFinish"
#define kBSUomCategoryEditFinish            @"kBSUomCategoryEditFinish"
#define kBSProjectSubItemEditFinish         @"kBSProjectSubItemEditFinish"
#define kBSConsumableItemSelectFinish       @"kBSConsumableItemSelectFinish"
#define kBSSubItemSelectFinish              @"kBSSubItemSelectFinish"
#define kBSSameItemSelectFinish             @"kBSSameItemSelectFinish"
#define kBSCardItemSelectFinish             @"kBSCardItemSelectFinish"
#define kBSPointItemSelectFinish            @"kBSPointItemSelectFinish"
#define kBSPurchaseItemSelectFinish         @"kBSPurchaseItemSelectFinish"
#define kBSCardBuyItemSelectFinish          @"kBSCardBuyItemSelectFinish"
#define kBSProjectItemEditFinish            @"kBSProjectItemEditFinish"
#define kBSProjectTemplateEditFinish        @"kBSProjectTemplateEditFinish"


// MemberRequest
#pragma mark - MemberRequest

#define kBSUpdateMemberResponse             @"kBSUpdateMemberResponse"
#define kBSCreateMemberResponse             @"kBSCreatememberResponse"
#define kBSFetchSpecialMemberResponse       @"kBSFetchSpecialMemberResponse"
#define kBSFetchTotalPriceRequest           @"kBSFetchTotalPriceRequest"
#define kBSFetchPosStateResponse            @"kBSFetchPosStateResponse"
//#define kBSMemberRechargeResponse           @"kBSMemberRechargeResponse"
#define kBSDailyOperateMenuResponse         @"kBSDailyOperateMenuResponse"
#define kBSInprotCardResponse               @"kBSInprotCardResponse"
#define kBSImportMemberCardResponse         @"kBSImportMemberCardResponse"
#define kBSPopMemberDetailVCUpdate          @"kBSPopMemberDetailVCUpdate"
#define kBSFetchMemberCardProjectResponse   @"kBSFetchMemberCardProjectResponse"
#define kBSFetchMemberCardArrearsResponse   @"kBSFetchMemberCardArrearsResponse"
#define kBSFetchMemberCardResponse          @"kBSFetchMemberCardResponse"
#define kBSFetchCouponCardProductResponse   @"kBSFetchCouponCardProductResponse"
#define kBSFetchCouponCardResponse          @"kBSFetchCouponCardResponse"
#define kBSFetchProductPriceListResponse    @"kBSFetchProductPriceListResponse"
#define kBSFetchMemberResponse              @"kBSFetchMemberResponse"
#define kBSFetchMemberDetailResponse        @"kBSFetchMemberDetailResponse"
#define kBSFetchMemberCardDetailResponse    @"kBSFetchMemberCardDetailResponse"
#define kBSFetchMemberTezhengResponse       @"kBSFetchMemberTezhengResponse"
#define kBSFetchMemberSourceResponse        @"kBSFetchMemberSourceResponse"
#define kBSFetchPartnerResponse             @"kBSFetchPartnerResponse"
#define kBSFetchMemberQinyouResponse        @"kBSFetchMemberQinyouResponse"
#define kBSFetchMemberOperateResponse       @"kBSFetchMemberOperateResponse"
#define kBSFetchMemberCallRecordResponse    @"kBSFetchMemberCallRecordResponse"
#define kBSFetchMemberFollowResponse        @"kBSFetchMemberFollowResponse"
#define kBSFetchMemberFollowProductResponse @"kBSFetchMemberFollowProductResponse"
#define kBSFetchMemberFollowContentResponse @"kBSFetchMemberFollowContentResponse"
#define kBSUpdateMemberFollowResponse       @"kBSUpdateMemberFollowResponse"
#define kBSFetchFollowPeroidResponse        @"kBSFetchFollowPeroidResponse"
#define kBSCreateMemberFollowResponse       @"kBSCreateMemberFollowResponse"
#define kBSMemberQufaMessageResponse        @"kBSMemberQufaMessageResponse"
#define kBSMessageRecordResponse            @"kBSMessageRecordResponse"

// Member
#pragma mark - Member
#define kBSCardItemCreateResult             @"kBSCardItemCreateResult"
#define kBSCardAmountEditFinish             @"kBSCardAmountEditFinish"
#define kBSCardItemEditFinish               @"kBSCardItemEditFinish"
#define kBSOverdraftCreateResult            @"kBSOverdraftCreateResult"
#define kBSOverdraftEditFinish              @"kBSOverdraftEditFinish"
#define kBSMemberCreateResponse             @"kBSMemberCreateResponse"
#define kBSMemberCardOperateResponse        @"kBSMemberCardOperateResponse"
#define kBSDeleteOperateItemResponse        @"kBSDeleteOperateItemResponse"
#define kBSCancelOperateResponse            @"kBSCancelOperateResponse"
#define kBSMemberCardTurnStoreResponse      @"kBSMemberCardTurnStoreResponse"
#define kBSMemberCardRedeemResponse         @"kBSMemberCardRedeemResponse"
#define kBSCreateRequest                    @"kBSCreateRequest"
#define kBSWriteRequest                     @"kBSWriteRequest"
#define kBSFetchMetricRequest               @"kBSFetchMetricRequest"
#define kBSFetchStorageRequest              @"kBSFetchStorageRequest"
#define kBSFetchRespositoryRequest          @"kBSFetchRespositoryRequest"
#define kBSFetchProviderRequest             @"kBSFetchProviderRequest"
#define kBSFetchPermissionRequest           @"kBSFetchPermissionRequest"
#define kBSFetchMemberTitleResponse         @"kBSFetchMemberTitleResponse"
#define kBSFetchMemberCardConsumeResponse   @"kBSFetchMemberCardConsumeResponse"
#define kBSFetchMemberCardOperateResponse   @"kBSFetchMemberCardOperateResponse"
#define kBSFetchMemberCardAmountResponse    @"kBSFetchMemberCardAmountResponse"
#define kBSFetchMemberCardQiankuanResponse  @"kBSFetchMemberCardQiankuanResponse"
#define kBSFetchMemberCardPointResponse     @"kBSFetchMemberCardPointResponse"
#define kBSEditMemberCardResponse           @"kBSEditMemberCardResponse"
#define kBSFetchCommentResponse             @"kBSFetchCommentResponse"
#define kBSFetchCommentTypeResponse         @"kBSFetchCommentTypeResponse"
#define kBSFetchExtendResponse              @"kBSFetchExtendResponse"
#define kBSCreateExtendedResponse           @"kBSCreateExtendedResponse"
#define kBSFetchMemberChangeShopResponse    @"kBSFetchMemberChangeShopResponse"
#define kBSFilterMemberResponse             @"kBSFilterMemberResponse"
#define kBSFetchMessageTemplateResponse     @"kBSFetchMessageTemplateResponse"
#define kBSFetchFeedbackResponse            @"kBSFetchFeedbackResponse"
#define kBSMemberCashierSuccess             @"kBSMemberCashierSuccess"

#define kBSCreateAuthorizationResponse      @"kBSCreateAuthorizationResponse"

/* Cart */
#pragma mark - Cart
#define kBSFetchStoreListResponse           @"kBSFetchStoreListResponse"
#define kBSChangeStoreResponse              @"kBSChangeStoreResponse"

/* Staff */
#pragma mark -  Staff
#define kBSFetchStaffResponse               @"kBSFetchStaffResponse"
#define kBSFetchStaffJobResponse            @"kBSFetchStaffJobResponse"
#define kBSFetchStaffDepartmentResponse     @"kBSFetchStaffDepartmentResponse"
#define kBSStaffCreateResponse              @"kBSStaffCreateResponse"
#define kBSUpdateStaffInfoResponse          @"kBSUpdateStaffInfoResponse"
#define kBSShopCreateResponse               @"kBSShopCreateResponse"
#define kBSDepartmentCreateResponse         @"kBSDepartmentCreateResponse"
#define kBSJobCreateResponse                @"kBSJobCreateResponse"
#define kBSFetchSpecialStaffRequest         @"kBSFetchSpecialStaffRequest"
#define kBSFetchStaffPermission             @"kBSFetchStaffPermission"

/* Purchase */
#pragma mark - Purchase
#define kBSFetchOrderResponse               @"kBSFetchOrderResponse"
#define kBSFetchOrderLinesResponse          @"kBSFetchOrderLinesResponse"
#define kBSCreateProviderResponse           @"kBSCreateProviderResponse"
#define kBSCreatePurchaseOrderResponse      @"kBSCreatePurchaseOrderResponse"
#define kBSEditPurchaseOrderResponse        @"kBSEditPurchaseOrderResponse"
#define kBSCommitPurchaseOrderResponse      @"kBSCommitPurchaseOrderResponse"
#define kBSDeletePurchaseOrderResponse      @"kBSDeletePurchaseOrderResponse"
#define kBSCancelPurchaseOrderResponse      @"kBSCancelPurchaseOrderResponse"
#define kBSInputPurchaseOrderResponse       @"kBSInputPurchaseOrderResponse"
#define kBSTranslatePurchaseOrderResponse   @"kBSTranslatePurchaseOrderResponse"
#define kBSConfirmedPurchaseOrderResponse   @"kBSConfirmedPurchaseOrderResponse"
#define kBSMoveDoneReponse                  @"kBSMoveDoneReponse"
#define kBSFetchMoveOrderResponse           @"kBSFetchMoveOrderResponse"
#define kBSFetchMoveDetailResponse          @"kBSFetchMoveDetailResponse"
#define kBSFetchMoveProductResponse         @"kBSFetchMoveProductResponse"
#define kBSFetchPurchaseTaxResponse         @"kBSFetchPurchaseTaxResponse"

/* Stock */
#pragma mark - Stock
#define kBSFetchPanDianResponse             @"kBSFetchPanDianResponse"
#define kBSFetchPanDianItemResponse         @"kBSFetchPanDianItemResponse"
#define kBSAutoPanDianResponse              @"kBSAutoPanDianResponse"
#define kBSFetchSinglePanDianResponse       @"kBSFetchSinglePanDianResponse"
#define kBSCreatePanDianResponse            @"kBSCreatePanDianResponse"
#define kBSEditPanDianResponse              @"kBSEditPanDianResponse"
#define kBSConfirmPanDianResponse           @"kBSConfirmPanDianResponse"
#define kBSCancelConfirmPanDianResponse     @"kBSCancelConfirmPanDianResponse"

/* Home */
#pragma mark - Home
#define kFetchHomeAdvertisementResponse         @"kFetchHomeAdvertisementResponse"
#define kFetchHomeCountDataResponse             @"kFetchHomeCountDataResponse"
#define kFetchHomeTodayIncomeDetailResponse     @"kFetchHomeTodayIncomeDetailResponse"
#define kFetchHomePassengerFlowDetailResponse   @"kFetchHomePassengerFlowDetailResponse"
#define kFetchHomeMyTodayIncomeDetailResponse   @"kFetchHomeMyTodayIncomeDetailResponse"
#define kFetchCompanyUUIDResponse               @"kFetchCompanyUUIDResponse"
#define kFetchUnReadMessageResponse             @"kFetchUnReadMessageResponse"
#define kFetchRestaurantFloorResponse           @"kFetchRestaurantFloorResponse"
#define kFetchRestaurantFloorIDResponse         @"kFetchRestaurantFloorIDResponse"
#define kFetchRestaurantTableResponse           @"kFetchRestaurantTableResponse"
#define kFetchRestaurantTableIDResponse         @"kFetchRestaurantTableIDResponse"
#define kCreateRestaurantOperateResponse        @"kCreateRestaurantOperateResponse"
#define kCreateRestaurantFloorResponse          @"kCreateRestaurantFloorResponse"
#define kWriteRestaurantFloorResponse           @"kWriteRestaurantFloorResponse"
#define kDeleteRestaurantFloorResponse          @"kDeleteRestaurantFloorResponse"
#define kCreateRestaurantTableResponse          @"kCreateRestaurantTableResponse"
#define kWriteRestaurantTableResponse           @"kWriteRestaurantTableResponse"
#define kDeleteRestaurantTableResponse          @"kDeleteRestaurantTableResponse"
#define kBSFetchRestaurantTableUseResponse      @"kBSFetchRestaurantTableUseResponse"

/* Pad_PosCardOperate */
#pragma mark - Pad_PosCardOperate
#define kFetchPosCardOperateResponse        @"kFetchPosCardOperateResponse"
#define kFetchPosOperateProductResponse     @"kFetchPosOperateProductResponse"
#define kFetchPosPayInfoResponse            @"kFetchPosPayInfoResponse"
#define kFetchPosMonthIncomeResponse        @"kFetchPosMonthIncomeResponse"
#define kFetchPosConsumeProductResponse     @"kFetchPosConsumeProductResponse"
#define kFetchPosCommissionResponse         @"kFetchPosCommissionResponse"
#define kPosAssigncommissionResponse        @"kPosAssigncommissionResponse"
#define kPosCouponProductResponse           @"kPosCouponProductResponse"
#define kPosProductCategoryResponse         @"kPosProductCategoryResponse"
#define kFetchCommissionRuleResponse        @"kFetchCommissionRuleResponse"

/* Pad_Book */
#pragma mark - Pad_Book
#define kFetchBookResponse                  @"kFetchBookResponse"
#define kRefreshBookResponse                @"kRefreshBookResponse"
#define kBSCreateBookResponse               @"kBSCreateBookResponse"
#define kBSEditBookResponse                 @"kBSEditBookResponse"
#define kBSDeleteBookResponse               @"kBSDeleteBookResponse"

/* Pad_Give */
#pragma mark - Pad_Give
#define kBSFetchCardTemplateResponse        @"kBSFetchCardTemplateResponse"
#define kBSFetchCardTemplateProductResponse @"kBSFetchCardTemplateProductResponse"
#define kBSGiveRequestResponse              @"kBSGiveRequestResponse"
#define kBSGiveCardResponse                 @"kBSGiveCardResponse"
#define kBSGiveTicketResponse               @"kBSGiveTicketResponse"

#define kBSFetchWXCardTemplateResponse      @"kBSFetchWXCardTemplateResponse"
#define kBSGiveWXCardResponse               @"kBSGiveWXCardResponse"
#define kBSFetchGiveProjectResponse         @"kBSFetchGiveProjectResponse"

/* Common */
#pragma mark - Common

/* local */
#pragma mark - local
#define kBSUpdateDepartAndJob               @"kBSUpdateDepartAndJob"
#define kBSUpdateMemberInfo                 @"kBSUpdateMemberInfo"
#define kBSCommomSelectedDataChanged        @"kBSCommomSelectedDataChanged"

/* local Pad*/
#pragma mark - local Pad
#define kUpdateLocalPosOperateNotification  @"kUpdateLocalPosOperateNotification"
#define kUpdateH9NotifyNotification         @"kUpdateH9NotifyNotification"

#define kPadCreateMemberFinish              @"kPadCreateMemberFinish"
#define kPadEditMemberNotification          @"kPadEditMemberNotification"
#define kPadEditMemberFinish                @"kPadEditMemberFinish"
#define kPadSelectMemberFinish              @"kPadSelectMemberFinish"
#define kPadSelectMemberCardFinish          @"kPadSelectMemberCardFinish"
#define kPadSelectCouponCardFinish          @"kPadSelectCouponCardFinish"
#define kPadSelectMemberAndCardFinish       @"kPadSelectMemberAndCardFinish"

/* wevip */
#pragma mark - wevip
#define kFetchCardInfoFromWevipQRCodeResponse   @"kFetchCardInfoFromWevipQRCodeResponse"
#define kBSScanWeVIPCardCodeResult              @"kBSScanWeVIPCardCodeResult"
#define kPadMenuOrderBoardcast                  @"kPadMenuOrderBoardcast"

// Device
#pragma mark - Device
#define kBSPadPrinterUpdatedNotification        @"kBSPadPrinterUpdatedNotification"
#define kBSPadCodeScannerUpdatedNotification    @"kBSPadCodeScannerUpdatedNotification"
#define kBSPadPosMachineUpdatedNotification     @"kBSPadPosMachineUpdatedNotification"
#define kBSPadSetPosMachineAndPayAccount        @"kBSPadSetPosMachineAndPayAccount"

//weixin
#define kWeixinCardBindingResponse           @"kWeixinCardBindingResponse"
#define kFetchWXCouponCardQrUrlResponse      @"kFetchWXCouponCardQrUrlResponse"
#define kFetchWXCouponCardAddressUrlResponse @"kFetchWXCouponCardAddressUrlResponse"




#pragma mark - productProject(产品项目模块)
#define projectAddBtnClick  @"projectAddBtnClick"
#define projectSaveBtnHidden @"projectSaveBtnHidden"
#define myNotification  [NSNotificationCenter defaultCenter]
#define menuViewCellSelected @"menuViewCellSelected"
#define productSaveBtnClick @"productSaveBtnClick"
#define baseInfoEdit @"baseInfoEdit"
#define consumGoodsSeletedComplete @"consumGoodsSeletedComplete"
#define baseVCReceiveParentVCReceive @"baseVCParentProductVCReceive"
#define inHandNum @"inHandNum"
#define handNumVcChangeNum @"handNumVcChangeNum"
#define productCategoryJF @"productCategoryJF"
#define productCategoryCompele @"productCategoryCompele"
#define consumeGoodsSeletedArray @"consumeGoodsSeletedArray"
#define packageSeletedCompleted @"packageSeletedCompleted"
#define mainRightControllerAllBtnClick @"mainRightControllerAllBtnClick"
#define projectTitleFont [UIFont systemFontOfSize:16]
#define projectContentFont [UIFont systemFontOfSize:15]
#define projectSmallFont [UIFont systemFontOfSize:14]
#define projectMainPicturePriceFont [UIFont systemFontOfSize:12]
#define projectTextFieldColor [UIColor colorWithRed:177/255.0 green:177/255.0 blue:177/255.0 alpha:1]
#define specificationColor [UIColor colorWithRed:251/255.0 green:123/255.0 blue:120/255.0 alpha:1]
#define VCBackgrodColor [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1]
#define projectTitleBtnNormalColor [UIColor colorWithRed:132/255.0 green:205/255.0 blue:254/255.0 alpha:1.0] 


//医美
#define kBSFetchKeshiResponse                   @"kBSFetchKeshiResponse"
#define kEidtPosOperateResponse                 @"kEidtPosOperateResponse"
#define kBSFetchWorkFlowActivityResponse        @"kBSFetchWorkFlowActivityResponse"
#define kBSFetchYimeiOperateActivityResponse    @"kBSFetchYimeiOperateActivityResponse"
#define kEidtYimeiOperateActivityResponse       @"kEidtYimeiOperateActivityResponse"
#define kFetchYimeiMedicalProvisionResponse     @"kFetchYimeiMedicalProvisionResponse"

//POS机
#define kBSPosMachineReadCardResponse           @"kBSPosMachineReadCardResponse"

//支付
#define kBSAlipayTradeResponse                  @"kBSAlipayTradeResponse"
#define kBSAlipayRefundResponse                 @"kBSAlipayRefundResponse"

//推送
#define kRefreshPadHome                         @"kRefreshPadHome"
#define kRefreshHospitalMain                    @"kRefreshHospitalMain"
#define kGoH9Notify                             @"kGoH9Notify"

//打印机
#define kBSFetchPrinterStatusResponse           @"kBSFetchPrinterStatusResponse"
#define kBSPrintOpenCashBoxResponse             @"kBSPrintOpenCashBoxResponse"
#define kBSFetchPrinterScannerResponse          @"kBSFetchPrinterScannerResponse"
#define kBSPrinterSuccessResponse               @"kBSPrinterSuccessResponse"

#define kFetchWashHandResponse                  @"kFetchWashHandResponse"
#define kFetchWashHandDetailResponse            @"kFetchWashHandDetailResponse"
#define kEditWashHandResponse                   @"kEditWashHandResponse"

//医院
#define kBSFetchHCustomerResponse               @"kBSFetchHCustomerResponse"
#define kHCustomerCreateResponse                @"kHCustomerCreateResponse"
#define kFetchHZixunResponse                    @"kBSFetchHZixunResponse"
#define kFetchHJiaoHaoResponse                  @"kFetchHJiaoHaoResponse"
#define kHZixunCreateResponse                   @"kHZixunCreateResponse"
#define kHPatientResponse                       @"kHPatientResponse"
#define kFetchHMemberResponse                   @"kFetchHMemberResponse"
#define kHMemberVisitCreateResponse             @"kHMemberVisitCreateResponse"
#define kHPartnerCreateResponse                 @"kHPartnerCreateResponse"
#define kHBinglikaResponse                      @"kHBinglikaResponse"
#define kHHuizhenLinesResponse                  @"kHHuizhenLinesResponse"
#define kHHuizhenCreateResponse                 @"kHHuizhenCreateResponse"
#define kHShoushuResponse                       @"kHShoushuResponse"
#define kHShoushuLinesResponse                  @"kHShoushuLinesResponse"
#define kHShoushuCreateResponse                 @"kHShoushuCreateResponse"
#define kHShoushuLineEditResponse               @"kHShoushuLineEditResponse"
#define kHFetchWxShopQrCodeResponse             @"kHFetchWxShopQrCodeResponse"
#define kHJiaoHaoCancelResponse                 @"kHJiaoHaoCancelResponse"
//前台咨询
#define kFetchZixunBookResponse                 @"kFetchZixunBookResponse"
#define kFetchZixunRoomResponse                 @"kFetchZixunRoomResponse"
#define kEditZixunRoomResponse                  @"kEditZixunRoomResponse"
#define kQiantaiBookSignResponse                @"kQiantaiBookSignResponse"
#define kFetchZixunResponse                     @"kFetchZixunResponse"
#define kFetchQuestionResponse                  @"kFetchQuestionResponse"
#define kHZixunStartResponse                    @"kHZixunStartResponse"
#define kHZixunEndResponse                      @"kHZixunEndResponse"
#define kHZixunUpdateResponse                   @"kHZixunUpdateResponse"
#define kHZixunHouqigenjinResponse              @"kHZixunHouqigenjinResponse"
#define kAddZixunRoomResponse                   @"kAddZixunRoomResponse"
#define kHGetInkImgIdResponse                   @"kHGetInkImgIdResponse"

#endif
