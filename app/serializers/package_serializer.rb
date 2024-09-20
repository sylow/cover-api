class PackageSerializer < BaseSerializer
  attributes :name, :price, :description, :credits, :stripe_id
end