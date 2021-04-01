
if exists("b:current_syntax")
  finish
endif

syn match hclEqual '='
syn match hclComma ','
syn match hclQuote '"' contained
syn match hclSimpleString '"[^\"]*"' contains=hclQuote,hclEscape
syn region hclComment display oneline start='\%\(^\|\s\)#' end='$'
syn region hclComment display oneline start='\%\(^\|\s\)//' end='$'
syn region hclComment start='\%\(^\|\s\)/\*' end='\*/'
syn region hclInterpolation display oneline start='(' end=')' contains=hclInterpolation,hclSimpleString
syn region hclSmartString display oneline matchgroup=hclQuote start='"' matchgroup=hclQuote end='"\s*$' contains=hclInterpolation,hclEscape

" May differ from actual grammar
syn match hclEscape '\\\([abfnrtv\\"]\|[0-7]\{3}\|x[0-9A-Fa-f]\{2}\|u[0-9A-Fa-f]\{4}\|U[0-9A-Fa-f]\{8}\)' contained
syn match hclIdent '\<[A-Za-z_\x80-\uffff][A-Za-z_\x80-\uffff0-9.-]*'
syn region hclObject matchgroup=hclBraces start="{" end=/}\(\_s\+\ze\("\|{\)\)\@!/ contains=@hclKey,hclEqual,@hclNode,hclComma,hclComment transparent fold
syn region hclList matchgroup=hclBraces start="\[" end=/]\(\_s\+\ze"\)\@!/ contains=@hclNode,hclComma,hclComment transparent fold
syn match hclNumber "-\=\<\%(0\|[1-9]\d*\)\%(\.\d\+\)\=\%([eE][-+]\=\d\+\)\=\>"
syn match hclNumber "-\=\<\%(0x[0-9a-f]\+\)\%(\.[0-9a-f]\+\)\=\%([eE][-+]\=[0-9a-f]\+\)\=\>"
syn region hclHereDoc matchgroup=hclHereDocEnd start="<<-\=\s*\z([^ \t|>]\+\)" matchgroup=hclHereDocEnd end="^\z1\s*$"
syn match hclBoolean /\(true\|false\)\(\_s\+\ze"\)\@!/
syn cluster hclNode contains=hclSimpleString,hclSmartString,hclList,hclObject,hclNumber,hclHereDoc,hclBoolean
syn cluster hclKey contains=hclString,hclIdent,hclRootKeywords,hclAwsResourcesKeywords,hclCustomTypeKeywords,hclCustomStatementKeywords

if !exists('b:hcl_no_root_keywords') || !b:hcl_no_root_keywords
	syn keyword hclRootKeywords variable provider resource nextgroup=hclString,hclString skipwhite
	syn keyword hclRootKeywords default nextgroup=hclEquals skipwhite
endif


if !exists('b:hcl_no_aws_resource_keywords') || !b:hcl_no_aws_resource_keywords
	syn keyword hclAwsResourcesKeywords availability_zones desired_capacity force_delete health_check_grace_period health_check_type launch_configuration load_balancers max_size min_size name vpc_zone_identifier nextgroup=hclEquals,hclString skipwhite
	syn keyword hclAwsResourcesKeywords allocated_storage availability_zone backup_retention_period backup_window db_subnet_group_name engine engine_version final_snapshot_identifier identifier instance_class iops maintenance_window multi_az name password port publicly_accessible security_group_names skip_final_snapshot username vpc_security_group_ids nextgroup=hclEquals,hclString skipwhite
	syn keyword hclAwsResourcesKeywords cidr description ingress name security_group_id security_group_name security_group_owner_id source_security_group_id nextgroup=hclEquals,hclString skipwhite
	syn keyword hclAwsResourcesKeywords description name subnet_ids nextgroup=hclEquals,hclString skipwhite
	syn keyword hclAwsResourcesKeywords instance vpc nextgroup=hclEquals,hclString skipwhite
	syn keyword hclAwsResourcesKeywords availability_zones health_check healthy_threshold instance_port instance_protocol instances internal interval lb_port lb_protocol listener name security_groups ssl_certificate_id subnets target timeout unhealthy_threshold nextgroup=hclEquals,hclString skipwhite
	syn keyword hclAwsResourcesKeywords ami associate_public_ip_address availability_zone ebs_optimized iam_instance_profile instance_type key_name private_ip security_groups source_dest_check subnet_id tags user_data nextgroup=hclEquals,hclString skipwhite
	syn keyword hclAwsResourcesKeywords vpc_id nextgroup=hclEquals,hclString skipwhite
	syn keyword hclAwsResourcesKeywords iam_instance_profile image_id instance_type key_name name name_prefix security_groups user_data nextgroup=hclEquals,hclString skipwhite
	syn keyword hclAwsResourcesKeywords name records ttl type zone_id nextgroup=hclEquals,hclString skipwhite
	syn keyword hclAwsResourcesKeywords name nextgroup=hclEquals,hclString skipwhite
	syn keyword hclAwsResourcesKeywords route_table_id subnet_id nextgroup=hclEquals,hclString skipwhite
	syn keyword hclAwsResourcesKeywords cidr_block gateway_id instance_id route vpc_id nextgroup=hclEquals,hclString skipwhite
	syn keyword hclAwsResourcesKeywords acl bucket nextgroup=hclEquals,hclString skipwhite
	syn keyword hclAwsResourcesKeywords cidr_blocks description from_port ingress name owner_id protocol security_groups self tags to_port vpc_id nextgroup=hclEquals,hclString skipwhite
	syn keyword hclAwsResourcesKeywords availability_zone- cidr_block map_public_ip_on_launch vpc_id nextgroup=hclEquals,hclString skipwhite
	syn keyword hclAwsResourcesKeywords cidr_block enable_dns_hostnames enable_dns_support tags nextgroup=hclEquals,hclString skipwhite
endif

if exists('b:hcl_custom_keywords')
	execute 'syn keyword hclCustomTypeKeywords ' . join(get(b:hcl_custom_keywords, 'type', []), ' ') ' nextgroup=hclEquals,hclString,hclIdent,hclObject skipwhite'
	execute 'syn keyword hclCustomStatementKeywords ' . join(get(b:hcl_custom_keywords, 'statement', []), ' ') ' nextgroup=hclEquals,hclString,hclIdent,hclObject skipwhite'
endif


hi def link hclComment                  Comment
hi def link hclEqual                    Operator
hi def link hclRootKeywords             Statement
hi def link hclAwsResourcesKeywords     Type
hi def link hclSmartString              String
hi def link hclInterpolation            String
hi def link hclHereDoc                  String
hi def link hclSimpleString             PreProc
hi def link hclBraces                   Delimiter
hi def link hclNumber                   Number
hi def link hclBoolean                  Boolean
hi def link hclHereDocEnd               Quote
hi def link hclQuote                    Quote
hi def link hclComma                    Delimiter
hi def link hclEscape                   Special
hi def link hclCustomTypeKeywords       Type
hi def link hclCustomStatementKeywords  Statement
hi def link hclIdent                    Identifier

let b:current_syntax = "hcl"
