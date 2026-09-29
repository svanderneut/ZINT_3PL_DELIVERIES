@AccessControl.authorizationCheck: #NOT_REQUIRED

@Consumption.ranked: true

@EndUserText.label: 'Outbound Delivery Type Value Help'

@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.usageType: { dataClass: #MIXED, serviceQuality: #C, sizeCategory: #S }

@Search.searchable: true

@VDM.viewType: #CONSUMPTION

define view entity ZI_OutboundDeliveryType
  as select from I_DeliveryDocumentType as DocumentType

{
      @ObjectModel.text.association: '_Text'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
  key DeliveryDocumentType,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #LOW
      SDDocumentCategory,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #LOW
      @UI.hidden: true
      cast(DocumentType._Text[1: Language = $session.system_language].DeliveryDocumentTypeName as abap.char(30)) as DocumentTypeName,

      @UI.hidden
      _Text
}

where SDDocumentCategory = 'T'
   or SDDocumentCategory = 'J'
