defmodule RedditWeb.PowResetPassword.MailerView do
  use RedditWeb, :mailer_view

  def subject(:reset_password, _assigns), do: "Reset password link"
end
