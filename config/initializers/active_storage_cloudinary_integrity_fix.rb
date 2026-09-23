# frozen_string_literal: true

# Cloudinary is an image-optimizing CDN, not a passive byte store: on ingest
# it's free to normalize what it stores (recompression, EXIF-driven
# auto-rotation, metadata stripping, etc.), so the bytes it hands back rarely
# match the MD5 checksum ActiveStorage computed from the original upload
# before the file ever touched Cloudinary.
#
# ActiveStorage::Blob#open verifies that checksum on every download, and it's
# called whenever a variant needs to be built (i.e. on every rendered
# blog/guide image, since views call `image.variant(...)`). The mismatch
# raises ActiveStorage::IntegrityError, which is why every image request
# 500s before it ever reaches Cloudinary's CDN URL.
#
# Skip that verification for the Cloudinary service specifically — we trust
# Cloudinary's own storage integrity, not a checksum that was only ever valid
# for the pre-processed original.
Rails.application.config.after_initialize do
  # Force ActiveStorage::Blob to load before the Cloudinary service file does.
  # That file references ActiveStorage::Blob at its top level; if it's the one
  # that triggers Blob's first autoload, Blob's own load hook tries to
  # `require` this same file again while it's still mid-load, which Ruby
  # no-ops (circular require) — leaving the service class undefined and
  # raising NameError. Loading Blob up front avoids the reentrancy.
  ActiveStorage::Blob
  require "active_storage/service/cloudinary_service"

  ActiveStorage::Service::CloudinaryService.prepend(Module.new do
    def open(key, checksum: nil, verify: true, **options, &block)
      super(key, checksum: checksum, verify: false, **options, &block)
    end
  end)
end
