require 'spec_helper'

describe 'Deactiveate user on failed charge', :vcr do
  let(:event_data) do
    {
      "id" => "evt_103s3l27wYrAQOnHe6dxw2WM",
      "created" => 1397757000,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_103s3l27wYrAQOnHJxaWVVT5",
          "object" => "charge",
          "created" => 1397757000,
          "livemode" => false,
          "paid" => false,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "card" => {
            "id" => "card_103s3l27wYrAQOnHg9ewI4ES",
            "object" => "card",
            "last4" => "0341",
            "type" => "Visa",
            "exp_month" => 4,
            "exp_year" => 2017,
            "fingerprint" => "tyQ3sUa8vvxX2XTd",
            "customer" => "cus_3s2xX2cY3NV2ed",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil
          },
          "captured" => false,
          "refunds" => [],
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_3s2xX2cY3NV2ed",
          "invoice" => nil,
          "description" => "payment to fail",
          "dispute" => nil,
          "metadata" => {},
          "statement_description" => nil
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_3s3lFT2ndeOkTz"
    }
  end

  it "deactivate a user with the web hook data from stripe for a charge failed", :vcr do
    alice = Fabricate(:user, customer_token: "cus_3s2xX2cY3NV2ed")
    post "/stripe", event_data
    expect(alice.reload).not_to be_active
  end

end