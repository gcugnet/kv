defmodule KV.BucketTest do
  use ExUnit.Case, async: true

  setup do
    bucket = start_supervised!(KV.Bucket)
    %{bucket: bucket}
  end

  test "stores values by key", %{bucket: bucket} do
    assert KV.Bucket.get(bucket, "milk") == nil

    KV.Bucket.put(bucket, "milk", 3)
    assert KV.Bucket.get(bucket, "milk") == 3
  end

  test "deletes a key and returns it values", %{bucket: bucket} do
    KV.Bucket.put(bucket, "eggs", 6)

    deleted_value = KV.Bucket.delete(bucket, "eggs")
    assert deleted_value == 6
    assert KV.Bucket.get(bucket, "eggs") == nil
  end
end
