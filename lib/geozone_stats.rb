class GeozoneStats
  attr_reader :geozone, :participants

  def initialize(geozone, participants)
    @geozone = geozone
    @participants = participants
  end

  def geozone_participants
    if geozone.district?
      participants.where(geozone: geozone)
    else
      participants.joins(:geozone).where(geozones: {subprefecture_id: geozone.id})
    end
  end

  def name
    geozone.name
  end

  def sub
    geozone.subprefecture.name
  end

  def count
    geozone_participants.count
  end

  def percentage
    PercentageCalculator.calculate(count, participants.count)
  end
end
