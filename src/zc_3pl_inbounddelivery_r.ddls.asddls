@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: '3PL Inbound Deliveries (projection)'

@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: false

define root view entity ZC_3PL_InboundDelivery_R provider contract transactional_query
  as projection on ZR_3PL_InboundDelivery_R

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
