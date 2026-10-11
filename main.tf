resource "oci_data_safe_subsetting_policy" "data_safe_subsetting_policies" {
  for_each = var.data_safe_subsetting_policies

  compartment_id                 = each.value.compartment_id
  check_type                     = each.value.check_type
  defined_tags                   = each.value.defined_tags
  description                    = each.value.description
  display_name                   = each.value.display_name
  freeform_tags                  = each.value.freeform_tags
  generate_health_report_trigger = each.value.generate_health_report_trigger
  is_redo_logging_enabled        = each.value.is_redo_logging_enabled
  is_refresh_stats_enabled       = each.value.is_refresh_stats_enabled
  masking_policy_id              = each.value.masking_policy_id
  parallel_degree                = each.value.parallel_degree
  post_subsetting_script         = each.value.post_subsetting_script
  pre_subsetting_script          = each.value.pre_subsetting_script
  recompile                      = each.value.recompile
  tablespace                     = each.value.tablespace
  target_id                      = each.value.target_id
  unrelated_tables_action        = each.value.unrelated_tables_action

  schema_source {
    schema_source           = each.value.schema_source.schema_source
    schemas_for_subsetting  = each.value.schema_source.schemas_for_subsetting
    sensitive_data_model_id = each.value.schema_source.sensitive_data_model_id
    target_id               = each.value.schema_source.target_id
  }

  dynamic "target_credentials" {
    for_each = each.value.target_credentials != null ? [each.value.target_credentials] : []
    content {
      password  = target_credentials.value.password
      user_name = target_credentials.value.user_name
    }
  }

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      update = timeouts.value.update
    }
  }
}

