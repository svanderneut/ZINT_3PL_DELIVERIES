@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: '3PL Inbound Deliveries (root)'

@Metadata.ignorePropagatedAnnotations: false

define root view entity ZR_3PL_InboundDelivery_R
  as select from ZI_3PL_InboundDelivery_R

{
  key InboundDelivery,

      DeliveryDocumentType,
      DeliveryTypeName,
      Supplier,
      SupplierName,
      DeliveryDate,
      ShippingPoint,
      ShippingPointName,
      DistrStatusByDecentralizedWrhs,
      DistrStatusByDectrlzdWrhsDesc,
      OverallGoodsMovementStatus,
      OverallGoodsMovementStatusName,
      GoodsMovementStatusCriticality,

      /* Associations */
      _DeliveryDocumentType,
      _DistrStatusByDectrlzdWrhs,
      _Item,
      _OverallGoodsMovementStatus,
      _Partner,
      _ShippingPoint
}
