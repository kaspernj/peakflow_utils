class PeakFlowUtils::RspecHelper
  def initialize(args)
    @groups = args.fetch(:groups)
    @group_number = args.fetch(:group_number)
  end

  def group_files
    return @group_files if @group_files

    # Sort them so that they are sorted by file path in three groups so each group have an equal amount of controller specs, features specs and so on
    group_orders = []
    @groups.times do
      group_orders << []
    end

    group_index = 0
    files.sort.each do |file|
      group_orders[group_index] << file
      group_index += 1
      group_index = 0 if group_index >= group_orders.length
    end

    @group_files = group_orders[@group_number - 1]
  end

  def total_tests
    files unless @total_tests
    @total_tests
  end

private

  def dry_result
    @dry_result ||= JSON.parse(`bundle exec rspec --dry-run --format json`)
  end

  def files
    return @files if @files

    @total_tests = 0

    @files = []
    dry_result.fetch("examples").each do |example|
      file_path = example.fetch("file_path")
      file_path = file_path[2, file_path.length]

      @files << file_path unless @files.include?(file_path)
      @total_tests += 1
    end

    @files
  end
end
