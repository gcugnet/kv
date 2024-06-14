defmodule KV.RegistryTest do
  use ExUnit.Case, async: true

  alias KV.{Bucket, Registry}

  setup do
    registry = start_supervised!(Registry)
    %{registry: registry}
  end

  test "spawns buckets", %{registry: registry} do
    assert Registry.lookup(registry, "shopping") == :error

    Registry.create(registry, "shopping")
    assert {:ok, shopping_bucket} = Registry.lookup(registry, "shopping")

    Bucket.put(shopping_bucket, "milk", 1)
    assert Bucket.get(shopping_bucket, "milk") == 1
  end
end
