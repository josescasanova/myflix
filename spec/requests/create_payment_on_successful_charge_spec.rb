require 'spec_helper'

describe "Create payment on successful charge", :vcr do
  let(:event_data) do
    {
      "created" => 1326853478,
      "livemode" => false,
      "id" => "evt_00000000000000",
      "type" => "charge.succeeded",
      "object" => "event",
      "request" => nil,
      "data" => {
        "object" => {
          "id" => "ch_00000000000000",
          "object" => "charge",
          "created" => 1397685677,
          "livemode" => false,
          "paid" => true,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "card" => {
            "id" => "card_00000000000000",
            "object" => "card",
            "last4" => "4242",
            "type" => "Visa",
            "exp_month" => 4,
            "exp_year" => 2016,
            "fingerprint" => "v5aIbtpRE6eDf9H7",
            "customer" => "cus_00000000000000",
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
          "captured" => true,
          "refunds" => [],
          "balance_transaction" => "txn_00000000000000",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_00000000000000",
          "invoice" => "in_00000000000000",
          "description" => nil,
          "dispute" => nil,
          "metadata" => {},
          "statement_description" => nil
        }
      }
    }
  end

  it "creates a payment with the webhook from stripe for charge succeeded", :vcr do 
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with user", :vcr do
    alice = Fabricate(:user, customer_token: "cus_00000000000000")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(alice)
  end

  it "creates the payment with the amount", :vcr do
    alice = Fabricate(:user, customer_token: "cus_00000000000000")
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates the payment with reference_id", :vcr do
    alice = Fabricate(:user, customer_token: "cus_00000000000000")
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq("v5aIbtpRE6eDf9H7")
  end
end