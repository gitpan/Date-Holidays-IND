use strict;use warnings;
use Module::Build;

my $builder = Module::Build->new(
    sign              => 1,
    module_name       => 'Date::Holidays::IND',
    license           => 'perl',
    dist_author       => q{Mohammad S Anwar <mohammad.anwar@yahoo.com>},
    dist_version_from => 'lib/Date/Holidays/IND.pm',
    add_to_cleanup    => [ 'Date-Holidays-IND-*' ],    
    build_requires    => {
        'Test::More'  => 0,
        'Readonly'    => 0,
        'Date::Calc'  => 5.7,
    },
);

$builder->create_build_script();