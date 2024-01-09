require 'xiv_data'

namespace :triad do
  namespace :rules do
    desc 'Create the rules'
    task create: :environment do
      puts 'Creating rules'
      count = Rule.count

      rules = %w(en de fr ja).map do |locale|
        XIVData.sheet('TripleTriadRule', locale: locale).flat_map do |rule|
          rule.values_at('Name', 'Description')
        end
      end

      rules.transpose.each_slice(2).each_with_index do |rule, i|
        rule.flatten!
        Rule.find_or_create_by!(id: i + 1, name_en: rule[0], name_de: rule[1], name_fr: rule[2], name_ja: rule[3],
                                description_en: rule[4], description_de: rule[5],
                                description_fr: rule[6], description_ja: rule[7])
      end

      puts "Created #{Rule.count - count} new rules"
    end
  end
end
