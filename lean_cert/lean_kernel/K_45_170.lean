import Sound
import lean_certs.cert_45_170

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_170_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 170 := by
  exact certValidRoot_sound (k := 45) (d := 170) (c := cert_45_170) (by decide)
