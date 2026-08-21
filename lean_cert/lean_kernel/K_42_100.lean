import Sound
import lean_certs.cert_42_100

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_100_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 42) (d := 100) (c := cert_42_100) (by decide)
