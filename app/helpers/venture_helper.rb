module VentureHelper

  # Build nested result hash instead of making hundreds of DB requests
  def generate_hash(mode, dimension, categories, positions, plan_months, transactions)

    categories = categories.select{|c| c.dimension == dimension}
    positions = positions.select{|p| categories.map(&:id).include?(p.category_id)}
    plan_months = plan_months.select{|m| positions.map(&:id).include?(m.position_id)}

    result = {}
    categories.each do |category|
      result[category.id] = {name: category.name, positions: {}}
      positions.select{|p| p.category_id == category.id}.each do |position|
        col = get_result_column(position)
        result[category.id][:positions][position.id] = {name: position.name, plan_months: {}}
        plan_months.select{|p| p.position_id == position.id}.each do |plan_month|
          if mode == "plan"
            result[category.id][:positions][position.id][:plan_months][plan_month.month] = (plan_month[col] ||= 0).round
          elsif mode == "performance"
            result[category.id][:positions][position.id][:plan_months][plan_month.month] = transactions.select{|p| p.position_id == position.id && p.date.month == plan_month.month}.map(&:amount).sum
          elsif mode == "compare_to_plan"
            result[category.id][:positions][position.id][:plan_months][plan_month.month] = ((plan_month[col] ||= 0) - transactions.select{|p| p.position_id == position.id && p.date.month == plan_month.month}.map(&:amount).sum).round
          elsif mode == "forecast"
            result[category.id][:positions][position.id][:plan_months][plan_month.month] = (plan_month[col.to_s + "_forecast"] ||= 0).round
          end
        end
      end
    end
    result
  end

  # Get overall sums from all position
  def get_sums_for_hash(hash)
    result = Array.new(12,0)
    hash.each do |category_id, category|
      category[:positions].each do |position_id, position|
        position[:plan_months].each do |plan_month, value|
          result[plan_month-1] += value
        end
      end
    end
    result
  end
end
