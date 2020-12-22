class Budget::Participants::Exporter
  require "csv"

  def initialize(participants)
    @participants = participants
  end

  def to_csv
    CSV.generate(headers: true) do |csv|
      csv << PARTICIPANT_COLUMNS.map { |column| participant_translation(column) }

      @participants.each do |user|
        csv << csv_row(user)
      end
    end
  end

  private

  PARTICIPANT_COLUMNS = %w(id gender ethnicity age city uf).freeze

  def csv_row(user)
    [
      user.id.to_s,
      gender_translation(user),
      ethnicity_translation(user),
      user.age,
      user.city,
      user.uf
    ]
  end

  def participant_translation(key)
    I18n.t(key, scope: 'stats.budgets.participants.spreadsheet')
  end

  def gender_translation(participant)
    if participant.gender.present?
      participant_translation("gender_options.#{participant.gender}")
    end
  end

  def ethnicity_translation(participant)
    if participant.ethnicity.present?
      participant_translation("ethnicity_options.#{participant.ethnicity}")
    end
  end
end
