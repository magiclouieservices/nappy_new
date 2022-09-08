defmodule Nappy.NewsletterTest do
  use Nappy.DataCase

  alias Nappy.Newsletter

  describe "subscribers" do
    alias Nappy.Newsletter.Subscriber

    import Nappy.NewsletterFixtures

    @invalid_attrs %{is_photographer: nil}

    test "list_subscribers/0 returns all subscribers" do
      subscriber = subscriber_fixture()
      assert Newsletter.list_subscribers() == [subscriber]
    end

    test "get_subscriber!/1 returns the subscriber with given id" do
      subscriber = subscriber_fixture()
      assert Newsletter.get_subscriber!(subscriber.id) == subscriber
    end

    test "create_subscriber/1 with valid data creates a subscriber" do
      valid_attrs = %{is_photographer: true}

      assert {:ok, %Subscriber{} = subscriber} = Newsletter.create_subscriber(valid_attrs)
      assert subscriber.is_photographer == true
    end

    test "create_subscriber/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Newsletter.create_subscriber(@invalid_attrs)
    end

    test "update_subscriber/2 with valid data updates the subscriber" do
      subscriber = subscriber_fixture()
      update_attrs = %{is_photographer: false}

      assert {:ok, %Subscriber{} = subscriber} =
               Newsletter.update_subscriber(subscriber, update_attrs)

      assert subscriber.is_photographer == false
    end

    test "update_subscriber/2 with invalid data returns error changeset" do
      subscriber = subscriber_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Newsletter.update_subscriber(subscriber, @invalid_attrs)

      assert subscriber == Newsletter.get_subscriber!(subscriber.id)
    end

    test "delete_subscriber/1 deletes the subscriber" do
      subscriber = subscriber_fixture()
      assert {:ok, %Subscriber{}} = Newsletter.delete_subscriber(subscriber)
      assert_raise Ecto.NoResultsError, fn -> Newsletter.get_subscriber!(subscriber.id) end
    end

    test "change_subscriber/1 returns a subscriber changeset" do
      subscriber = subscriber_fixture()
      assert %Ecto.Changeset{} = Newsletter.change_subscriber(subscriber)
    end
  end

  describe "referrers" do
    alias Nappy.Newsletter.Referrer

    import Nappy.NewsletterFixtures

    @invalid_attrs %{name: nil}

    test "list_referrers/0 returns all referrers" do
      referrer = referrer_fixture()
      assert Newsletter.list_referrers() == [referrer]
    end

    test "get_referrer!/1 returns the referrer with given id" do
      referrer = referrer_fixture()
      assert Newsletter.get_referrer!(referrer.id) == referrer
    end

    test "create_referrer/1 with valid data creates a referrer" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Referrer{} = referrer} = Newsletter.create_referrer(valid_attrs)
      assert referrer.name == "some name"
    end

    test "create_referrer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Newsletter.create_referrer(@invalid_attrs)
    end

    test "update_referrer/2 with valid data updates the referrer" do
      referrer = referrer_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Referrer{} = referrer} = Newsletter.update_referrer(referrer, update_attrs)
      assert referrer.name == "some updated name"
    end

    test "update_referrer/2 with invalid data returns error changeset" do
      referrer = referrer_fixture()
      assert {:error, %Ecto.Changeset{}} = Newsletter.update_referrer(referrer, @invalid_attrs)
      assert referrer == Newsletter.get_referrer!(referrer.id)
    end

    test "delete_referrer/1 deletes the referrer" do
      referrer = referrer_fixture()
      assert {:ok, %Referrer{}} = Newsletter.delete_referrer(referrer)
      assert_raise Ecto.NoResultsError, fn -> Newsletter.get_referrer!(referrer.id) end
    end

    test "change_referrer/1 returns a referrer changeset" do
      referrer = referrer_fixture()
      assert %Ecto.Changeset{} = Newsletter.change_referrer(referrer)
    end
  end
end
