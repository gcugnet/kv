defmodule KV.RegistryTest do
  use ExUnit.Case, async: true

  alias KV.{Bucket, Registry}

  setup context do
    _ = start_supervised!({Registry, name: context.test})
    %{registry: context.test}
  end

  test "spawns buckets", %{registry: registry} do
    assert Registry.lookup(registry, "shopping") == :error

    Registry.create(registry, "shopping")
    assert {:ok, shopping_bucket} = Registry.lookup(registry, "shopping")

    Bucket.put(shopping_bucket, "milk", 1)
    assert Bucket.get(shopping_bucket, "milk") == 1
  end

  test "remove buckets on exit", %{registry: registry} do
    Registry.create(registry, "shopping")
    {:ok, shopping_bucket} = Registry.lookup(registry, "shopping")

    Agent.stop(shopping_bucket)
    assert Registry.lookup(registry, "shopping") == :error
  end

  test "remove buckets on crash", %{registry: registry} do
    Registry.create(registry, "shopping")
    {:ok, shopping_bucket} = Registry.lookup(registry, "shopping")

    # Remove bucket with non-normal reason
    Agent.stop(shopping_bucket, :shutdown)
    assert Registry.lookup(registry, "shopping") == :error
  end
end
