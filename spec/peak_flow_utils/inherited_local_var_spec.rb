require "rails_helper"

describe PeakFlowUtils::InheritedLocalVar do
  it "cleans up parameters after with_parameters block exits" do
    PeakFlowUtils::Notifier.with_parameters(first_job: "data1") do
      expect(PeakFlowUtils::Notifier.current.current_parameters).to eq(first_job: "data1")
    end

    # After the block, parameters should be empty - no leakage
    expect(PeakFlowUtils::Notifier.current.current_parameters).to eq({})

    PeakFlowUtils::Notifier.with_parameters(second_job: "data2") do
      # Only second_job should be present, first_job must not leak
      expect(PeakFlowUtils::Notifier.current.current_parameters).to eq(second_job: "data2")
    end

    expect(PeakFlowUtils::Notifier.current.current_parameters).to eq({})
  end

  100.times do |count|
    it "clones vars in children threads #{count}" do
      params_inside_child_thread = nil
      params_inside_parent_thread = nil
      params_inside_second_child_thread = nil
      thread1 = nil

      PeakFlowUtils::Notifier.with_parameters(parameter_in_main_thread: "test1") do
        thread1 = Thread.new do
          sleep 0.01

          PeakFlowUtils::Notifier.with_parameters(parameter_in_child_thread: "test2") do
            params_inside_child_thread = PeakFlowUtils::Notifier.current.current_parameters
          end
        end

        thread2 = Thread.new do
          sleep 0.001

          PeakFlowUtils::Notifier.with_parameters(parameter_in_second_child_thread: "test3") do
            params_inside_second_child_thread = PeakFlowUtils::Notifier.current.current_parameters
          end
        end

        params_inside_parent_thread = PeakFlowUtils::Notifier.current.current_parameters
        thread2.join
      end

      thread1.join

      expect(params_inside_child_thread).to eq(parameter_in_main_thread: "test1", parameter_in_child_thread: "test2")
      expect(params_inside_second_child_thread).to eq(parameter_in_main_thread: "test1", parameter_in_second_child_thread: "test3")
      expect(params_inside_parent_thread).to eq(parameter_in_main_thread: "test1")
    end
  end
end
