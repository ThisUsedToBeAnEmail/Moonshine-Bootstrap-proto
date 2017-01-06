use Test::More;
use Params::Validate qw/:all/;

subtest "well" => sub {
    my $params = {
        tag => 'p',
        class => 'one',
        button => {
            data => 'text'
        }
    };

    my (%thing1, %thing2) = validate_me($params);
};

sub validate_me {
    my ($hash1, $hash2) = validate_moon({
        params => $_[0],
        spec => {
            tag => 1,
            class => 1,
            button => 1,
        }
    });

    use Data::Dumper;
    warn Dumper $hash1;
    warn Dumper $hash2;
}

sub validate_moon {
    my %args = validate_with(
        params => $_[0],
        spec => {
            params => { type => HASHREF },
            spec => { type => HASHREF },
        }
    );

    my $html_spec = { };
    my $html_params = { };
    for my $element (qw/tag class/) {
        $html_spec->{$element} = delete $args{spec}->{$element};
        $html_params->{$element} = delete $args{params}->{$element};
    }

    my %hash1 = validate_with(
        params  => $html_params,
        spec    => $html_spec,
    );

    my %hash2 = validate_with(
        params  => $args{params}, 
        spec    => $args{spec},
    );

    return \%hash1, \%hash2;
}
