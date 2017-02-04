defmodule Extoon.ReceptionController do
  use Extoon.Web, :controller

  alias Extoon.Emails

  def removal(conn, %{"reception" => params}) do
    Emails.Contact.removal_request params

    hash =
      :crypto.strong_rand_bytes(5)
      |> Base.url_encode64
      |> binary_part(0, 5)

    conn
    |> put_flash(:info, "Accepted your message.")
    |> redirect(to: reception_path(conn, :removal, h: hash))
  end

  def removal(conn, _params) do
    render conn, "removal.html"
  end

  # def contact(conn, %{"contact" => params}) do
  #   case Extoon.ReceptionMailer.send_contact(params) do
  #     {:ok, _} ->
  #       conn
  #       |> put_flash(:info, "Accepted your message.")
  #       |> redirect(to: reception_path(conn, :contact))
  #     _ ->
  #       conn
  #       |> put_flash(:error, "Could not send your message.")
  #       |> render("contact.html")
  #   end
  # end

  # def contact(conn, _params) do
  #   render conn, "contact.html"
  # end

end
