class Report
  attr_accessor :type, :data, :total, :prev30Days, :start_date, :end_date

  def initialize(type)
    @type = type
    @start_date ||= "2015-07-06 00:00:00" #birthday of shengmaodou
    @end_date ||= Time.zone.now.end_of_day
  end

  def self.find(type, opts=nil)
    opts ||= {}
    # Load the report
    report = Report.new(type)
    report.start_date = opts[:start_date] if opts[:start_date]
    report.end_date = opts[:end_date] if opts[:end_date]
    report_method = :"report_#{type}"

    if respond_to?(report_method)
      send(report_method, report)
    else
      return nil
    end

    report
  end

  def as_json(options=nil)
    {
     title: I18n.t("reports.#{type}.title"),
     xaxis: I18n.t("reports.#{type}.xaxis"),
     yaxis: I18n.t("reports.#{type}.yaxis"),
     data: data,
     total: total,
     start_date: start_date,
     end_date: end_date,
     prev30Days: self.prev30Days
    }
  end

  def self.report_tel_attributions(report)
    cal_report_about report, TelAttribution, :count_by_city
  end

  def self.report_signups(report)
    report_about report, User, :count_by_signup_date
  end

  def self.report_spots(report)
    report_about report, Spot, :count_by_post_date
  end

  def self.report_comments(report)
    report_about report, SpotComment, :count_by_post_date
  end

  def self.report_likes(report, query_column="created_at")
    report.total = Spot.where("#{query_column} >= ?", report.start_date).sum(:like)
  end

  def self.report_about(report, subject_class, report_method = :count_per_day)
    basic_report_about report, subject_class, report_method, report.start_date, report.end_date
    add_counts report, subject_class
  end

  def self.basic_report_about(report, subject_class, report_method, *args)
    report.data = []
    subject_class.send(report_method, *args).each do |date, count|
      report.data << { x: date.to_time.utc.to_i * 1000, y: count }
    end
  end

  def self.cal_report_about(report, subject_class, report_method, *args)
    report.data = []
    subject_class.send(report_method, *args).each do |name, count|
      report.data << { name: name, y: count }
    end
  end
  def self.add_counts(report, subject_class, query_column = 'created_at')
    report.total      = subject_class.where("#{query_column} >= ?", report.start_date).count
    #report.prev30Days = subject_class.where("#{query_column} >= ? and #{query_column} < ?", report.start_date - 30.days, report.start_date).count
  end
end
