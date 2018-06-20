##################################################
### This is a way for us to interface with AWS ###
##################################################

module AwsAdapter
  extend self

  def upload_file(upload_path, local_path, options = {})
    obj = S3_BUCKET.object(upload_path)
    obj.upload_file(local_path, options)
  end


  def get_public_url(upload_path)
    obj = S3_BUCKET.object(upload_path)
    url = obj.presigned_url(:get, expires_in: 3600)
    return url
  end


  def get_files(folder)
    S3_BUCKET.objects(prefix: folder).collect(&:key)
  end


  def get_s3_direct_post(upload_path)
    S3_BUCKET.presigned_post(key: upload_path, success_action_status: '201', acl: 'bucket-owner-read')
  end

  def download_file(file_path, download_directory, download_file_name, options={})
    dir = Rails.root.join(download_directory, download_file_name).to_s
    obj = S3_BUCKET.object(file_path).get(response_target: dir)
    return dir
  end

end