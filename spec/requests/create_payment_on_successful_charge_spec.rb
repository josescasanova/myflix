require 'spec_helper'

describe "Create payment on successful charge" do
  let(:event_data) do
        {
      id: "ch_103rgh27wYrAQOnHOhYJmAjy",
      created: 1397671183,
      livemode: false,
      type: "charge.succeeded",
      data: {
        object: {
          id: "ch_103rgh27wYrAQOnHOhYJmAjy",
          object: "charge",
          created: 1397671183,
          livemode: false,
          paid: true,
          amount: 999,
          currency: "usd",
          refunded: false,
          card: {
            id: "card_103rgh27wYrAQOnHMEEvf9LF",
            object: "card",
            last4: "4242",
            type: "Visa",
            exp_month: 4,
            exp_year: 2014,
            fingerprint: "v5aIbtpRE6eDf9H7",
            customer: "cus_3rghTyx75cZsQq",
            country: "US",
            name: nil,
            address_line1: nil,
            address_line2: nil,
            address_city: nil,
            address_state: nil,
            address_zip: nil,
            address_country: nil,
            cvc_check: "pass",
            address_line1_check: nil,
            address_zip_check: nil
          },
          captured: true,
          refunds: [

          ],
          balance_transaction: "txn_103rgh27wYrAQOnHbsjwh7QK",
          failure_message: nil,
          failure_code: nil,
          amount_refunded: 0,
          customer: "cus_3rghTyx75cZsQq",
          invoice: "in_103rgh27wYrAQOnHpuSZSfGd",
          description: nil,
          dispute: nil,
          metadata: {},
          statement_description: "Monthly MyFLiX"
        }
      },
      object: "event",
      pending_webhooks: 1,
      request: "iar_3l6BKbMvzMDb4s"
    }
  end

  it "creates a payment with the webhook from stripe for charge succeeded", :vcr do 
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with user", :vcr do
    alice = Fabricate(:user, customer_token: "cus_3rfcWqZZtGOeqp")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(alice)
  end

  it "creates the payment with the amount", :vcr do
    alice = Fabricate(:user, customer_token: "cus_3rfcWqZZtGOeqp")
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates the payment with reference_id", :vcr do
    alice = Fabricate(:user, customer_token: "cus_3rfcWqZZtGOeqp")
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq("ch_103rfc27wYrAQOnHm6NN40m7")
  end
end