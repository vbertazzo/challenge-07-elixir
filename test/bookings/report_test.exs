# Este teste é opcional, mas vale a pena tentar e se desafiar 😉

defmodule Flightex.Bookings.ReportTest do
  use ExUnit.Case, async: true

  alias Flightex.Bookings.Report

  describe "generate/1" do
    setup do
      Flightex.start_agents()

      :ok
    end

    test "when called, return the content" do
      params = %{
        complete_date: ~N[2001-05-07 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      content = "12345678900,Brasilia,Bananeiras,2001-05-07 12:00:00"

      Flightex.create_or_update_booking(params)
      Report.generate("report-test.csv")
      {:ok, file} = File.read("report-test.csv")

      assert file =~ content
    end
  end

  # Testes adicionados pelo aluno

  describe "generate_report/2" do
    setup do
      Flightex.start_agents()

      params = %{
        complete_date: ~N[2001-05-07 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      {:ok, params: params}
    end

    test "when called with valid dates, returns the content", %{params: params} do
      content = "12345678900,Brasilia,Bananeiras,2001-05-07 12:00:00"

      Flightex.create_or_update_booking(params)

      from_date = ~N[2001-05-06 12:00:00]
      to_date = ~N[2001-05-08 12:00:00]
      filename = "report-by-date-test.csv"

      Report.generate_report(filename, from_date, to_date)
      {:ok, file} = File.read(filename)

      assert file =~ content
    end

    test "when called with valid dates but no specific filename, returns the content", %{
      params: params
    } do
      content = "12345678900,Brasilia,Bananeiras,2001-05-07 12:00:00"

      Flightex.create_or_update_booking(params)

      from_date = ~N[2001-05-06 12:00:00]
      to_date = ~N[2001-05-08 12:00:00]

      Report.generate_report(from_date, to_date)
      {:ok, file} = File.read("report-by-date.csv")

      assert file =~ content
    end

    test "when called with invalid dates, returns an error", %{params: params} do
      Flightex.create_or_update_booking(params)

      from_date = "2001-05-08"
      to_date = ~N[2001-05-08 12:00:00]
      filename = "report-by-date-test.csv"

      response = Report.generate_report(filename, from_date, to_date)

      assert response == {:error, "Invalid params"}
    end
  end
end
