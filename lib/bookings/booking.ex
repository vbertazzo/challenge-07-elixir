defmodule Flightex.Bookings.Booking do
  @keys [:complete_date, :local_origin, :local_destination, :user_id, :id]
  @enforce_keys @keys
  defstruct @keys

  def build(date, origin, destination, user_id)
      when is_struct(date, NaiveDateTime) do
    booking_id = UUID.uuid4()

    {:ok,
     %__MODULE__{
       id: booking_id,
       complete_date: date,
       local_origin: origin,
       local_destination: destination,
       user_id: user_id
     }}
  end
end
