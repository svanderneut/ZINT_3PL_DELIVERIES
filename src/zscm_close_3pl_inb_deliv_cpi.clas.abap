"! <p class="shorttext synchronized">Consumption model for client proxy - generated</p>
"! This class has been generated based on the metadata with namespace
"! <em>CPI.DeliveryService</em>
CLASS zscm_close_3pl_inb_deliv_cpi DEFINITION
  PUBLIC
  INHERITING FROM /iwbep/cl_v4_abs_pm_model_prov
  CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES:
      "! <p class="shorttext synchronized">Delivery</p>
      BEGIN OF tys_delivery,
        "! <em>Key property</em> DeliveryNumber
        delivery_number TYPE string,
      END OF tys_delivery,
      "! <p class="shorttext synchronized">List of Delivery</p>
      tyt_delivery TYPE STANDARD TABLE OF tys_delivery WITH DEFAULT KEY.


    CONSTANTS:
      "! <p class="shorttext synchronized">Internal Names of the entity sets</p>
      BEGIN OF gcs_entity_set,
        "! Deliveries
        "! <br/> Collection of type 'Delivery'
        deliveries TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'DELIVERIES',
      END OF gcs_entity_set .

    CONSTANTS:
      "! <p class="shorttext synchronized">Internal names for entity types</p>
      BEGIN OF gcs_entity_type,
        "! <p class="shorttext synchronized">Internal names for Delivery</p>
        "! See also structure type {@link ..tys_delivery}
        BEGIN OF delivery,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! Dummy field - Structure must not be empty
            dummy TYPE int1 VALUE 0,
          END OF navigation,
        END OF delivery,
      END OF gcs_entity_type.


    METHODS /iwbep/if_v4_mp_basic_pm~define REDEFINITION.


  PRIVATE SECTION.

    "! <p class="shorttext synchronized">Model</p>
    DATA mo_model TYPE REF TO /iwbep/if_v4_pm_model.


    "! <p class="shorttext synchronized">Define Delivery</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_delivery RAISING /iwbep/cx_gateway.

ENDCLASS.



CLASS ZSCM_CLOSE_3PL_INB_DELIV_CPI IMPLEMENTATION.


  METHOD /iwbep/if_v4_mp_basic_pm~define.

    mo_model = io_model.
    mo_model->set_schema_namespace( 'CPI.DeliveryService' ) ##NO_TEXT.

    def_delivery( ).

  ENDMETHOD.


  METHOD def_delivery.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'DELIVERY'
                                    is_structure              = VALUE tys_delivery( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'Delivery' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'DELIVERIES' ).
    lo_entity_set->set_edm_name( 'Deliveries' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'DELIVERY_NUMBER' ).
    lo_primitive_property->set_edm_name( 'DeliveryNumber' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_is_key( ).

  ENDMETHOD.
ENDCLASS.
