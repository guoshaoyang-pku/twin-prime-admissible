import Sound
import lean_certs.cert_49_170

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_170_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 170 := by
  exact certValidRoot_sound (k := 49) (d := 170) (c := cert_49_170) (by decide)
