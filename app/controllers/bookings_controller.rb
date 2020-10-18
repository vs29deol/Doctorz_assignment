class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy]

  # GET /bookings
  # GET /bookings.json
  def index
    @current_user = current_user
    if current_user.is_admin
      @bookings = Booking.all
    else
      @bookings = Booking.all.where(user_id: current_user.id)
    end
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
  end

  # GET /bookings/new
  def new
    @booking = Booking.new
    @shows = Show.all
    @seats_available_to_book = Show.all.pluck(:name).map{|obj| get_available_seats(obj)}
  end

  def get_available_seats show_name
    show_id = Show.find_by(name: show_name).id
    all_seats = Show.find(show_id).seat_ids
    bookings = Booking.where(show_id: show_id, created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
    if bookings.empty?
      Seat.find(all_seats)
    else
      Seat.find(all_seats - (bookings.map{|b| b.seat_ids}.flatten(1).collect { |arr| arr.size == 1 ? arr[0] : arr }))  
    end
  end

  # GET /bookings/1/edit
  def edit
  end

  # POST /bookings
  # POST /bookings.json
  def create
    user_id = current_user.id
    show_id = booking_params["show_id"].to_i
    show_name = Show.find(show_id).name
    seat_names = booking_params["seat_names"].split(/\s*,\s*/).map{|obj| obj.upcase}
    seat_ids = seat_names.map{|sn| Seat.find_by(name: sn).id}

    # get unavailable seats
    unavailable_seats = []
    seat_ids.each do |seat_id|
      seat_available = get_available_seats(show_name).map{|seat| seat.id}.include?seat_id
      unavailable_seats << seat_id if !seat_available
    end

    @booking = Booking.new()
    
    respond_to do |format|
      if unavailable_seats.count > 0
        flash[:notice] = "#{Seat.find(unavailable_seats).map{|s| s.name}.join(' , ')} not available, Please select different seats"
        format.html { redirect_to request.referrer }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      else
        charges = get_all_booking_charges(seat_ids)
        @booking = Booking.new(user_id: user_id, show_id: show_id, seat_ids: seat_ids, sub_total: charges[:sub_total], service_tax: charges[:service_tax], swachh_bharat_cess: charges[:swachh_bharat_cess], krishi_kalyan_cess: charges[:krishi_kalyan_cess], total: charges[:total])
        if @booking.save
          flash[:notice] = "Successfully Booked #{show_name}."
          format.html { redirect_to action: "show", id: @booking.id}
          format.json { render :show, status: :created, location: @booking}
        end
      end
    end
  end

  def get_all_booking_charges seat_ids
    sub_total = get_sub_total(seat_ids)
    service_tax = sub_total * 14/100
    swachh_bharat_cess = sub_total * 0.5/100
    krishi_kalyan_cess = sub_total * 0.5/100
    total = (sub_total + service_tax + swachh_bharat_cess + krishi_kalyan_cess).ceil
    charges = {sub_total: sub_total, service_tax: service_tax, swachh_bharat_cess: swachh_bharat_cess, krishi_kalyan_cess: krishi_kalyan_cess, total: total}
    return charges 
  end

  def get_sub_total seat_ids
    sum = 0
    Seat.find(seat_ids).each do |seat|
      sum = sum + seat.category.price
    end
    return sum
  end

  def theatre_revenue
    @bookings = Booking.all
  end

  # PATCH/PUT /bookings/1
  # PATCH/PUT /bookings/1.json
  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to @booking, notice: 'Booking was successfully updated.' }
        format.json { render :show, status: :ok, location: @booking }
      else
        format.html { render :edit }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    @booking.destroy
    respond_to do |format|
      format.html { redirect_to bookings_url, notice: 'Booking was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def booking_params
      params.require(:booking).permit(:show_id, :seat_names, :user_id)
    end
end
