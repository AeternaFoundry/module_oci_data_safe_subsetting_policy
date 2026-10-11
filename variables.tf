variable "data_safe_subsetting_policies" {
  description = <<EOT
Map of data_safe_subsetting_policies, attributes below
Required:
    - compartment_id
    - schema_source (block):
        - schema_source (required)
        - schemas_for_subsetting (optional)
        - sensitive_data_model_id (optional)
        - target_id (optional)
Optional:
    - check_type
    - defined_tags
    - description
    - display_name
    - freeform_tags
    - generate_health_report_trigger
    - is_redo_logging_enabled
    - is_refresh_stats_enabled
    - masking_policy_id
    - parallel_degree
    - post_subsetting_script
    - pre_subsetting_script
    - recompile
    - tablespace
    - target_id
    - unrelated_tables_action
    - target_credentials (block):
        - password (required)
        - user_name (required)
    - timeouts (block):
        - create (optional)
        - delete (optional)
        - update (optional)
EOT

  type = map(object({
    compartment_id                 = string
    check_type                     = optional(string)
    defined_tags                   = optional(map(string))
    description                    = optional(string)
    display_name                   = optional(string)
    freeform_tags                  = optional(map(string))
    generate_health_report_trigger = optional(number)
    is_redo_logging_enabled        = optional(bool)
    is_refresh_stats_enabled       = optional(bool)
    masking_policy_id              = optional(string)
    parallel_degree                = optional(string)
    post_subsetting_script         = optional(string)
    pre_subsetting_script          = optional(string)
    recompile                      = optional(string)
    tablespace                     = optional(string)
    target_id                      = optional(string)
    unrelated_tables_action        = optional(string)
    schema_source = object({
      schema_source           = string
      schemas_for_subsetting  = optional(list(string))
      sensitive_data_model_id = optional(string)
      target_id               = optional(string)
    })
    target_credentials = optional(object({
      password  = string
      user_name = string
    }))
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      update = optional(string)
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.data_safe_subsetting_policies : (
        contains([for v in ["SENSITIVE_DATA_MODEL", "TARGET"] : lower(v)], lower(v.schema_source.schema_source))
      )
    ])
    error_message = "must be one of: \"SENSITIVE_DATA_MODEL\", \"TARGET\""
  }
  validation {
    condition = alltrue([
      for k, v in var.data_safe_subsetting_policies : (
        v.schema_source.schemas_for_subsetting == null || (alltrue([for x in v.schema_source.schemas_for_subsetting : length(x) >= 1 && length(x) <= 128]))
      )
    ])
    error_message = "must be between 1 and 128 characters"
  }
  validation {
    condition = alltrue([
      for k, v in var.data_safe_subsetting_policies : (
        v.schema_source.sensitive_data_model_id == null || (length(v.schema_source.sensitive_data_model_id) >= 1 && length(v.schema_source.sensitive_data_model_id) <= 255)
      )
    ])
    error_message = "must be between 1 and 255 characters"
  }
  validation {
    condition = alltrue([
      for k, v in var.data_safe_subsetting_policies : (
        v.schema_source.target_id == null || (length(v.schema_source.target_id) >= 1 && length(v.schema_source.target_id) <= 255)
      )
    ])
    error_message = "must be between 1 and 255 characters"
  }
  validation {
    condition = alltrue([
      for k, v in var.data_safe_subsetting_policies : (
        v.recompile == null || (contains([for v in ["SERIAL", "PARALLEL", "NONE"] : lower(v)], lower(v.recompile)))
      )
    ])
    error_message = "must be one of: \"SERIAL\", \"PARALLEL\", \"NONE\""
  }
  validation {
    condition = alltrue([
      for k, v in var.data_safe_subsetting_policies : (
        v.unrelated_tables_action == null || (contains([for v in ["TRUNCATE", "KEEP"] : lower(v)], lower(v.unrelated_tables_action)))
      )
    ])
    error_message = "must be one of: \"TRUNCATE\", \"KEEP\""
  }
  validation {
    condition = alltrue([
      for k, v in var.data_safe_subsetting_policies : (
        v.check_type == null || (contains(["ALL", "TABLESPACE_CHECK"], v.check_type))
      )
    ])
    error_message = "must be one of: \"ALL\", \"TABLESPACE_CHECK\""
  }
  validation {
    condition = alltrue([
      for k, v in var.data_safe_subsetting_policies : (
        v.tablespace == null || (length(v.tablespace) >= 1 && length(v.tablespace) <= 30)
      )
    ])
    error_message = "must be between 1 and 30 characters"
  }
  validation {
    condition = alltrue([
      for k, v in var.data_safe_subsetting_policies : (
        v.target_id == null || (length(v.target_id) >= 1 && length(v.target_id) <= 255)
      )
    ])
    error_message = "must be between 1 and 255 characters"
  }
  # Note: 1 additional provider-side validator is enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

