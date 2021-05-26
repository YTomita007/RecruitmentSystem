class Fruit < ApplicationRecord
  mount_uploader :fruitspic, FruitspicUploader
  mount_uploader :animalpic, AnimalpicUploader
end
