require 'paypal-sdk-rest'
include PayPal::SDK::REST

class PagosController < ApplicationController
  before_action :set_pago, only: [:show, :edit, :update, :destroy]

  # GET /pagos
  # GET /pagos.json
  def index
    @pagos = Pago.all
  end

  # GET /pagos/1
  # GET /pagos/1.json
  def show
  end

  # GET /pagos/new
  def new
    @pago = Pago.new
  end

  # GET /pagos/1/edit
  def edit
  end

  # POST /pagos
  # POST /pagos.json
  def create
    @pago = Pago.new(pago_params)

    respond_to do |format|
      if @pago.save
        format.html { redirect_to @pago, notice: 'Pago was successfully created.' }
        format.json { render :show, status: :created, location: @pago }
      else
        format.html { render :new }
        format.json { render json: @pago.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pagos/1
  # PATCH/PUT /pagos/1.json
  def update
    respond_to do |format|
      if @pago.update(pago_params)
        format.html { redirect_to @pago, notice: 'Pago was successfully updated.' }
        format.json { render :show, status: :ok, location: @pago }
      else
        format.html { render :edit }
        format.json { render json: @pago.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pagos/1
  # DELETE /pagos/1.json
  def destroy
    @pago.destroy
    respond_to do |format|
      format.html { redirect_to pagos_url, notice: 'Pago was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pago
      @pago = Pago.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pago_params
      params.fetch(:pago, {})
    end
end

def pago_paypal
PayPal::SDK::REST.set_config(
  :mode => "sandbox", # "sandbox" or "live"
  :client_id => "EBWKjlELKMYqRNQ6sYvFo64FtaRLRR5BdHEESmha49TM",
  :client_secret => "EO422dn3gQLgDbuwqTjzrFgFtaRLRR5BdHEESmha49TM")

# Build Payment object
@payment = Payment.new({
  :intent => "sale",
  :payer => {
    :payment_method => "credit_card",
    :funding_instruments => [{
      :credit_card => {
        :type => "visa",
        :number => "4567516310777851",
        :expire_month => "11",
        :expire_year => "2018",
        :cvv2 => "874",
        :first_name => "Joe",
        :last_name => "Shopper",
        :billing_address => {
          :line1 => "52 N Main ST",
          :city => "Johnstown",
          :state => "OH",
          :postal_code => "43210",
          :country_code => "US" }}}]},
  :transactions => [{
    :item_list => {
      :items => [{
        :name => "item",
        :sku => "item",
        :price => "1",
        :currency => "USD",
        :quantity => 1 }]},
    :amount => {
      :total => "1.00",
      :currency => "USD" },
    :description => "This is the payment transaction description." }]})

# Create Payment and return the status(true or false)
if @payment.create
  @payment.id     # Payment Id
else
  @payment.error  # Error Hash
end
end