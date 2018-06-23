module PlanHelper

  # Since for every position configuration a different kind of settings exists,
  # we invented some kind of "settings engine" which create all the setting fields.
  # The view will then render all the necessary setting fields.
  # If no :type is specified it defaults to a text input.
  # If no :format is specified it defaults to decimal.
  def settings_for_position(position)

    # Contains the final configuration of settings
    config = {}

    # Dimension of the position
    dimension = position.category.dimension

    # If dimension is sales
    if dimension == "sales"

      # Sales method Quantity times price
      if position.sales_method == "quantity_times_price"
        config = {
          :price => {:caption => "Sales price (€)", :name => :field1, :required => true},
          :direct_costs => {:caption => "Direct costs (€)", :name => :field2},
          :net_margin => {:caption => "Net margin (%)", :name => :field3, :format => :integer, :default => 0},
          :sales_growth => {:caption => "Sales quantity growth (%)", :name => :field4, :format => :integer, :default => 0}
        }

        # Special cases
        if position.costs_method == "no_direct_costs" || position.costs_method == "absolute_amounts"
          config.delete(:direct_costs)
          config.delete(:net_margin)
          config.delete(:direct_costs_growth)
        end

      # Sales method Absolute amounts
      elsif position.sales_method == "absolute_amounts"
        config = {
          :sales_growth => {:caption => "Sales quantity growth (%)", :name => :field1, :format => :integer, :default => 0}
        }
      end

    # If dimension is direct costs
    elsif dimension == "costs_of_sales"
      config = {
        :recurring_costs => {:caption => "Recurring costs (€)", :name => :field1, :type => :select, :options => {1 => "Every month", 2 => "Every second month", 3 => "Every third moth", 4 => "Every fourth month", 6 => "Every sixths month", 0 => "Not recurring"}}
      }

    # If dimension is costs
    elsif dimension == "costs"
      config = {
        :recurring_costs => {:caption => "Recurring costs (€)", :name => :field1, :type => :select, :options => {1 => "Every month", 2 => "Every second month", 3 => "Every third moth", 4 => "Every fourth month", 6 => "Every sixths month", 0 => "Not recurring"}}
      }

    # If dimension is investments
    elsif dimension == "investments"
      # No settings for investments

    # If dimension is funding
    elsif dimension == "funding"
      config = {
        :recurring_funding => {:caption => "Repayment cycle", :name => :field1, :type => :select, :options => {1 => "Monthly", 3 => "Quarterly", 12 => "Yearly", 0 => "Not recurring"}}
      }

    # If dimension is taxes
    elsif dimension == "taxes"
      # No settings for taxes
    end

    # Return config
    config
  end


  # Since for every position configuration a different kind of table exists,
  # we invented some kind of "table engine", which create the columns.
  # The view will then render the columns with all necessary properties.
  # If a column has a name it is considered as editable else it is considered as readonly.
  def table_for_position(position)

    # Contains the final configuration of columns
    config = {}

    # Dimension of the position
    dimension = position.category.dimension

    # If dimension is sales
    if dimension == "sales"

      # Sales method Quantity times price
      if position.sales_method == "quantity_times_price"
        config = {
          :quantity => {:caption => "Sales Quantity", :name => :col1, :format => :integer, :autofill => true},
          :turnover => {:caption => "Turnover (€)", :name => :col2, :format => :decimal, :readonly => true},
          :direct_costs => {:caption => "Direct Costs (€)", :name => :col3, :format => :decimal, :readonly => true, :autofill => true},
          :marginal_return => {:caption => "Marginal Return (€)", :name => :col4, :format => :decimal, :readonly => true}
        }

        # Special cases
        if position.costs_method == "no_direct_costs"
          config.delete(:direct_costs)
          config.delete(:marginal_return)
        elsif position.costs_method == "absolute_amounts"
          config[:direct_costs].delete(:readonly)
        end

      # Sales method Absolute amounts
      elsif position.sales_method == "absolute_amounts"
        config = {
          :quantity => {:caption => "Sales Volume (€)", :name => :col1, :format => :decimal, :autofill => true},
          :direct_costs => {:caption => "Direct Costs (€)", :name => :col2, :format => :decimal, :autofill => true},
          :marginal_return => {:caption => "Marginal Return (€)", :name => :col3, :format => :decimal, :readonly => true}
        }

        # Special cases
        if position.costs_method == "no_direct_costs"
          config.delete(:direct_costs)
          config.delete(:marginal_return)
        end
      end

    # If dimension is direct costs
    elsif dimension == "costs_of_sales"
      config = {
        :direct_costs => {:caption => "Direct Costs (€)", :name => :col1, :format => :decimal}
      }

    # If dimension is costs
    elsif dimension == "costs"
      config = {
        :costs => {:caption => "Costs (€)", :name => :col1, :format => :decimal}
      }

    # If dimension is investments
    elsif dimension == "investments"
      config = {
        :investments => {:caption => "Investments", :name => :col1, :format => :decimal}
      }

    # If dimension is funding
    elsif dimension == "funding"
      config = {
        :funding => {:caption => "Funding (€)", :name => :col1, :format => :decimal},
        :repayment => {:caption => "Repayment (€)", :name => :col2, :format => :decimal, :autofill => true},
        :saldo => {:caption => "Saldo (€)", :name => :col3, :format => :decimal, :readonly => true}
      }

      if position.has_to_be_repayed
        config.delete(:repayment)
      end

    # If dimension is taxes
    elsif dimension == "taxes"
      # No table for taxes
    end

    # Return config
    config
  end


  # Since for every position different kind of planning methods may exists.
  def methods_for_position(position)

    # Contains the final configuration of settings
    config = {}

    # Dimension of the position
    dimension = position.category.dimension

    # If dimension is sales
    if dimension == "sales"
      config = {
        :sales_methods => [
          {:value => "quantity_times_price", :headline => "Quantity times price", :description => "Etiam porta sem malesuada magna mollis euismod. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean eu leo quam." },
          {:value => "absolute_amounts", :headline => "Absolute amounts", :description => "Etiam porta sem malesuada magna mollis euismod. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean eu leo quam." }
        ],
        :costs_methods => [
          {:value => "no_direct_costs", :headline => "No direct costs", :description => "Etiam porta sem malesuada magna mollis euismod. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean eu leo quam." },
          {:value => "per_unit", :headline => "Per unit", :description => "Etiam porta sem malesuada magna mollis euismod. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean eu leo quam." },
          {:value => "absolute_amounts", :headline => "Absolute amounts", :description => "Etiam porta sem malesuada magna mollis euismod. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean eu leo quam." }
        ]
      }
    end

    # Return config
    config
  end

  # Returns the result column for a position.
  # This is used e.g. for generating the charts.
  def get_result_column(position)

    result = ""

    # Dimension of the position
    dimension = position.category.dimension

    # If dimension is sales
    if dimension == "sales"

      # Sales method Quantity times price
      if position.sales_method == "quantity_times_price"
        result = :col4
        result = :col2 if position.costs_method == "no_direct_costs"

      # Sales method Absolute amounts
      elsif position.sales_method == "absolute_amounts"
        result = :col3
        result = :col1 if position.costs_method == "no_direct_costs"
      end

    # If dimension is direct costs
    elsif dimension == "costs_of_sales"
      result = :col1

    # If dimension is costs
    elsif dimension == "costs"
      result = :col1

    # If dimension is investments
    elsif dimension == "investments"
      result = :col1

    # If dimension is funding
    elsif dimension == "funding"
      result = :col3

    # If dimension is taxes
    elsif dimension == "taxes"
      #
    end

    # Return result
    result
  end
end
