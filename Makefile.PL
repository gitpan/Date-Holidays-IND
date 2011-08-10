use strict;use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Date::Holidays::IND',
    AUTHOR        => q{Mohammad S Anwar <mohammad.anwar@yahoo.com>},
    VERSION_FROM  => 'lib/Date/Holidays/IND.pm',
    ABSTRACT_FROM => 'lib/Date/Holidays/IND.pm',
    dist          => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean         => { FILES => 'Date-Holidays-IND-*' },
    PREREQ_PM     => {
        'Test::More' => 0,
        'Readonly'   => '1.03',
        'Date::Calc' => '5.7',
    },
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
);