# frozen_string_literal: true

require 'cfn-nag/violation'
require 'cfn-nag/util/enforce_noecho_parameter.rb'
require_relative 'base'

class RDSInstanceMasterUserPasswordRule < BaseRule
  def rule_text
    'RDS instance master user password must be Ref to NoEcho Parameter. ' \
    'Default credentials are not recommended'
  end

  def rule_type
    Violation::FAILING_VIOLATION
  end

  def rule_id
    'F23'
  end

  # one word of warning... if somebody applies parameter values via JSON....
  # this will compare that....
  # probably shouldn't be doing that though if it's NoEcho there's a good reason
  # bother checking synthesized_value? that would be the indicator.....
  def audit_impl(cfn_model)
    rds_dbinstances = cfn_model.resources_by_type('AWS::RDS::DBInstance')
    violating_rdsinstances = rds_dbinstances.select do |instance|
      if instance.masterUserPassword.nil?
        false
      else
        !no_echo_parameter_without_default?(cfn_model,
                                            instance.masterUserPassword)
      end
    end

    violating_rdsinstances.map(&:logical_resource_id)
  end
end
