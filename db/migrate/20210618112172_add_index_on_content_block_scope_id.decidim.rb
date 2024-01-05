# frozen_string_literal: true
# This migration comes from decidim (originally 20200401073419)

class AddIndexOnContentBlockScopeId < ActiveRecord::Migration[5.2]
  def change
    add_index(
      :decidim_content_blocks,
      %i[decidim_organization_id scope_name scoped_resource_id manifest_name],
      name: 'idx_decidim_content_blocks_org_id_scope_scope_id_manifest'
    )
  end
end
