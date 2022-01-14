defmodule Flightex.Bookings.Report do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking

  def generate(filename \\ "report.csv") do
    booking_list = build_booking_list()

    File.write(filename, booking_list)
  end

  def generate_report(filename \\ "report-by-date.csv", from_date, to_date)
      when is_struct(from_date, NaiveDateTime) and is_struct(to_date, NaiveDateTime) do
    booking_list = build_booking_list_by_date(from_date, to_date)

    File.write(filename, booking_list)

    {:ok, "Report generated successfully"}
  end

  defp build_booking_list_by_date(from_date, to_date) do
    BookingAgent.get_all()
    |> Map.values()
    |> Enum.filter(&is_between_dates(&1.complete_date, from_date, to_date))
    |> Enum.map(&booking_string/1)
  end

  defp is_between_dates(date, initial_date, end_date) do
    with :gt <- NaiveDateTime.compare(date, initial_date),
         :lt <- NaiveDateTime.compare(date, end_date) do
      true
    else
      _ -> false
    end
  end

  defp build_booking_list() do
    BookingAgent.get_all()
    |> Map.values()
    |> Enum.map(&booking_string/1)
  end

  defp booking_string(%Booking{
         complete_date: complete_date,
         user_id: user_id,
         local_origin: local_origin,
         local_destination: local_destination
       }) do
    formatted_date = NaiveDateTime.to_string(complete_date)
    "#{user_id},#{local_origin},#{local_destination},#{formatted_date}\n"
  end
end
