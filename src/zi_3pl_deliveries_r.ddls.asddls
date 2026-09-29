@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: '3PL Deliveries'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

@Search.searchable: true

define view entity ZI_3PL_Deliveries_R
  as select from I_OutboundDelivery

  association [0..1] to I_Customer              as _ShipToParty         on $projection.ShipToParty = _ShipToParty.Customer
  association [0..1] to I_GoodsMovementStatus   as _GoodsMovementStatus on $projection.OverallGoodsMovementStatus = _GoodsMovementStatus.GoodsMovementStatus
  association [0..1] to ZI_OutboundDeliveryType as _DeliveryTypeVH      on $projection.DeliveryDocumentType = _DeliveryTypeVH.DeliveryDocumentType

{
      @Consumption.semanticObject: 'OutboundDelivery'
      @Search.defaultSearchElement: true
  key OutboundDelivery,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_OutboundDeliveryType', element: 'DeliveryDocumentType' } } ]
      @ObjectModel.text.element: [ 'DeliveryTypeName' ]
      @UI.textArrangement: #TEXT_FIRST
      DeliveryDocumentType,
      
      @UI.hidden: true
      cast(_DeliveryTypeVH._Text[1: Language = $session.system_language].DeliveryDocumentTypeName as vtext) as DeliveryTypeName,
            
      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_DistrStatusByDectrlzdWrhs', element: 'DistrStatusByDecentralizedWrhs' } } ]
      @EndUserText.label: 'Decentalized warehouse status'
      @ObjectModel.text.element: [ 'DistrStatusByDectrlzdWrhsDesc' ]
      DistrStatusByDecentralizedWrhs,
      
      @UI.hidden: true
     _DistrStatusByDectrlzdWrhs._Text[1: Language = $session.system_language].DistrStatusByDectrlzdWrhsDesc as DistrStatusByDectrlzdWrhsDesc,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_ShippingPointStdVH', element: 'ShippingPoint' } } ]
      @ObjectModel.text.element: [ 'ShippingPointName' ]
      @UI.textArrangement: #TEXT_FIRST
      ShippingPoint,

      @UI.hidden: true
      _ShippingPoint._Text[1: Language = $session.system_language].ShippingPointName                        as ShippingPointName,


      @Consumption.semanticObject: 'Customer'
      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_Customer_VH', element: 'Customer' } } ]
      @ObjectModel.text.element: [ 'CustomerName' ]
      @UI.textArrangement: #TEXT_FIRST
      ShipToParty,

      @UI.hidden: true
      _ShipToParty.CustomerFullName                                                                         as CustomerName,

      @EndUserText.label: 'Planned Goods Movement Date'
      PlannedGoodsIssueDate,


      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_GoodsMovementStatus', element: 'GoodsMovementStatus' } } ]
      @EndUserText.label: 'GI Status'
      @ObjectModel.text.element: [ 'OverallGoodsMovementStatusName' ]
      OverallGoodsMovementStatus,

      @UI.hidden: true
      _GoodsMovementStatus._Text[1: Language = $session.system_language].GoodsMovementStatusDesc            as OverallGoodsMovementStatusName,

      @UI.hidden
      cast(
        case OverallGoodsMovementStatus
         when '' then 0
         when 'A' then 1
         when 'B' then 2
         when 'C' then 3
         else 0
        end as abap.int1
       )                                                                                                    as GoodsMovementStatusCriticality,


      /* Associations */
      _DeliveryDocumentType,
      _Item,
      _OverallGoodsMovementStatus,
      _Partner,
      _ShippingPoint,
      _ShipToParty,
      _DistrStatusByDectrlzdWrhs
}
