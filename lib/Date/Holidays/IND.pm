package Date::Holidays::IND;

use strict; use warnings;

use overload q("") => \&as_string, fallback => 1;

use Carp;
use Readonly;
use Data::Dumper;
use Date::Calc qw/Day_of_Week/;

=head1 NAME

Date::Holidays::IND - Interface to Indian holidays.

=head1 VERSION

Version 0.04

=cut

our $VERSION = '0.04';
Readonly my $MONTHS   => [ undef, 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec' ];
Readonly my $WEEKDAYS => [ undef, 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun' ];

Readonly my $DEFAULT_YEAR => 2011;

Readonly my $STATES =>
{
    'AN' => 'Andaman/Nicobar',
    'AP' => 'Andhra Pradesh',
    'AR' => 'Arunachal Pradesh',
    'AS' => 'Assam',
    'BR' => 'Bihar',
    'CG' => 'Chattisgarh',
    'CH' => 'Chandigarh',
    'DD' => 'Daman/Diu',
    'DL' => 'Delhi',
    'DN' => 'Dadra and Nagar Haveli',
    'GA' => 'Goa',
    'GJ' => 'Gujrat',
    'HP' => 'Himachal Pradesh',
    'HR' => 'Haryana',
    'JH' => 'Jharkhand',
    'JK' => 'Jammu/Kashmir',
    'KA' => 'Karnataka',
    'KL' => 'Kerala',
    'LD' => 'Lakshadweep',
    'MH' => 'Maharashtra',
    'ML' => 'Meghalaya',
    'MN' => 'Manipur',
    'MP' => 'Madhya Pradesh',
    'MZ' => 'Mizoram',
    'NL' => 'Nagaland',
    'OR' => 'Orissa',
    'PB' => 'Punjab',
    'PY' => 'Puducherry',
    'RJ' => 'Rajasthan',
    'SK' => 'Sikkim',
    'TN' => 'Tamil Nadu',
    'TR' => 'Tripura',
    'UK' => 'Uttarakhand',
    'UP' => 'Uttar Pradesh',
    'WB' => 'West Bengal'
};

Readonly my $NATIONAL =>
[
    { mm => 1,  dd => 26, desc => "Republic Day" },
    { mm => 8,  dd => 15, desc => "Independence Day" },
    { mm => 10, dd => 2,  desc => "Mahatma Gandhi's Birthday" }
];

Readonly my $HOLIDAYS_2012 =>
{
    1 =>
    {
        1 =>
        {
            desc   => "New Year's Day",
            states => ['AR','ML','MN','MZ','PY','SK','TN']
        },
        5 =>
        {
            desc   => "Guru Govind Singh Jayanti",
            states => ['CH','HP','HR','PB']
        },
        14 =>
        {
            desc   => "Bhogi",
            states => ['AP']
        },
        15 =>
        {
            desc   => "Pongal/Makar Samkranti",
            states => ['AN','AN','AR','AS','GJ','KA','PY','TN']
        },
        16 =>
        {
            desc   => "Thiruvalluvar Day",
            states => ['PY','TN']
        },
        17 =>
        {
            desc   => "Uzhavar Thirunal",
            states => ['TN']
        },
        23 =>
        {
            desc   => "Netaji Subhash Chandra Bose Jayanti",
            states => ['TR','WB']
        },
        28 =>
        {
            desc   => "Vasanta Panchami/Shree Panchami",
            states => ['HR','OR','TR','WB']
        }
    },
    2 =>
    {
        5 =>
        {
            desc   => "Milad-un-Nabi (Prophet Mohammad (pbuh) Birthday)",
            states => ['AN','AP','CH','DL','KA','KL','MH','MP','MZ','PY',
                       'TN','UK','UP']
        },
        7 =>
        {
            desc   => "Guru Ravidas Jayanti",
            states => ['CH','HR','PB']
        },
        19 =>
        {
            desc   => "Chatrapati Shivaji Maharaj Jayanti",
            states => ['MH']
        },
        20 =>
        {
            desc   => "Maha Shivratri",
            states => ['AP','CG','CH','GJ','HP','HR','JK','KA','KL','MH',
                       'MP','OR','UK','UP']
        }
    },
    3 =>
    {
        7 =>
        {
            desc   => "Doljatra/Holika Dahan",
            states => ['AP','AS','ML','MN','PB','UP','WB']
        },
        8 =>
        {
            desc   => "Holi",
            states => ['AN','AR','BR','CG','CH','DD','DL','DN','GA','GJ',
                       'HP','JH','JK','KL','LD','MH','MP','MZ','NL','OR',
                       'RJ','SK','UK','UP']
        },
        15 =>
        {
            desc   => "Kashiramji Jayanti",
            states => ['UP']
        },
        22 =>
        {
            desc   => "Gudi Padva/Ugadi/Chetti Chand/Telugu New Year",
            states => ['AP','GA','KA','MH','UP','PY','TN']
        },
        31 =>
        {
            desc   => "Ram Navami",
            states => ['BR','CH','DL','MH','MP','OR','PB','RJ','SK','UK',
                       'UP','AP','GJ','HR']
        }
    }
};

Readonly my $HOLIDAYS_2011 =>
{
    1 =>
    {
        1 =>
        {
            desc   => "New Year's Day",
            states => ['AR','ML','MN','MZ','PY','SK','TN']
        },
        5 =>
        {
            desc   => "Guru Govind Singh Jayanti",
            states => ['CH','HP','HR','PB']
        },
        14 =>
        {
            desc   => "Bhogi",
            states => ['AP']
        },
        15 =>
        {
            desc   => "Pongal/Makar Samkranti",
            states => ['AN','AN','AR','AS','GJ','KA','PY','TN']
        },
        16 =>
        {
            desc   => "Thiruvalluvar Day",
            states => ['PY','TN']
        },
        17 =>
        {
            desc   => "Uzhavar Thirunal",
            states => ['TN']
        },
        23 =>
        {
            desc   => "Netaji Subhash Chandra Bose Jayanti",
            states => ['TR','WB']
        }
    },
    2 =>
    {
        8 =>
        {
            desc   => "Vasanta Panchami/Shree Panchami",
            states => ['HR','OR','TR','WB']
        },
        16 =>
        {
            desc   => "Milad-un-Nabi (Prophet Mohammad (pbuh) Birthday)",
            states => ['AN','AP','CH','DL','KA','KL','MH','MP','MZ','PY',
                       'TN','UK','UP']
        },
        18 =>
        {
            desc   => "Guru Ravidas Jayanti",
            states => ['CH','HR','PB']
        },
        19 =>
        {
            desc   => "Chatrapati Shivaji Maharaj Jayanti",
            states => ['MH']
        }
    },
    3 =>
    {
        2 =>
        {
            desc   => "Maha Shivratri",
            states => ['AP','CG','CH','GJ','HP','HR','JK','KA','KL','MH',
                       'MP','OR','UK','UP']
        },
        15 =>
        {
            desc   => "Kashiramji Jayanti",
            states => ['UP']
        },
        19 =>
        {
            desc   => "Doljatra/Holika Dahan",
            states => ['AP','AS','ML','MN','PB','UP','WB']
        },
        20 =>
        {
            desc   => "Holi",
            states => ['AN','AR','BR','CG','CH','DD','DL','DN','GA','GJ',
                       'HP','JH','JK','KL','LD','MH','MP','MZ','NL','OR',
                       'RJ','SK','UK','UP']
        },
        23 =>
        {
            desc   => "Shahidi Divas",
            states => ['HR']
        }
    },
    4 =>
    {
        1 =>
        {
            desc   => "Annual Accounts Closing (Bank Holiday)",
            states => ['AN','AP','AR','AS','BR','CG','CH','DD','DL','DN',
                       'GA','GJ','HP','HR','JH','JK','KA','KL','LD','MH',
                       'ML','MN','MP','MZ','NL','OR','PB','PY','RJ','SK',
                       'TN','TR','UK','UP','WB']
        },
        4 =>
        {
            desc   => "Gudi Padva/Ugadi/Chetti Chand/Telugu New Year",
            states => ['AP','GA','KA','MH','UP','PY','TN']
        },
        5 =>
        {
            desc   => "Babu Jagjivan Ram's Birthday",
            states => ['AP']
        },
        5 =>
        {
            desc   => "Babu Jagjivan Ram's Birthday",
            states => ['AP']
        },
        12 =>
        {
            desc   => "Ram Navami",
            states => ['BR','CH','DL','MH','MP','OR','PB','RJ','SK','UK',
                       'UP','AP','GJ','HR']
        },
        14 =>
        {
            desc   => "Dr. Ambedkar Jayanti/Tamil New Year/Vishu",
            states => ['AP','BR','CH','GJ','HR','JK','KA','KL','MH','OR',
                       'PY','TN','UK','UP']
        },
        15 =>
        {
            desc   => "Bengali New Year/Vaisakh/Masadi",
            states => ['TR','WB']
        },
        16 =>
        {
            desc   => "Mahavir Jayanti",
            states => ['AN','CG','DL','HP','KA','MH','MP','RJ','TN','UK',
                       'UP']
        },
        22 =>
        {
            desc   => "Good Friday",
            states => ['AN','AP','AR','AS','BR','CH','DD','DL','DN','GA',
                       'JH','KA','KL','LD','MH','ML','MN','MP','MZ','NL',
                       'PY','SK','TN','UK','UP','WB']
        }
    },
    5 =>
    {
        1 =>
        {
            desc   => "May Day/Maharashtra Day",
            states => ['AP','AS','BR','GA','KA','KL','MN','MH','PY','TN',
                       'TR','WB']
        },
        5 =>
        {
            desc   => "Maharishi Parsuram Jayanti",
            states => ['HR','UP']
        },
        6 =>
        {
            desc   => "Basava Jayanti",
            states => ['KA']
        },
        17 =>
        {
            desc   => "Buddha Purnima",
            states => ['AN','AR','CG','DL','HP','JK','MH','MP','MZ','UK',
                       'UP']
        }
    },
    6 =>
    {
        15 =>
        {
            desc   => "Sant Kabir Jayanti",
            states => ['HR']
        },
        16 =>
        {
            desc   => "Hazrat Ali Birthday/Martydom Day of Sri Guru Arjun Dev Ji",
            states => ['UP','PB']
        }
    },
    8 =>
    {
        2 =>
        {
            desc   => "Teej",
            states => ['HR']
        },
        13 =>
        {
            desc   => "Raksha Bandhan",
            states => ['GJ','RJ','UK','UP']
        },
        19 =>
        {
            desc   => "Parsi New Year",
            states => ['MH']
        },
        21 =>
        {
            desc   => "Janmashtami (Smaria)",
            states => ['BR','OR','TN']
        },
        22 =>
        {
            desc   => "Janmashtami (Vaishnava)",
            states => ['CH','DL','GJ','HR','JK','PB','RJ','UK','UP']
        },
        23 =>
        {
            desc   => "Sri Krishna Ashtami",
            states => ['AP']
        },
        26 =>
        {
            desc   => "Jumat-ul-Wida",
            states => ['JK','UK','UP']
        },
        31 =>
        {
            desc   => "Idul Fitr",
            states => ['AN','AP','AR','AS','BR','CG','CH','DD','DL','DN',
                       'GJ','HP','HR','JK','KA','MH','ML','MN','MP','MZ',
                       'NL','OR','PB','PY','RJ','SK','TN','TR','UK','WB']
        }
    },
    9 =>
    {
        1 =>
        {
            desc   => "Ganesh Chaturthi/Vinayak Chaturthi",
            states => ['AP','GA','GJ','MH','OR','PY','TN']
        },
        8 =>
        {
            desc   => "First Oname",
            states => ['KL']
        },
        9 =>
        {
            desc   => "Onam/Thiruonam",
            states => ['KL','PY']
        },
        21 =>
        {
            desc   => "Sree Narayana Guru Samadhi Divas",
            states => ['KL']
        },
        23 =>
        {
            desc   => "Haryana Veer and Shahidi Divas",
            states => ['HR']
        },
        27 =>
        {
            desc   => "Mahalaya",
            states => ['KA','WB']
        },
        28 =>
        {
            desc   => "Maharaja Agrasen Jayanthi",
            states => ['HR']
        },
        30 =>
        {
            desc   => "Mid-Year Accounts Closing (Bank Holiday)",
            states => ['AN','AP','AR','AS','BR','CG','CH','DD','DL','DN',
                       'GA','GJ','HP','HR','JH','JK','KA','KL','LD','MH',
                       'ML','MN','MP','MZ','NL','OR','PB','PY','RJ','SK',
                       'TN','TR','UK','UP','WB']
        }
    },
    10 =>
    {
        3 =>
        {
            desc   => "Dussehra (Maha Saptami)",
            states => ['SK','TR','WB']
        },
        4 =>
        {
            desc   => "Dussehra (Maha Ashtami)",
            states => ['AP','AR','AS','ML','MN','OR','TR','WB']
        },
        5 =>
        {
            desc   => "Dussehra (Maha Navami)",
            states => ['BR','KA','KL','ML','NL','PY','SK','TN','UK','UP',
                       'WB']
        },
        6 =>
        {
            desc   => "Dussehra (Vijay Dashami)",
            states => ['AN','AP','AS','BR','CG','CH','DD','DL','DN','GA',
                       'GJ','HP','HR','JK','KL','LD','MH','ML','MP','MZ',
                       'NL','OR','RJ','TN','TR','UK','UP','WB']
        },
        11 =>
        {
            desc   => "Lakshmi Puja/Birthday of Maharishi Valmiki Ji",
            states => ['HR','KA','PB','TR','WB']
        },
        25 =>
        {
            desc   => "Naraka Chaturdashi",
            states => ['KA']
        },
        26 =>
        {
            desc   => "Diwali",
            states => ['AN','AP','AR','AS','BR','CG','CH','DD','DL','DN',
                       'GA','GJ','HP','HR','JH','JK','KL','LD','MH','ML',
                       'MP','MZ','NL','OR','PB','PY','RJ','SK','TN','TR',
                       'UK','UP','WB']
        },
        27 =>
        {
            desc   => "Balipadyami Diwali",
            states => ['GJ','HR','KA','MH','UK','UP']
        },
        28 =>
        {
            desc   => "Bhai Duj/Chitragupta Jayanti",
            states => ['MH','UK','UP']
        }
    },
    11 =>
    {
        1 =>
        {
            desc   => "Kannada Rajyothsava/Haryana Day",
            states => ['KA','HR']
        },
        7 =>
        {
            desc   => "Idul Zuha",
            states => ['AN','AP','AR','AS','BR','CG','DD','DL','DN','GJ',
                       'HR','JH','JK','KA','KL','LD','MH','ML','MN','MP',
                       'NL','OR','PY','RJ','TN','TR','UK','UP','WB']
        },
        10 =>
        {
            desc   => "Guru Nanak Jayanti",
            states => ['AN','CG','CH','DL','HP','HR','JK','MH','MP','NL',
                       'PB','RJ','UK','UP','WB']
        },
        14 =>
        {   desc   => "Kanaka Jayanti",
                states => ['KA']
        }
    },
    12 =>
    {
        6 =>
        {
            desc   => "Muharram",
            states => ['AN','AP','BR','CG','CH','DL','HP','JK','KA','MH',
                       'MP','OR','RJ','TN','UK','UP','WB']
        },
        25 =>
        {
            desc   => "Christmas Day",
            states => ['AN','AP','AR','AS','BR','CG','CH','DD','DL','DN',
                       'GA','GJ','HP','JK','KA','KL','LD','MH','ML','MN',
                       'MP','MZ','NL','OR','PB','PY','RJ','SK','TN','TR',
                       'UK','UP','WB']
        }
    }
};

Readonly my $REGIONAL =>
{
    # http://www.qppstudio.net/publicholidays2012/india.htm
    2012 => $HOLIDAYS_2012,
    # http://www.qppstudio.net/publicholidays2011/india.htm
    2011 => $HOLIDAYS_2011,
};

=head1 DESCRIPTION

India,  being  a  culturally  and religiously diverse society, celebrates various holidays and
festivals. There are three national holidays in India: states and regions have local festivals
depending  on  prevalent  religious  and  linguistic demographics. Popular religious festivals
include the Hindu festivals of  Diwali, Ganesh Chaturthi, Holi, Dussehra, Islamic festivals of
Eid ul-Fitr,  Eid al-Adha,  Mawlid an-Nabi and  Christian  festivals of Christmas  and days of
observances such as Good Friday are observed throughout the country.

Muharram,  mourning for the Prophet Muhammad's grandson is observed by some sects of Islam. In
addition the Sikh festivals such as  Guru Nanak Jayanti, the Christian festivals as Christmas,
Good Friday and  Jain  festivals like  Mahavir  Jayanti,  Paryushan  are celebrated in certain
areas  where  these  religions  have  a  significant following. The annual holidays are widely
observed  by  state  and local governments; however, they may alter the dates of observance or
add or subtract holidays according to local custom.

=cut

=head1 CONSTRUCTOR

The constructor can be created by passing the year in 4 digits form.Currently we have data for
year 2011 and upto March 2012.So the constructor would only accept either 2011 / 2012 as valid 
years.

    use strict; use warnings;
    use Date::Holidays::IND;

    my $ind_2011 = Date::Holidays::IND->new(2011);
    my $ind_2012 = Date::Holidays::IND->new(2012);

=cut

sub new
{
    my $class = shift;
    my $yyyy  = shift || $DEFAULT_YEAR;
    croak("ERROR: Valid years are 2011/2012.\n")
        unless ($yyyy =~ /2011|2012/);

    my $self  = { yyyy => $yyyy };
    $self->{national_holidays} = _build_national_holidays($yyyy);
    $self->{regional_holidays} = _build_regional_holidays($yyyy);
    $self->{state_holidays}    = _build_state_holidays($yyyy);
    $self->{holidays_table}    = _build_holidays_table($self->{state_holidays});

    bless $self, $class;

    return $self;
}

=head1 METHODS

=head2 get_national_holidays()

Returns National Holidays for the given year.

    use strict; use warnings;
    use Date::Holidays::IND;

    my $ind = Date::Holidays::IND->new(2011);
    my $national = $ind->get_national_holidays();
    print $ind->get($national);

=cut

sub get_national_holidays
{
    my $self = shift;

    return $self->{national_holidays};
}

=head2 get_regional_holidays()

Returns Regional Holidays for the given year.

    use strict; use warnings;
    use Date::Holidays::IND;

    my $ind = Date::Holidays::IND->new(2011);
    my $regional = $ind->get_regional_holidays();
    print $ind->get($regional);

=cut

sub get_regional_holidays
{
    my $self = shift;

    return $self->{regional_holidays};
}

=head2 get_state_holidays()

Returns State Holidays for the given year.

    use strict; use warnings;
    use Date::Holidays::IND;

    my $ind = Date::Holidays::IND->new(2011);
    my $state = $ind->get_state_holidays();
    print $ind->get($state);

=cut

sub get_state_holidays
{
    my $self = shift;
    my $code = shift;

    croak("ERROR: Invalid state code [$code].\n")
        unless exists($STATES->{$code});

    return $self->{state_holidays}->{$code};
}

=head2 get_holidays_table()

Returns Holidays Table for each state of India for the given year.

    use strict; use warnings;
    use Date::Holidays::IND;

    my $ind = Date::Holidays::IND->new(2011);
    print $ind->get_holidays_table();

=cut

sub get_holidays_table
{
    my $self = shift;

    my ($string);
    foreach (keys %{$self->{holidays_table}})
    {
        $string .= sprintf("%s: %d\n", $STATES->{$_}, $self->{holidays_table}->{$_});
    }

    return $string;
}

=head2 get_state_name()

Returns State Name for the given state code.

    use strict; use warnings;
    use Date::Holidays::IND;

    my $ind = Date::Holidays::IND->new(2011);
    my $state = $ind->get_state_name('BR');
    print "State: [$state]\n";

=cut

sub get_state_name
{
    my $self = shift;
    my $code = shift;

    croak("ERROR: Invalid state code [$code].\n")
        unless exists($STATES->{$code});
    return $STATES->{$code};
}

=head2 as_string()

Returns all holidays in human readable format.

    use strict; use warnings;
    use Date::Holidays::IND;

    my $ind = Date::Holidays::IND->new(2011);
    print $ind->as_string();

    # or just simply
    print $ind;

=cut

sub as_string
{
    my $self = shift;

    my ($dow, $string, $type);
    foreach $type ('national_holidays','regional_holidays')
    {
        foreach (@{$self->{$type}})
        {
            $dow     = Day_of_Week($_->{yyyy}, $_->{mm}, $_->{dd});
            $string .= sprintf("%s, %02d %s %04d, %s.\n", $WEEKDAYS->[$dow], $_->{dd}, $MONTHS->[$_->{mm}], $_->{yyyy}, $_->{desc});
        }
        $string .= "-----------------------------------\n";
    }

    return $string;
}

=head2 get()

Returns given holidays in human readable format.

    use strict; use warnings;
    use Date::Holidays::IND;

    my $ind = Date::Holidays::IND->new(2011);
    my $state = $ind->get_state_holidays();
    print $ind->get($state);    

=cut

sub get
{
    my $self = shift;
    my $days = shift;

    my ($dow, $string);
    foreach (@{$days})
    {
        $dow     = Day_of_Week($_->{yyyy}, $_->{mm}, $_->{dd});
        $string .= sprintf("%s, %02d %s %04d, %s.\n", $WEEKDAYS->[$dow], $_->{dd}, $MONTHS->[$_->{mm}], $_->{yyyy}, $_->{desc});
    }
    return $string;
}

sub _build_national_holidays
{
    my $yyyy = shift;

    my $national_holidays;
    foreach (@$NATIONAL)
    {
        push @{$national_holidays},
            { yyyy => $yyyy,
                mm => $_->{mm},
                dd => $_->{dd},
              desc => $_->{desc} 
            };
    }
    return $national_holidays;
}

sub _build_regional_holidays
{
    my ($yyyy, $mm, $dd, $regional_holidays);
    $yyyy = shift;
    foreach $mm (sort keys %{$REGIONAL->{$yyyy}})
    {
        foreach $dd (sort keys %{$REGIONAL->{$yyyy}->{$mm}})
        {
            push @{$regional_holidays},
                { yyyy => $yyyy,
                    mm => $mm,
                    dd => $dd,
                  desc => $REGIONAL->{$yyyy}->{$mm}->{$dd}->{desc} 
                };
        }
    }
    return $regional_holidays;
}

sub _build_state_holidays
{
    my ($yyyy, $mm, $dd, $state, $state_holidays);
    $yyyy = shift;
    foreach $mm (sort keys %{$REGIONAL->{$yyyy}})
    {
        foreach $dd (sort keys %{$REGIONAL->{$yyyy}->{$mm}})
        {
            foreach $state (@{$REGIONAL->{$yyyy}->{$mm}->{$dd}->{states}})
            {
                push @{$state_holidays->{$state}},
                    { yyyy => $yyyy,
                        mm => $mm,
                        dd => $dd,
                      desc => $REGIONAL->{$yyyy}->{$mm}->{$dd}->{desc} 
                    };
            }
        }
    }
    return $state_holidays;
}

sub _build_holidays_table
{
    my ($state_holidays, $holidays_table);
    $state_holidays = shift;
    foreach (keys %{$state_holidays})
    {
        $holidays_table->{$_} = scalar(@{$state_holidays->{$_}});
    }
    return $holidays_table;
}

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar at yahoo.com> >>

=head1 BUGS

Please  report  any  bugs  or  feature requests to C<bug-date-holidays-ind at rt.cpan.org>, or
through the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Date-Holidays-IND>.
I  will  be  notified,  and then you'll automatically be notified of progress on your bug as I
make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Date::Holidays::IND

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Date-Holidays-IND>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Date-Holidays-IND>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Date-Holidays-IND>

=item * Search CPAN

L<http://search.cpan.org/dist/Date-Holidays-IND/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Mohammad S Anwar.

This  program  is  free  software; you can redistribute it and/or modify it under the terms of
either:  the  GNU  General Public License as published by the Free Software Foundation; or the
Artistic License.

See http://dev.perl.org/licenses/ for more information.

=head1 DISCLAIMER

This  program  is  distributed  in  the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

=cut

1; # End of Date::Holidays::IND