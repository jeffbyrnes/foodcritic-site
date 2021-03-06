require "pathname"

require_relative "data_helper"
require_relative "markdown_helper"

module RuleHelper

  include DataHelper
  include MarkdownHelper

  def rules
    load_rules.map { |r| expand_rule_markdown(r) }
  end

  def rule_count
    rules.reject { |r| r["deprecated"] }.count
  end

  def tags
    rules.map { |r| r["tags"].nil? ? [] : r["tags"] }.flatten.sort.uniq
  end

  def rules_by_tag
    Hash[tags.map { |t| [t, rules.select { |r| r["tags"] && r["tags"].include?(t) }] }]
  end

  private

  def expand_rule_markdown(rule)
    rule["summary"] = md_to_html(rule["summary"]) if rule["summary"]
    rule["examples"] = Array(rule["examples"]).map do |example|
      example.tap do |example|
        example["text"] = md_to_html(example["text"]) if example["text"]
      end
    end
    rule
  end

  def load_rules
    site_data("rules")
  end

end
