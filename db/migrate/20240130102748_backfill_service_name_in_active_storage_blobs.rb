class BackfillServiceNameInActiveStorageBlobs < ActiveRecord::Migration[7.0]
  def up
    ActiveStorage::Blob.unscoped.where(service_name: nil).in_batches.update_all(service_name: "local")
  end

  def down
  end
end
