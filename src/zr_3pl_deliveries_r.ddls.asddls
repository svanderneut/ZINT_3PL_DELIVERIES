@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: '3PL Deliveries (root)'

@Metadata.ignorePropagatedAnnotations: false

define root view entity ZR_3PL_Deliveries_R
  as select from ZI_3PL_Deliveries_R

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
