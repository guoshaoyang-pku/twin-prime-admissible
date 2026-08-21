import Sound
import lean_certs.cert_42_170

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_170_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 170 := by
  exact certValidRoot_sound (k := 42) (d := 170) (c := cert_42_170) (by decide)
