use strict;
use warnings;

sub read_matrix {
    my ($filename) = @_;
    open(my $fh, '<', $filename) or die "Cannot open file $filename: $!";
    my $n = <$fh>;
    chomp($n);
    my @matrix;
    for (1 .. $n) {
        my $line = <$fh>;
        chomp($line);
        push @matrix, [split ' ', $line];
    }
    close $fh;
    return (\@matrix, $n);
}

sub write_matrix {
    my ($filename, $matrix) = @_;
    open(my $fh, '>', $filename) or die "Cannot open file $filename: $!";
    for my $row (@$matrix) {
        printf $fh "%.6f ", $_ for @$row;
        print $fh "\n";
    }
    close $fh;
}

sub gauss_jordan {
    my ($matrix, $n) = @_;
    my @identity = map { [(0) x $n] } (0 .. $n-1);
    $identity[$_][$_] = 1 for (0 .. $n-1);

    for my $i (0 .. $n-1) {
        if ($matrix->[$i][$i] == 0) {
            for my $j ($i+1 .. $n-1) {
                if ($matrix->[$j][$i] != 0) {
                    ($matrix->[$i], $matrix->[$j]) = ($matrix->[$j], $matrix->[$i]);
                    ($identity[$i], $identity[$j]) = ($identity[$j], $identity[$i]);
                    last;
                }
            }
        }

        my $pivot = $matrix->[$i][$i];
        for my $j (0 .. $n-1) {
            $matrix->[$i][$j] /= $pivot;
            $identity[$i][$j] /= $pivot;
        }

        for my $k (0 .. $n-1) {
            next if $k == $i;
            my $factor = $matrix->[$k][$i];
            for my $j (0 .. $n-1) {
                $matrix->[$k][$j] -= $factor * $matrix->[$i][$j];
                $identity[$k][$j] -= $factor * $identity[$i][$j];
            }
        }
    }

    return \@identity;
}

sub main {
    my ($matrix, $n) = read_matrix('input.txt');
    my $inverse = gauss_jordan($matrix, $n);
    write_matrix('output.txt', $inverse);
}

main();