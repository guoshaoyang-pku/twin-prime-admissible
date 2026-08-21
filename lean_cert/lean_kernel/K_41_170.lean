import Sound
import lean_certs.cert_41_170

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H41_gt_170_kernel : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 170 := by
  exact certValidRoot_sound (k := 41) (d := 170) (c := cert_41_170) (by decide)
