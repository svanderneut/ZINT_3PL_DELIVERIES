@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: '3PL Deliveries (projection)'

@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: false

@Search.searchable: true

define root view entity ZC_3PL_Deliveries_R provider contract transactional_query
  as projection on ZR_3PL_Deliveries_R

{
  key OutboundDelivery,

      DeliveryDocumentType,
      DeliveryTypeName,
      DistrStatusByDecentralizedWrhs,
      DistrStatusByDectrlzdWrhsDesc,      
      ShippingPoint,
      ShippingPointName,
      ShipToParty,
      CustomerName,
      PlannedGoodsIssueDate,
      OverallGoodsMovementStatus,
      OverallGoodsMovementStatusName,
      GoodsMovementStatusCriticality,

      /* Associations */
      _DeliveryDocumentType,
      _DistrStatusByDectrlzdWrhs,
      _Item,
      _OverallGoodsMovementStatus,
      _Partner,
      _ShippingPoint,
      _ShipToParty
}
