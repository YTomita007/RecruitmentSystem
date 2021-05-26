ActionMailer::Base.add_delivery_method :ses,
                                       AWS::SES::Base,
                                       access_key_id: 'AKIAYSXC76VGIWKZBQEY',
                                       secret_access_key: '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',
                                       server: 'email.us-west-2.amazonaws.com'
