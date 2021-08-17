class P2wController < ApplicationController
  def index
    @prices = { 247 => 29.99, 233 => 42.00, 222 => 35.99, 220 => 24.00, 214 => 24.00, 206 => 24.00,
                195 => 12.00, 175 => 24.00, 171 => 24.00, 71 => 29.99, 160 => 29.99, 143 => 24.00,
                135 => 24.00, 139 => 24.00, 138 => 24.00, 97 => 24.00, 84 => 29.99, 74 => 24.00,
                69 => 12.00, 68 => 12.00, 42 => 24.00 }
    @mounts = Mount.where(id: @prices.keys)
    @characters = Character.visible.recent
    @counts = CharacterMount.where(mount_id: @prices.keys, character: @characters).group(:mount_id).count
  end
end
