module ShiftsHelper
  def shift_vote_collection_dates(booth, polls)
    return [] if polls.blank?
    date_options(
      dates_interval(polls), Poll::Shift.tasks[:vote_collection], booth
    )
  end

  def shift_recount_scrutiny_dates(booth, polls)
    return [] if polls.blank?

    dates = polls.map(&:ends_at).map(&:to_date).sort.reduce([]) do |total, date|
      initial_date = date < Date.current ? Date.current : date
      total << (initial_date..date + Poll::RECOUNT_DURATION).to_a
    end
    date_options(dates.flatten.uniq, Poll::Shift.tasks[:recount_scrutiny], booth)
  end

  def date_options(dates, task_id, booth)
    valid_dates(dates, task_id, booth).map { |date| [l(date, format: :long), l(date)] }
  end

  def valid_dates(dates, task_id, booth)
    dates.reject { |date| officer_shifts(task_id, booth).include?(date) }
  end

  def officer_select_options(officers)
    officers.map { |officer| [officer.name, officer.id] }
  end

  def dates_interval(polls)
    polls.reduce([]) do |dates, poll|
      dates.push(*[*(shift_starts_at(poll)..poll.ends_at.to_date)])
    end.uniq.sort
  end

  def shift_starts_at(poll)
    start_date = poll.starts_at.to_date
    start_date < Date.current ? Date.current : start_date
  end

  private

    def officer_shifts(task_id, booth)
      @officer.shifts.where(task: task_id, booth: booth).map(&:date)
    end
end
