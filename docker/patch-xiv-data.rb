#!/usr/bin/env ruby
# Patches xiv-data CSVs in-place to work around upstream data-quality issues
# that break the project's rake tasks (lib/tasks/*.rake). The rake tasks expect
# certain columns to be populated and don't handle nil gracefully — when an
# upstream commit has gaps, NOT NULL violations follow. This script fills the
# gaps with placeholders BEFORE rake runs, leaving the rake code untouched.
#
# Currently handles:
#   - CompanionTransient.csv: empty Description for minions present in
#     Companion.csv (minions.rake:106 -> Minion.create! NotNullViolation)
require 'csv'

XIV_DATA = '/app/vendor/xiv-data/exd'
LOCALES  = %w(en de fr ja tc)
PLACEHOLDER = '(description unavailable)'

def patch_companion_transient
  companion_path = File.join(XIV_DATA, 'en', 'Companion.csv')
  return unless File.exist?(companion_path)

  # Real minion IDs come from Companion where Order > 0
  minion_ids = CSV.read(companion_path, headers: true)
    .reject { |row| row['Order'] == '0' }
    .map { |row| row['#'] }
    .compact

  LOCALES.each do |locale|
    path = File.join(XIV_DATA, locale, 'CompanionTransient.csv')
    next unless File.exist?(path)

    rows = CSV.read(path, headers: true)
    patched_ids = []

    rows.each do |row|
      next unless minion_ids.include?(row['#'])
      next unless row['Description'].to_s.strip.empty?

      row['Description'] = PLACEHOLDER
      patched_ids << row['#']
    end

    next if patched_ids.empty?

    CSV.open(path, 'w') do |csv|
      csv << rows.headers
      rows.each { |row| csv << row }
    end
    puts "  #{locale}/CompanionTransient.csv: filled Description for ##{patched_ids.join(', #')}"
  end
end

puts "Patching xiv-data for known data-quality issues..."
patch_companion_transient
puts "Patch done."
