use strict;
use warnings;
use Test::More;

BEGIN {
    use_ok('Moonshine::Bootstrap');
}

subtest "build" => sub {
    my $class = Moonshine::Bootstrap->new();
    
    component_test({
        class => $class,
        action => 'nav',
        args => {
			type => 'tabs',
            items => [
				{
                    data => 'Home',
                    active => 1,
                },
                {
                    data => 'Profile',
                },
                {
                    data => 'Messages',
                }
			],
        },
        expected => '<ul class="nav nav-tabs"><li class="active" role="presentation"><a href="#">Home</a></li><li role="presentation"><a href="#">Profile</a></li><li role="presentation"><a href="#">Messages</a></li></ul>',
    });

    component_test({
        class => $class,
        action => 'nav',
        args => {
			type => 'pills',
            items => [
				{
                    data => 'Home',
                    active => 1,
                },
                {
                    data => 'Profile',
                },
                {
                    data => 'Messages',
                }
			],
        },
        expected => '<ul class="nav nav-pills"><li class="active" role="presentation"><a href="#">Home</a></li><li role="presentation"><a href="#">Profile</a></li><li role="presentation"><a href="#">Messages</a></li></ul>',
    });

    component_test({
        class => $class,
        action => 'nav',
        args => {
			type => 'pills',
            stacked => 1,
            items => [
				{
                    data => 'Home',
                    active => 1,
                },
                {
                    data => 'Profile',
                },
                {
                    data => 'Messages',
                }
			],
        },
        expected => '<ul class="nav nav-pills nav-stacked"><li class="active" role="presentation"><a href="#">Home</a></li><li role="presentation"><a href="#">Profile</a></li><li role="presentation"><a href="#">Messages</a></li></ul>',
    });
};

sub component_test {
    my $args = shift;

    my $action = $args->{action};
    my $element = $args->{class}->$action($args->{args} // {});
    return is($element->render, $args->{expected}, "got expected $args->{expected}");
}

done_testing();
