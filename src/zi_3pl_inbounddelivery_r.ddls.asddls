@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: '3PL InboundDeliveries'

@Metadata.ignorePropagatedAnnotations: true

define view entity ZI_3PL_InboundDelivery_R
  as select from I_InboundDelivery

{
      @Consumption.semanticObject: 'InboundDelivery'
  key InboundDelivery,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_InboundDeliveryType', element: 'DeliveryDocumentType' } } ]
      @ObjectModel.text.element: [ 'DeliveryTypeName' ]
      @UI.textArrangement: #TEXT_FIRST
      DeliveryDocumentType,

      @UI.hidden: true
      _DeliveryDocumentType._Text[1: Language = $session.system_language].DeliveryDocumentTypeName             as DeliveryTypeName,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_Supplier_VH', element: 'Supplier' } } ]
      @ObjectModel.text.element: [ 'SupplierName' ]
      Supplier,

      @UI.hidden: true
      _Supplier.SupplierName                                                                                   as SupplierName,

      DeliveryDate,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_ShippingPointStdVH', element: 'ShippingPoint' } } ]
      @ObjectModel.text.element: [ 'ShippingPointName' ]
      @UI.textArrangement: #TEXT_FIRST
      ShippingPoint,

      @UI.hidden: true
      _ShippingPoint._Text[1: Language = $session.system_language].ShippingPointName                           as ShippingPointName,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_DistrStatusByDectrlzdWrhs',
                                                      element: 'DistrStatusByDecentralizedWrhs' } } ]
      @EndUserText.label: 'Decentalized warehouse status'
      @ObjectModel.text.element: [ 'DistrStatusByDectrlzdWrhsDesc' ]
      DistrStatusByDecentralizedWrhs,

      @UI.hidden: true
      _DistrStatusByDectrlzdWrhs._Text[1: Language = $session.system_language].DistrStatusByDectrlzdWrhsDesc   as DistrStatusByDectrlzdWrhsDesc,


      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_GoodsMovementStatus', element: 'GoodsMovementStatus' } } ]
      @EndUserText.label: 'GI Status'
      @ObjectModel.text.element: [ 'OverallGoodsMovementStatusName' ]
      OverallGoodsMovementStatus,

      @UI.hidden: true
      _OverallGoodsMovementStatus._Text[1: Language = $session.system_language].OverallGoodsMovementStatusDesc as OverallGoodsMovementStatusName,

      @UI.hidden
      cast(
        case OverallGoodsMovementStatus
         when '' then 0
         when 'A' then 1
         when 'B' then 2
         when 'C' then 3
         else 0
        end as abap.int1
       )                                                                                                       as GoodsMovementStatusCriticality,

      /* Associations */
      _DeliveryDocumentType,
      _Item,
      _OverallGoodsMovementStatus,
      _Partner,
      _ShippingPoint,
      _DistrStatusByDectrlzdWrhs
}
