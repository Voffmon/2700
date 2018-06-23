class TransactionsController < ApplicationController

  # Filters
  before_action :authenticate_user!
  before_action :authenticate_owner!, :only => [:edit, :update, :destroy]
  before_action :authenticate_venture_owner!, :only => [:index, :create, :get_positions_for_year]

  # Show the transaction page for a certain venture
  def index
    @venture = Venture.find(params[:venture_id])
    @transactions = @venture.transactions.order("date DESC")
    setups = @venture.setups
    @years = setups.order("year DESC").pluck(:year)
    @unlocked_years = setups.where(is_locked: false).pluck(:year)
  end

  # Creates a new transaction and freezes the setup for that year
  def create

    # Generate date from year, month and day
    date = DateTime.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)

    # Create transaction
    transaction = Transaction.create!(transaction_params.merge(venture_id: params[:venture_id], date: date))

    # Freeze setup
    Setup.where(venture_id: params[:venture_id], year: params[:year]).first.lock!

    render json: {
      :html => render_to_string(
        :partial => "transaction",
        :layout  => false,
        :locals  => {:transaction => transaction})
    }
  end

  # Renders edit page
  def edit
    @transaction = Transaction.find(params[:id])
    @venture = @transaction.venture
    setups = @venture.setups
    @years = setups.order("year DESC").pluck(:year)
    @unlocked_years = setups.where(is_locked: false).pluck(:year)
    @positions = @transaction.position.category.setup.positions
  end

  # Updates a transaction
  def update

    # Generate date from year, month and day
    date = DateTime.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)

    if transaction = Transaction.update(params[:id], transaction_params.merge(date: date))
      redirect_to transaction_path(transaction.venture.id), notice: "Transaction was successfully updated."
    else
      render :action => 'edit'
    end
  end

  # Destroy a transaction
  def destroy
    Transaction.find(params[:id]).destroy
  end

  # Returns the number of days a month with given year has
  def get_number_of_days
    render json: {
      :days => Time.days_in_month(params[:month].to_i, params[:year].to_i)
    }
  end

  # Returns the positions for year
  def get_positions_for_year
    positions = Setup.where(venture_id: params[:venture_id], year: params[:year]).first.positions
    render json: {
      :positions => positions.map{ |p| [p.name, p.id] }
    }
  end

  private

    # Only the owner of the transaction is allowed to perform certain actions
    def authenticate_owner!
      render "errors/404" unless Transaction.find(params[:id]).venture.user_id == current_user.id
    end

    # Only the owner of the venture is allowed to perform certain actions
    def authenticate_venture_owner!
      render "errors/404" unless Venture.find(params[:venture_id]).user_id == current_user.id
    end

    # Permit parameters
    def transaction_params
      params.require(:transaction).permit(:position_id, :title, :amount, :vat, :note)
    end
end
