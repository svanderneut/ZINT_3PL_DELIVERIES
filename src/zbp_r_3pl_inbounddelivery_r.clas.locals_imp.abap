CLASS lhc_InboundDelivery DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR InboundDelivery RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ InboundDelivery RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK InboundDelivery.

    METHODS closeDelivery FOR MODIFY
      IMPORTING keys FOR ACTION InboundDelivery~closeDelivery RESULT result.

ENDCLASS.

CLASS lhc_InboundDelivery IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD read.
      SELECT * FROM ZI_3PL_InboundDelivery_R
      FOR ALL ENTRIES IN @keys
      WHERE InboundDelivery = @keys-%key-InboundDelivery
      INTO CORRESPONDING FIELDS OF TABLE @result.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD closeDelivery.
    DATA ls_business_data TYPE zscm_close_3pl_delivery_cpi=>tys_delivery.

    IF lines( keys ) > 1.

      DATA(ls_first_selected_key) = VALUE #( keys[ 1 ] OPTIONAL ).

      APPEND VALUE #( %tky = ls_first_selected_key-%tky ) TO failed-inbounddelivery.

      APPEND VALUE #( %tky = ls_first_selected_key-%tky
                      %msg = new_message( id       = 'Z_3PL'
                                          number   = '002'
                                          severity = if_abap_behv_message=>severity-information ) ) TO reported-inbounddelivery.
    ELSE.

      LOOP AT keys INTO DATA(ls_key).

        READ ENTITIES OF ZR_3PL_InboundDelivery_R IN LOCAL MODE
             ENTITY inbounddelivery
             FIELDS ( OverallGoodsMovementStatus )
             WITH VALUE #( ( %tky = ls_key-%tky ) )
             RESULT DATA(lt_inbounddelivery).

        DATA(ls_inbounddelivery) = VALUE #( lt_inbounddelivery[ 1 ] OPTIONAL ).

        " Check if delivery is already closed
        IF ls_inbounddelivery-OverallGoodsMovementStatus <> 'A'.

          APPEND VALUE #( %tky = ls_key-%tky ) TO failed-inbounddelivery.

          APPEND VALUE #( %tky = ls_key-%tky
                          %msg = new_message( id       = 'Z_3PL'
                                              number   = '001'
                                              severity = if_abap_behv_message=>severity-error ) ) TO reported-inbounddelivery.
          CONTINUE.
        ENDIF.

        TRY.

            " Create http client
            DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                       comm_scenario  = 'ZCS_CLOSE_3PL_DELIVERY_CPI'
                                       comm_system_id = 'ARCO'
                                       service_id     = 'ZOS_CLOSE_3PL_INBOUND_DELIVERY_REST' ).

            DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

            DATA(lo_client_proxy) = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
                is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                    proxy_model_id      = 'ZSCM_CLOSE_3PL_INB_DELIV_CPI'
                                                    proxy_model_version = '0001' )
                io_http_client           = lo_http_client
                iv_relative_service_root = '' ).

            ASSERT lo_http_client IS BOUND.

            " Prepare business data
            ls_business_data = VALUE #( delivery_number = ls_key-%tky-inboundDelivery ).

            " Navigate to the resource and create a request for the create operation
            DATA(lo_request) = lo_client_proxy->create_resource_for_entity_set( 'DELIVERIES' )->create_request_for_create( ).

            " Set the business data for the created entity
            lo_request->set_business_data( ls_business_data ).

            " Execute the request
            " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
            " TODO: variable is assigned but never used (ABAP cleaner)
            DATA(lo_response) = lo_request->execute( ).

          CATCH cx_http_dest_provider_error INTO DATA(lx_dest_provider_error).

            APPEND VALUE #( %tky = ls_key-%tky ) TO failed-inbounddelivery.

            APPEND VALUE #( %tky = ls_key-%tky
                            %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                          text     = lx_dest_provider_error->get_text( ) ) ) TO reported-inbounddelivery.

          CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
            " Handle Exception
            APPEND VALUE #( %tky = ls_key-%tky ) TO failed-inbounddelivery.

            APPEND VALUE #( %tky = ls_key-%tky
                            %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                          text     = lx_remote->get_text( ) ) ) TO reported-inbounddelivery.

          CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
            " Handle Exception
            APPEND VALUE #( %tky = ls_key-%tky ) TO failed-inbounddelivery.

            APPEND VALUE #( %tky = ls_key-%tky
                            %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                          text     = lx_gateway->get_text( ) ) ) TO reported-inbounddelivery.

          CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
            " Handle Exception
            APPEND VALUE #( %tky = ls_key-%tky ) TO failed-inbounddelivery.

            APPEND VALUE #( %tky = ls_key-%tky
                            %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                          text     = lx_web_http_client_error->get_text( ) ) ) TO reported-inbounddelivery.

        ENDTRY.

        DO 5 TIMES.

          READ ENTITIES OF zr_3pl_Inbounddelivery_r IN LOCAL MODE
           ENTITY inbounddelivery
           FIELDS ( OverallGoodsMovementStatus )
           WITH VALUE #( ( %tky = ls_key-%tky ) )
           RESULT DATA(inbounddelivery).

          ls_inbounddelivery = VALUE #( inbounddelivery[ 1 ] OPTIONAL ).

          IF ls_inbounddelivery-OverallGoodsMovementStatus = 'C'.
            EXIT.
          ENDIF.

          wait up to 1 seconds.

        ENDDO.

        IF ls_inbounddelivery-OverallGoodsMovementStatus <> 'C'.

          APPEND VALUE #( %tky = keys[ 1 ]-%tky ) TO failed-inbounddelivery.

          APPEND VALUE #( %tky = keys[ 1 ]-%tky
                          %msg = new_message( id       = 'Z_3PL'
                                              number   = '003'
                                              severity = if_abap_behv_message=>severity-warning ) ) TO reported-inbounddelivery.

        ENDIF.

      ENDLOOP.
    ENDIF.

    result = VALUE #( FOR key IN keys
                      ( %tky   = key-%tky
                        %param = CORRESPONDING #( key ) ) ).
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZR_3PL_INBOUNDDELIVERY_R DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZR_3PL_INBOUNDDELIVERY_R IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
