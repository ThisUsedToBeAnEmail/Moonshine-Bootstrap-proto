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
            action => 'li',
            args   => {
                class => 'one',
            },
            expected => '<li class="one"></li>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'h1',
            args   => {
                class => 'one',
            },
            expected => '<h1 class="one"></h1>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'h2',
            args   => {
                class => 'one',
            },
            expected => '<h2 class="one"></h2>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'h3',
            args   => {
                class => 'one',
            },
            expected => '<h3 class="one"></h3>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'h4',
            args   => {
                class => 'one',
            },
            expected => '<h4 class="one"></h4>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'h5',
            args   => {
                class => 'one',
            },
            expected => '<h5 class="one"></h5>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'h6',
            args   => {
                class => 'one',
            },
            expected => '<h6 class="one"></h6>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'ul',
            args   => {
                class => 'one',
            },
            expected => '<ul class="one"></ul>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'td',
            args   => {
                class => 'one',
            },
            expected => '<td class="one"></td>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'tr',
            args   => {
                class => 'one',
            },
            expected => '<tr class="one"></tr>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'p',
            args   => {
                lead => 1,
            },
            expected => '<p class="lead"></p>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'mark',
            args     => { data => 'Some Text' },
            expected => '<mark>Some Text</mark>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'del',
            args     => { data => 'Some Text' },
            expected => '<del>Some Text</del>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 's',
            args     => { data => 'Some Text' },
            expected => '<s>Some Text</s>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'ins',
            args     => { data => 'Some Text' },
            expected => '<ins>Some Text</ins>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'u',
            args     => { data => 'Some Text' },
            expected => '<u>Some Text</u>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'small',
            args     => { data => 'Some Text' },
            expected => '<small>Some Text</small>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'strong',
            args     => { data => 'Some Text' },
            expected => '<strong>Some Text</strong>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'em',
            args     => { data => 'Some Text' },
            expected => '<em>Some Text</em>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'abbr',
            args     => {
                title => 'HyperText Markup Language',
                data  => 'HTML'
            },
            expected => '<abbr title="HyperText Markup Language">HTML</abbr>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'abbr',
            args     => {
                title => 'HyperText Markup Language',
                data  => 'HTML',
                initialism => 1,
            },
            expected => '<abbr class="initialism" title="HyperText Markup Language">HTML</abbr>',
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'address',
            args     => {},
            expected => '<address></address>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'address',
            args     => {
                children => [
                    {
                        action => 'strong',
                        data => 'Full Name',
                    },
                    {
                        action => 'a',
                        href => 'mailto:#',
                        data => 'first.last@example.com',
                    }
                ],    
            },
            expected => '<address><strong>Full Name</strong><a href="mailto:#">first.last@example.com</a></address>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'blockquote',
            args     => {},
            expected => '<blockquote></blockquote>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'blockquote',
            args     => {
                children => [
                    {
                        action => 'p',
                        data => 'Full Name',
                    },
                ],    
            },
            expected => '<blockquote><p>Full Name</p></blockquote>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'footer',
            args     => {},
            expected => '<footer></footer>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'cite',
            args     => {},
            expected => '<cite></cite>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'footer',
            args     => {
                children => [
                    {
                        action => 'cite',
                        title => 'Full Name',
                        data => 'Full Name',
                    },
                ],    
            },
            expected => '<footer><cite title="Full Name">Full Name</cite></footer>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'address',
            args     => {
                children => [
                    {
                        action => 'strong',
                        data => 'Full Name',
                    },
                    {
                        action => 'footer',
                        data => 'Someone famous in',
                        children => [
                            {
                                action => 'cite',
                                title => 'Source Title',
                                data => 'Source Title',
                            }
                        ]
                    }
                ],    
            },
            expected => '<address><strong>Full Name</strong><footer>Someone famous in<cite title="Source Title">Source Title</cite></footer></address>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'ul',
            args     => { inline => 1 },
            expected => '<ul class="list-inline"></ul>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'ul',
            args     => { unstyle => 1 },
            expected => '<ul class="list-unstyled"></ul>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'dl',
            args     => { },
            expected => '<dl></dl>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'dt',
            args     => { },
            expected => '<dt></dt>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'dd',
            args     => { },
            expected => '<dd></dd>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'code',
            args     => { },
            expected => '<code></code>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'code',
            args     => { },
            expected => '<code></code>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'p',
            args     => { data => [ 'For example,', { tag => 'code', data => '&lt;section&gt;' }, 'should be wrapped as inline.' ] },
            expected => '<p>For example, <code>&lt;section&gt;</code> should be wrapped as inline.</p>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'kbd',
            args     => { },
            expected => '<kbd></kbd>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'p',
            args     => { data => [ 'To switch directories, type', { tag => 'kbd', data => 'cd' }, 'followed by the name of the directory' ] },
            expected => '<p>To switch directories, type <kbd>cd</kbd> followed by the name of the directory</p>'
        }
    );

};

sub component_test {
    my $args = shift;

    my $action = $args->{action};
    my $element = $args->{class}->$action( $args->{args} // {} );
    is( $element->render, $args->{expected}, "got expected $args->{expected}" );
}

done_testing();
