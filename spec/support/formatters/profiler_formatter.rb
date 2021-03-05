# encoding: utf-8
require 'rspec/core/formatters/base_text_formatter'

class ProfilerFormatter < RSpec::Core::Formatters::BaseTextFormatter
  def example_passed(example)
    super(example)
    output.print success_color('.')
  end

  def example_pending(example)
    super(example)
    output.print pending_color('*')
  end

  def example_failed(example)
    super(example)
    output.print failure_color('F')
  end

  def dump_profile
    output_results(folders_times)
  end

  private
  def example_folder(example)
    example.location[/\.\/spec\/([\w\s]+)[\/\w]+\.rb:\d+/, 1]
  end

  def formatted_time(time)
    minutes = (time / 60.0).to_i
    seconds = (time % 60).to_i

    "#{minutes} min #{seconds} sec"
  end

  def folders_times
    examples.inject({}) do |results, example|
      folder = example_folder(example)
      results[folder] ||= 0
      results[folder] += example.execution_result[:run_time]
      results
    end
  end

  def output_results(results)
    results.each_pair do |folder, time|
      puts "#{folder}: #{formatted_time(time)}"
    end
  end
end
