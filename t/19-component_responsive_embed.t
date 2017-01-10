use strict;
use warnings;
use Test::More;

BEGIN {
    use_ok('Moonshine::Bootstrap');
}

subtest "build" => sub {
    my $class = Moonshine::Bootstrap->new();

    component_test(
        {
            class  => $class,
            action => 'responsive_embed',
            args   => {
                ratio => '16by9',
                iframe => { src => '...' },
            },
            expected => '<div class="embed-responsive embed-responsive-16by9"><iframe class="embed-responsive-item" src="..."></iframe></div>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'responsive_embed',
            args   => {
                ratio => '4by3',
                iframe => { src => '...' },
            },
            expected => '<div class="embed-responsive embed-responsive-4by3"><iframe class="embed-responsive-item" src="..."></iframe></div>'
        }
    );

};

sub component_test {
    my $args = shift;

    my $action = $args->{action};
    my $element = $args->{class}->$action( $args->{args} // {} );
    return is( $element->render, $args->{expected},
        "got expected $args->{expected}" );
}

done_testing();
