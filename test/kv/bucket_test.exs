defmodule KV.BucketTest do
  use ExUnit.Case, async: true

  alias KV.Bucket

  setup do
    bucket = start_supervised!(Bucket)
    %{bucket: bucket}
  end

  test "stores values by key", %{bucket: bucket} do
    assert Bucket.get(bucket, "milk") == nil

    Bucket.put(bucket, "milk", 3)
    assert Bucket.get(bucket, "milk") == 3
  end

  test "deletes a key and returns it values", %{bucket: bucket} do
    Bucket.put(bucket, "eggs", 6)

    deleted_value = Bucket.delete(bucket, "eggs")
    assert deleted_value == 6
    assert Bucket.get(bucket, "eggs") == nil
  end
end
